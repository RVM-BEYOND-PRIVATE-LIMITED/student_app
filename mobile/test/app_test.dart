import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rvm_student/core/app_info.dart';
import 'package:rvm_student/core/crash/crash_log.dart';
import 'package:rvm_student/core/env/student_env.dart';
import 'package:rvm_student/core/version/version_gate.dart';
import 'package:rvm_student/features/connectivity/offline_banner.dart';
import 'package:rvm_student/features/dev_menu/dev_menu_screen.dart';
import 'package:rvm_student/features/language/language_screen.dart';
import 'package:rvm_student/features/language/language_store.dart';
import 'package:rvm_student/features/update_required/update_required_screen.dart';
import 'package:rvm_student/features/welcome/welcome_screen.dart';
import 'package:rvm_student/injection.dart';
import 'package:rvm_student/l10n/l10n.dart';
import 'package:rvm_student/router/app_router.dart';

import 'support/app_harness.dart';
import 'support/fakes.dart';
import 'support/screen.dart';

void main() {
  late AppLocalizationsPair l10n;

  setUpAll(() async {
    l10n = AppLocalizationsPair(
      en: await l10nFor(english),
      hi: await l10nFor(hindi),
    );
  });

  group('first launch (item 8)', () {
    testWidgets('asks for the language, in the phone\'s language', (
      tester,
    ) async {
      await AppHarness().launch(tester);

      expect(find.byType(LanguageScreen), findsOneWidget);
      expect(find.text(l10n.en.languageTitle), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('हिन्दी'), findsOneWidget);
    });

    testWidgets('a Hindi phone sees the language screen in Hindi', (
      tester,
    ) async {
      await AppHarness(deviceLocales: const [hindi]).launch(tester);

      expect(find.text(l10n.hi.languageTitle), findsOneWidget);
      // "English" is the English option's own name, written so a student
      // who reads only English can find it.
      expect(englishOnScreen(tester, allowed: {'RVM', 'English'}), isEmpty);
    });

    testWidgets(
      'check 2: choosing Hindi switches every word at once, and the choice '
      'survives a restart',
      (tester) async {
        final phone = FakeSecureStore();
        await AppHarness(store: phone).launch(tester);

        await tester.tap(find.text('हिन्दी'));
        await tester.pumpAndSettle();
        expect(find.text(l10n.hi.languageTitle), findsOneWidget);
        expect(englishOnScreen(tester, allowed: {'RVM', 'English'}), isEmpty);
        expect(phone.values[LanguageStore.key], 'hi');

        await tester.tap(find.text(l10n.hi.languageContinue));
        await tester.pumpAndSettle();
        expect(find.byType(WelcomeScreen), findsOneWidget);
        expect(find.text(l10n.hi.welcomeTitle), findsOneWidget);
        expect(englishOnScreen(tester), isEmpty);

        // Restart: a new app on the same phone storage.
        await AppHarness(store: phone).launch(tester);

        expect(find.byType(LanguageScreen), findsNothing);
        expect(find.byType(WelcomeScreen), findsOneWidget);
        expect(find.text(l10n.hi.welcomeTitle), findsOneWidget);
        expect(englishOnScreen(tester), isEmpty);
      },
    );

    testWidgets('Continue keeps the suggested language as the choice', (
      tester,
    ) async {
      final phone = FakeSecureStore();
      await AppHarness(store: phone).launch(tester);

      await tester.tap(find.text(l10n.en.languageContinue));
      await tester.pumpAndSettle();

      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(phone.values[LanguageStore.key], 'en');
    });

    testWidgets('the language can be changed later from the welcome screen', (
      tester,
    ) async {
      final phone = FakeSecureStore({LanguageStore.key: 'en'});
      await AppHarness(store: phone).launch(tester);

      await tester.tap(find.text(l10n.en.changeLanguage));
      await tester.pumpAndSettle();
      await tester.tap(find.text('हिन्दी'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.hi.languageContinue));
      await tester.pumpAndSettle();

      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.text(l10n.hi.welcomeTitle), findsOneWidget);
      expect(phone.values[LanguageStore.key], 'hi');
    });
  });

  group('version gate at launch (item 10)', () {
    testWidgets('a build older than the minimum is held on Update required', (
      tester,
    ) async {
      final source = FakeVersionSource(
        () async => const MinimumVersionKnown('0.2.0'),
      );
      await AppHarness(
        store: FakeSecureStore({LanguageStore.key: 'hi'}),
        versionSource: source,
      ).launch(tester);

      expect(find.byType(UpdateRequiredScreen), findsOneWidget);
      expect(find.textContaining('0.1.0'), findsOneWidget);
      expect(find.textContaining('0.2.0'), findsOneWidget);
      expect(englishOnScreen(tester), isEmpty);

      // The system back gesture does not get past it.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(UpdateRequiredScreen), findsOneWidget);
    });

    testWidgets('"Check again" opens the app once the build is new enough', (
      tester,
    ) async {
      var minimum = '0.2.0';
      await AppHarness(
        store: FakeSecureStore({LanguageStore.key: 'en'}),
        versionSource: FakeVersionSource(
          () async => MinimumVersionKnown(minimum),
        ),
      ).launch(tester);
      expect(find.byType(UpdateRequiredScreen), findsOneWidget);

      minimum = '0.1.0';
      await tester.tap(find.text(l10n.en.updateRequiredCheckAgain));
      await tester.pumpAndSettle();

      expect(find.byType(WelcomeScreen), findsOneWidget);
    });

    testWidgets('a check that fails lets the app open (fail open)', (
      tester,
    ) async {
      await AppHarness(
        store: FakeSecureStore({LanguageStore.key: 'en'}),
        versionSource: FakeVersionSource(() async => throw Exception('down')),
      ).launch(tester);

      expect(find.byType(WelcomeScreen), findsOneWidget);
    });

    testWidgets('a build that cannot read its own version is never held '
        '(fail open)', (tester) async {
      final source = FakeVersionSource(
        () async => const MinimumVersionKnown('9.0.0'),
      );
      await AppHarness(
        store: FakeSecureStore({LanguageStore.key: 'en'}),
        versionSource: source,
        // What AppInfo.load gives when Android cannot say.
        appInfo: const AppInfo(
          version: '0.0.0',
          buildNumber: '0',
          isKnown: false,
        ),
      ).launch(tester);

      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.byType(UpdateRequiredScreen), findsNothing);
    });

    testWidgets('a build that cannot read its own version sends no '
        'X-App-Version, so no server minimum refuses it', (tester) async {
      final adapter = ScriptedAdapter((_, _) => jsonReply(200, {'ok': true}));
      await AppHarness(
        store: FakeSecureStore({LanguageStore.key: 'en'}),
        httpAdapter: adapter,
        appInfo: const AppInfo(
          version: '0.0.0',
          buildNumber: '0',
          isKnown: false,
        ),
      ).launch(tester);

      await _send(tester);

      expect(adapter.seen.single.header('X-App-Version'), isNull);
      expect(adapter.seen.single.header('User-Agent'), 'RVM-Student (Android)');
    });

    testWidgets('this build publishes no minimum, so it opens', (tester) async {
      await AppHarness(
        store: FakeSecureStore({LanguageStore.key: 'en'}),
      ).launch(tester);

      expect(find.byType(WelcomeScreen), findsOneWidget);
    });
  });

  group('offline banner (shared states)', () {
    testWidgets('shows while the phone is offline, in the chosen language', (
      tester,
    ) async {
      final app = AppHarness(store: FakeSecureStore({LanguageStore.key: 'hi'}));
      await app.launch(tester);
      expect(find.byType(OfflineBar), findsNothing);

      app.online.add(false);
      await tester.pumpAndSettle();
      expect(find.byType(OfflineBar), findsOneWidget);
      expect(find.text(l10n.hi.offlineBanner), findsOneWidget);
      expect(englishOnScreen(tester), isEmpty);

      app.online.add(true);
      await tester.pumpAndSettle();
      expect(find.byType(OfflineBar), findsNothing);
    });

    testWidgets('goes away once a check finds the internet again, with no '
        'word from the network', (tester) async {
      var reachable = false;
      var checks = 0;
      final app = AppHarness(
        store: FakeSecureStore({LanguageStore.key: 'en'}),
        connectivityCheck: () async {
          checks++;
          return reachable;
        },
      );
      await app.launch(tester);
      app.online.add(false);
      await tester.pumpAndSettle();
      expect(find.byType(OfflineBar), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(checks, 1);
      expect(find.byType(OfflineBar), findsOneWidget, reason: 'still offline');

      reachable = true;
      await tester.pump(const Duration(seconds: 10));
      await tester.pumpAndSettle();
      expect(checks, 2);
      expect(find.byType(OfflineBar), findsNothing);
    });

    testWidgets('checks again when the app comes back to the foreground', (
      tester,
    ) async {
      var reachable = false;
      var checks = 0;
      final app = AppHarness(
        store: FakeSecureStore({LanguageStore.key: 'en'}),
        connectivityCheck: () async {
          checks++;
          return reachable;
        },
      );
      await app.launch(tester);
      app.online.add(false);
      await tester.pumpAndSettle();
      expect(find.byType(OfflineBar), findsOneWidget);

      // The student leaves the app and the network recovers meanwhile.
      for (final state in [
        AppLifecycleState.inactive,
        AppLifecycleState.hidden,
        AppLifecycleState.paused,
      ]) {
        tester.binding.handleAppLifecycleStateChanged(state);
      }
      reachable = true;
      expect(checks, 0);
      for (final state in [
        AppLifecycleState.hidden,
        AppLifecycleState.inactive,
        AppLifecycleState.resumed,
      ]) {
        tester.binding.handleAppLifecycleStateChanged(state);
      }
      await tester.pumpAndSettle();

      expect(checks, 1, reason: 'checked at once, not after the back-off');
      expect(find.byType(OfflineBar), findsNothing);
    });
  });

  group('Accept-Language follows the app (item 8)', () {
    testWidgets('every call carries the language on screen', (tester) async {
      final adapter = ScriptedAdapter((_, _) => jsonReply(200, {'ok': true}));
      await AppHarness(
        store: FakeSecureStore({LanguageStore.key: 'en'}),
        httpAdapter: adapter,
      ).launch(tester);

      await _send(tester);
      await tester.tap(find.text(l10n.en.changeLanguage));
      await tester.pumpAndSettle();
      await tester.tap(find.text('हिन्दी'));
      await tester.pumpAndSettle();
      await _send(tester);

      expect(adapter.seen.map((r) => r.header('Accept-Language')), [
        'en',
        'hi',
      ]);
      expect(adapter.seen.map((r) => r.header('X-App-Version')), [
        '0.1.0',
        '0.1.0',
      ]);
      expect(
        adapter.seen.first.header('User-Agent'),
        'RVM-Student/0.1.0 (Android)',
      );
    });
  });

  group('Developer menu (dev builds only)', () {
    /// A tall phone, so every row of the menu is built and checked.
    Future<void> openDevMenu(WidgetTester tester, AppHarness app) async {
      useSurface(tester, const Size(420, 1800));
      await app.launch(tester);
      final l = app.store.values[LanguageStore.key] == 'hi' ? l10n.hi : l10n.en;
      await tester.tap(find.text(l.openDeveloperMenu));
      await tester.pumpAndSettle();
      expect(find.byType(DevMenuScreen), findsOneWidget);
    }

    testWidgets('shows the build, the host and what waits for the server', (
      tester,
    ) async {
      await openDevMenu(
        tester,
        AppHarness(store: FakeSecureStore({LanguageStore.key: 'en'})),
      );

      expect(find.text(l10n.en.devFlavorDev), findsOneWidget);
      expect(find.text('http://127.0.0.1:3000'), findsOneWidget);
      expect(find.text(l10n.en.devHostDefault), findsOneWidget);
      expect(find.text('0.1.0 (1)'), findsOneWidget);
      expect(find.text(l10n.en.devNotYet), findsNWidgets(3));
      expect(find.text(l10n.en.devNo), findsOneWidget);
    });

    testWidgets('is all Hindi in Hindi, down to the shared states', (
      tester,
    ) async {
      await openDevMenu(
        tester,
        AppHarness(store: FakeSecureStore({LanguageStore.key: 'hi'})),
      );
      expect(englishOnScreen(tester), isEmpty);

      await tester.tap(find.text(l10n.hi.devSharedStates));
      await tester.pumpAndSettle();
      for (final tab in [
        l10n.hi.gallerySkeleton,
        l10n.hi.galleryEmpty,
        l10n.hi.galleryError,
        l10n.hi.galleryOffline,
      ]) {
        await tester.tap(
          find.descendant(of: find.byType(TabBar), matching: find.text(tab)),
        );
        await tester.pumpAndSettle();
        expect(englishOnScreen(tester), isEmpty, reason: tab);
      }
    });

    testWidgets('records a test error into the on-device crash log', (
      tester,
    ) async {
      final crashLog = MemoryCrashLogStore();
      final app = AppHarness(
        store: FakeSecureStore({LanguageStore.key: 'hi'}),
        crashLog: crashLog,
      );
      final previous = CrashLog.store;
      CrashLog.store = crashLog;
      addTearDown(() => CrashLog.store = previous);
      await openDevMenu(tester, app);

      await tester.tap(find.text(l10n.hi.devRecordTestError));
      await tester.pumpAndSettle();
      expect(await crashLog.read(), hasLength(1));

      await tester.tap(find.text(l10n.hi.devCrashLog));
      await tester.pumpAndSettle();
      expect(find.text(l10n.hi.devCrashLogNote), findsOneWidget);
      expect(find.textContaining('Test error recorded'), findsOneWidget);
      expect(englishOnScreen(tester), isEmpty);

      await tester.tap(find.text(l10n.hi.devCrashLogClear));
      await tester.pumpAndSettle();
      expect(find.text(l10n.hi.devCrashLogEmpty), findsOneWidget);
    });

    testWidgets('a prod build has no Developer menu', (tester) async {
      await AppHarness(
        store: FakeSecureStore({LanguageStore.key: 'en'}),
        env: StudentEnv.resolve(
          flavor: 'prod',
          host: 'https://api.example.test',
        ),
      ).launch(tester);

      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.text(l10n.en.openDeveloperMenu), findsNothing);
    });

    for (final (name, env) in [
      (
        'FLAVOR=prod',
        StudentEnv.resolve(flavor: 'prod', host: 'https://api.example.test'),
      ),
      (
        'a release build with no FLAVOR',
        StudentEnv.resolve(
          flavor: '',
          host: 'https://api.example.test',
          releaseMode: true,
        ),
      ),
    ]) {
      testWidgets('$name: the Developer menu cannot be reached, not even by '
          'its address', (tester) async {
        await AppHarness(
          store: FakeSecureStore({LanguageStore.key: 'en'}),
          env: env,
        ).launch(tester);
        expect(find.text(l10n.en.openDeveloperMenu), findsNothing);

        for (final location in [
          Routes.devMenu,
          Routes.devStates,
          Routes.devCrashLog,
        ]) {
          GoRouter.of(tester.element(find.byType(WelcomeScreen))).go(location);
          await tester.pumpAndSettle();

          expect(find.byType(DevMenuScreen), findsNothing, reason: location);
          expect(find.byType(WelcomeScreen), findsOneWidget, reason: location);
        }
      });
    }
  });
}

/// One call through the app's Student API client, driven by the test clock:
/// the client and the session live in the test's fake-async zone.
Future<void> _send(WidgetTester tester) async {
  var done = false;
  Object? failure;
  unawaited(
    getIt<Dio>()
        .get<dynamic>('/a')
        .then((_) => done = true, onError: (Object e) => failure = e),
  );
  for (var i = 0; i < 100 && !done && failure == null; i++) {
    await tester.pump(const Duration(milliseconds: 10));
  }
  expect(failure, isNull);
  expect(done, isTrue);
}

/// English and Hindi wording side by side.
class AppLocalizationsPair {
  AppLocalizationsPair({required this.en, required this.hi});

  final AppLocalizations en;
  final AppLocalizations hi;
}
