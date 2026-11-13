import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rvm_student/core/security/device_hints.dart';
import 'package:rvm_student/features/dev_menu/dev_menu_screen.dart';
import 'package:rvm_student/features/language/language_store.dart';
import 'package:rvm_student/features/welcome/welcome_screen.dart';
import 'package:rvm_student/l10n/l10n.dart';
import 'package:rvm_student/router/app_router.dart';

import '../../support/app_harness.dart';
import '../../support/fakes.dart';
import '../../support/screen.dart';

class _MockDeviceInfo extends Mock implements DeviceInfoPlugin {}

class _MockAndroidInfo extends Mock implements AndroidDeviceInfo {}

/// student_app #8, item 2: the device hints. MainActivity answers root and
/// the debugger on `rvm_student/device_hints`, device_info_plus the
/// emulator. Both are faked here.
const _channel = MethodChannel(PlatformDeviceHints.channelName);

/// Makes MainActivity answer [answer] (or fail with [error]); returns the
/// methods it was asked.
List<String> _mockChannel({Object? answer, Object? error}) {
  final calls = <String>[];
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_channel, (call) async {
        calls.add(call.method);
        if (error != null) throw error;
        return answer;
      });
  addTearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null),
  );
  return calls;
}

DeviceInfoPlugin _deviceInfo({bool? physical, Object? error}) {
  final plugin = _MockDeviceInfo();
  if (error != null) {
    when(() => plugin.androidInfo).thenThrow(error);
  } else {
    final info = _MockAndroidInfo();
    when(() => info.isPhysicalDevice).thenReturn(physical!);
    when(() => plugin.androidInfo).thenAnswer((_) async => info);
  }
  return plugin;
}

void main() {
  late AppLocalizations en;
  late AppLocalizations hi;

  setUpAll(() async {
    en = await l10nFor(english);
    hi = await l10nFor(hindi);
  });

  group('PlatformDeviceHints', () {
    setUp(TestWidgetsFlutterBinding.ensureInitialized);

    test('reads root and the debugger from MainActivity and the emulator '
        'from device_info_plus', () async {
      final calls = _mockChannel(
        answer: {'rootSuspected': true, 'debuggerAttached': false},
      );
      final hints = await PlatformDeviceHints(
        deviceInfo: _deviceInfo(physical: false),
      ).read();

      expect(calls, ['read']);
      expect(
        hints,
        const DeviceHints(
          rootSuspected: true,
          emulator: true,
          debuggerAttached: false,
        ),
      );
    });

    test('a normal phone: every hint is false', () async {
      _mockChannel(answer: {'rootSuspected': false, 'debuggerAttached': false});
      final hints = await PlatformDeviceHints(
        deviceInfo: _deviceInfo(physical: true),
      ).read();

      expect(
        hints,
        const DeviceHints(
          rootSuspected: false,
          emulator: false,
          debuggerAttached: false,
        ),
      );
      expect(hints.notes(en), isEmpty);
    });

    test('what cannot be read is unknown, never an error', () async {
      _mockChannel(error: PlatformException(code: 'boom'));
      final hints = await PlatformDeviceHints(
        deviceInfo: _deviceInfo(error: StateError('no plugin')),
      ).read();

      expect(hints, DeviceHints.unknown);
    });

    test(
      'without MainActivity (no handler) root and debugger are unknown',
      () async {
        final hints = await PlatformDeviceHints(
          deviceInfo: _deviceInfo(physical: true),
        ).read();

        expect(hints, const DeviceHints(emulator: false));
      },
    );

    test('an answer of the wrong shape is unknown', () async {
      _mockChannel(answer: {'rootSuspected': 'yes', 'debuggerAttached': 1});
      final hints = await PlatformDeviceHints(
        deviceInfo: _deviceInfo(physical: true),
      ).read();

      expect(hints.rootSuspected, isNull);
      expect(hints.debuggerAttached, isNull);
    });

    test('asks nothing where it is not Android', () async {
      final calls = _mockChannel(answer: {'rootSuspected': true});
      final deviceInfo = _MockDeviceInfo();
      final hints = await PlatformDeviceHints(
        deviceInfo: deviceInfo,
        supported: () => false,
      ).read();

      expect(hints, DeviceHints.unknown);
      expect(calls, isEmpty);
      verifyZeroInteractions(deviceInfo);
    });
  });

  group('notes: words for a message, one per true hint', () {
    const all = DeviceHints(
      rootSuspected: true,
      emulator: true,
      debuggerAttached: true,
    );

    test('in English and in Hindi', () {
      expect(all.notes(en), [
        en.deviceHintRooted,
        en.deviceHintEmulator,
        en.deviceHintDebugger,
      ]);
      expect(all.notes(hi), [
        hi.deviceHintRooted,
        hi.deviceHintEmulator,
        hi.deviceHintDebugger,
      ]);
      for (final note in all.notes(hi)) {
        expect(note, isNot(matches(RegExp('[A-Za-z]'))), reason: note);
      }
    });

    test('a false or unknown hint adds nothing', () {
      expect(const DeviceHints(emulator: true).notes(en), [
        en.deviceHintEmulator,
      ]);
      expect(DeviceHints.unknown.notes(en), isEmpty);
    });
  });

  group('for messages only, never the decision', () {
    test('only the wiring and the Developer menu use the hints', () {
      // Anything that could refuse, hide or limit (the router, the launch
      // checks, a screen's bloc) must not read them: the server decides
      // (Scheduler_Backend #159, #192).
      final users = [
        for (final file in Directory('lib').listSync(recursive: true))
          if (file is File &&
              file.path.endsWith('.dart') &&
              !file.path.contains('/l10n/gen/') &&
              file.readAsStringSync().contains('security/device_hints.dart'))
            file.path.replaceAll(r'\', '/'),
      ]..sort();

      expect(users, [
        'lib/app.dart',
        'lib/features/dev_menu/dev_menu_screen.dart',
        'lib/injection.dart',
      ]);
    });

    test('MainActivity answers the channel and lists no installed app', () {
      final activity = File(
        'android/app/src/main/kotlin/com/rvm/rvmstudent/MainActivity.kt',
      ).readAsStringSync();

      expect(activity, contains('"${PlatformDeviceHints.channelName}"'));
      expect(activity, contains('"read" ->'));
      expect(activity, contains('"rootSuspected" to rootSuspected()'));
      expect(
        activity,
        contains('"debuggerAttached" to Debug.isDebuggerConnected()'),
      );
      expect(activity, isNot(contains('getInstalledPackages')));
      expect(
        File('android/app/src/main/AndroidManifest.xml').readAsStringSync(),
        isNot(contains('QUERY_ALL_PACKAGES')),
      );
    });
  });

  group('the Developer menu shows them', () {
    Future<void> openMenu(WidgetTester tester, String language) async {
      await AppHarness(
        store: FakeSecureStore({LanguageStore.key: language}),
        deviceHints: const FakeDeviceHints(
          DeviceHints(rootSuspected: true, emulator: false),
        ),
      ).launch(tester);
      final router = GoRouter.of(tester.element(find.byType(WelcomeScreen)));
      unawaited(router.push(Routes.devMenu));
      await tester.pumpAndSettle();
      expect(find.byType(DevMenuScreen), findsOneWidget);
    }

    /// The menu's own list (the Welcome screen is still built below it).
    Finder menuList() => find
        .descendant(
          of: find.byType(DevMenuScreen),
          matching: find.byType(Scrollable),
        )
        .first;

    testWidgets('yes, no, or could not tell', (tester) async {
      await openMenu(tester, 'en');
      await tester.scrollUntilVisible(
        find.text(en.devHintsNote),
        100,
        scrollable: menuList(),
      );

      // Each row is its label over its value, in one column.
      void expectRow(String label, String value) {
        final row = find
            .ancestor(of: find.text(label), matching: find.byType(Column))
            .first;
        expect(
          find.descendant(of: row, matching: find.text(value)),
          findsOneWidget,
          reason: label,
        );
      }

      expectRow(en.devHintRooted, en.devYes);
      expectRow(en.devHintEmulator, en.devNo);
      expectRow(en.devHintDebugger, en.devUnknown);
      expect(find.text(en.devHintsNote), findsOneWidget);
    });

    testWidgets('in Hindi, on a small phone, with large text', (tester) async {
      useSurface(tester, smallPhone);
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await openMenu(tester, 'hi');
      await tester.scrollUntilVisible(
        find.text(hi.devHintsNote),
        100,
        scrollable: menuList(),
      );

      expect(tester.takeException(), isNull);
      expect(englishOnScreen(tester), isEmpty);
    });
  });
}
