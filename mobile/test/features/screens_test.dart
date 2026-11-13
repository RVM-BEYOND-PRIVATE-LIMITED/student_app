import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rvm_student/app_crash.dart';
import 'package:rvm_student/config_error_app.dart';
import 'package:rvm_student/core/version/version_gate.dart';
import 'package:rvm_student/features/dev_menu/dev_menu_screen.dart';
import 'package:rvm_student/features/language/language_screen.dart';
import 'package:rvm_student/features/language/language_store.dart';
import 'package:rvm_student/features/splash/splash_screen.dart';
import 'package:rvm_student/features/update_required/update_required_screen.dart';
import 'package:rvm_student/features/welcome/welcome_screen.dart';
import 'package:rvm_student/l10n/l10n.dart';
import 'package:rvm_student/router/app_router.dart';

import '../support/app_harness.dart';
import '../support/fakes.dart';
import '../support/screen.dart';

void main() {
  late AppLocalizations en;
  late AppLocalizations hi;

  setUpAll(() async {
    en = await l10nFor(english);
    hi = await l10nFor(hindi);
  });

  group('Splash', () {
    for (final locale in [english, hindi]) {
      testWidgets(
        'shows the logo and the loading line (${locale.languageCode})',
        (tester) async {
          await tester.pumpWidget(
            localized(const SplashScreen(), locale: locale),
          );
          await tester.pump(const Duration(milliseconds: 300));

          final l10n = locale == hindi ? hi : en;
          expect(find.text(l10n.splashLoading), findsOneWidget);
          expect(find.bySemanticsLabel(l10n.appTitle), findsOneWidget);
          if (locale == hindi) expect(englishOnScreen(tester), isEmpty);
        },
      );
    }

    testWidgets('is shown while the launch checks run', (tester) async {
      final app = AppHarness(
        versionSource: FakeVersionSource(
          () => Future<MinimumVersion>.delayed(
            const Duration(seconds: 2),
            () => const MinimumVersionUnknown(),
          ),
        ),
      );
      await app.launch(tester, settle: false);
      await tester.pump();

      expect(find.byType(SplashScreen), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.byType(SplashScreen), findsNothing);
      expect(find.byType(LanguageScreen), findsOneWidget);
    });
  });

  group('a small phone, large text, Hindi: nothing overflows', () {
    Future<void> onSmallPhone(WidgetTester tester) async {
      useSurface(tester, smallPhone);
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    }

    testWidgets('Language', (tester) async {
      await onSmallPhone(tester);
      await AppHarness(deviceLocales: const [hindi]).launch(tester);

      expect(find.byType(LanguageScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(englishOnScreen(tester, allowed: {'RVM', 'English'}), isEmpty);
    });

    testWidgets('Update required', (tester) async {
      await onSmallPhone(tester);
      await AppHarness(
        store: FakeSecureStore({LanguageStore.key: 'hi'}),
        versionSource: FakeVersionSource(
          () async => const MinimumVersionKnown('10.20.30'),
        ),
      ).launch(tester);

      expect(find.byType(UpdateRequiredScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(englishOnScreen(tester), isEmpty);
    });

    testWidgets('Welcome and Developer menu', (tester) async {
      await onSmallPhone(tester);
      await AppHarness(
        store: FakeSecureStore({LanguageStore.key: 'hi'}),
      ).launch(tester);

      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(englishOnScreen(tester), isEmpty);

      final context = tester.element(find.byType(WelcomeScreen));
      unawaited(GoRouter.of(context).push(Routes.devMenu));
      await tester.pumpAndSettle();
      expect(find.byType(DevMenuScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(englishOnScreen(tester), isEmpty);
    });
  });

  group('a build that must not start', () {
    testWidgets('says so in the phone\'s language and calls nothing', (
      tester,
    ) async {
      tester.platformDispatcher.localesTestValue = const [hindi];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);

      await tester.pumpWidget(const ConfigErrorApp());
      await tester.pumpAndSettle();

      expect(find.text(hi.configErrorTitle), findsOneWidget);
      expect(find.text(hi.configErrorBody), findsOneWidget);
      expect(englishOnScreen(tester), isEmpty);
    });

    testWidgets('in English on an English phone', (tester) async {
      tester.platformDispatcher.localesTestValue = const [english];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);

      await tester.pumpWidget(const ConfigErrorApp());
      await tester.pumpAndSettle();

      expect(find.text(en.configErrorTitle), findsOneWidget);
    });
  });

  group('a widget that fails to build', () {
    testWidgets('shows a calm message in the app\'s language, not red text', (
      tester,
    ) async {
      await tester.pumpWidget(localized(const SafeErrorView(), locale: hindi));

      expect(find.text(hi.fatalErrorBody), findsOneWidget);
      expect(englishOnScreen(tester), isEmpty);
    });

    testWidgets('outside the app\'s translations it falls back to English', (
      tester,
    ) async {
      await tester.pumpWidget(const SafeErrorView());

      expect(find.textContaining('Something went wrong'), findsOneWidget);
    });
  });
}
