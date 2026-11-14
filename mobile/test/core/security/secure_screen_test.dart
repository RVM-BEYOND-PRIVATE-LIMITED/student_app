import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rvm_student/core/crash/crash_log.dart';
import 'package:rvm_student/core/security/secure_screen.dart';
import 'package:rvm_student/core/security/secure_window.dart';
import 'package:rvm_student/features/dev_menu/capture_guard_screen.dart';
import 'package:rvm_student/features/dev_menu/dev_menu_screen.dart';
import 'package:rvm_student/features/language/language_store.dart';
import 'package:rvm_student/features/welcome/welcome_screen.dart';
import 'package:rvm_student/router/app_router.dart';

import '../../support/app_harness.dart';
import '../../support/fakes.dart';
import '../../support/screen.dart';

/// student_app #8, item 1: the capture guard. MainActivity sets and clears
/// FLAG_SECURE on the `rvm_student/secure_window` channel; [SecureWindow]
/// counts the screens that need it; [SecureScreen] holds it only while its
/// screen can be seen. The channel is mocked, so each test sees exactly what
/// MainActivity would be told.
const _channel = MethodChannel(SecureWindow.channelName);

/// The methods MainActivity was sent, in order. [fail] makes it answer with
/// an error.
List<String> _mockChannel({bool fail = false}) {
  final calls = <String>[];
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_channel, (call) async {
        calls.add(call.method);
        if (fail) throw PlatformException(code: 'window', message: 'no');
        return null;
      });
  addTearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null),
  );
  return calls;
}

class _Screen extends StatelessWidget {
  const _Screen(this.label, {this.next, this.sheet = false});

  final String label;
  final WidgetBuilder? next;
  final bool sheet;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(label)),
    body: Column(
      children: [
        if (next != null)
          TextButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: next!)),
            child: const Text('open'),
          ),
        if (sheet)
          TextButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              builder: (_) => const SizedBox(height: 120, child: Text('Sheet')),
            ),
            child: const Text('sheet'),
          ),
      ],
    ),
  );
}

void main() {
  group('SecureWindow', () {
    setUp(TestWidgetsFlutterBinding.ensureInitialized);

    test(
      'the first holder turns the guard on, the last turns it off',
      () async {
        final calls = _mockChannel();
        final window = SecureWindow();

        window
          ..acquire()
          ..acquire();
        expect(window.holders, 2);
        window.release();
        expect(window.isOn, isTrue);
        window
          ..release()
          ..release(); // one release too many changes nothing
        await pumpEventQueue();

        expect(calls, ['enable', 'disable']);
        expect(window.isOn, isFalse);
        expect(window.holders, 0);
      },
    );

    test('sends nothing where there is no FLAG_SECURE (not Android)', () async {
      final calls = _mockChannel();
      final window = SecureWindow(supported: () => false);

      window
        ..acquire()
        ..release();
      await pumpEventQueue();

      expect(calls, isEmpty);
    });

    test('back in the foreground, a guard that is on is sent again', () async {
      final calls = _mockChannel();
      final window = SecureWindow()..acquire();
      await pumpEventQueue();

      window.didChangeAppLifecycleState(AppLifecycleState.paused);
      window.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await pumpEventQueue();
      expect(calls, ['enable', 'enable']);

      window.release();
      await pumpEventQueue();
      // Off: a later resume sends nothing.
      window.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await pumpEventQueue();
      expect(calls, ['enable', 'enable', 'disable']);
    });

    test('a window that refuses is recorded, never thrown', () async {
      final previous = CrashLog.store;
      final log = MemoryCrashLogStore();
      CrashLog.store = log;
      addTearDown(() => CrashLog.store = previous);
      final calls = _mockChannel(fail: true);

      final window = SecureWindow()..acquire();
      await pumpEventQueue();

      expect(calls, ['enable']);
      final records = await log.read();
      expect(records, hasLength(1));
      expect(records.single.kind, CrashKind.platform);
      expect(window.isOn, isTrue, reason: 'the count stays right');
    });

    test('without MainActivity (no handler) nothing is recorded', () async {
      final previous = CrashLog.store;
      final log = MemoryCrashLogStore();
      CrashLog.store = log;
      addTearDown(() => CrashLog.store = previous);

      SecureWindow()
        ..acquire()
        ..release();
      await pumpEventQueue();

      expect(await log.read(), isEmpty);
    });

    test('MainActivity answers the same channel and both methods', () {
      final activity = File(
        'android/app/src/main/kotlin/com/rvm/rvmstudent/MainActivity.kt',
      ).readAsStringSync();

      expect(activity, contains('"${SecureWindow.channelName}"'));
      expect(activity, contains('"enable" ->'));
      expect(
        activity,
        contains('window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)'),
      );
      expect(activity, contains('"disable" ->'));
      expect(
        activity,
        contains('window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)'),
      );
    });
  });

  group('SecureScreen on a route', () {
    testWidgets('on while its screen is pushed, off once it is popped', (
      tester,
    ) async {
      final calls = _mockChannel();
      final window = SecureWindow();
      await tester.pumpWidget(
        MaterialApp(
          home: _Screen(
            'Home',
            next: (_) => SecureScreen(
              window: window,
              child: const _Screen('ID document'),
            ),
          ),
        ),
      );
      expect(calls, isEmpty, reason: 'Home is not marked');

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(calls, ['enable']);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(calls, ['enable', 'disable']);
      expect(window.isOn, isFalse);
    });

    testWidgets('draws its screen unchanged', (tester) async {
      _mockChannel();
      await tester.pumpWidget(
        MaterialApp(
          home: SecureScreen(
            window: SecureWindow(),
            child: const _Screen('ID document'),
          ),
        ),
      );

      expect(find.text('ID document'), findsOneWidget);
      expect(
        tester.widget(find.byType(SecureScreen)),
        isA<SecureScreen>().having((s) => s.child, 'child', isA<_Screen>()),
      );
    });

    testWidgets('stays on under a bottom sheet: the screen is still seen', (
      tester,
    ) async {
      final calls = _mockChannel();
      final window = SecureWindow();
      await tester.pumpWidget(
        MaterialApp(
          home: SecureScreen(
            window: window,
            child: const _Screen('Payout account', sheet: true),
          ),
        ),
      );
      await tester.tap(find.text('sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Sheet'), findsOneWidget);
      expect(calls, ['enable']);
      expect(window.isOn, isTrue);
    });

    testWidgets('off under an opaque screen, on again when it is popped', (
      tester,
    ) async {
      final calls = _mockChannel();
      final window = SecureWindow();
      await tester.pumpWidget(
        MaterialApp(
          home: SecureScreen(
            window: window,
            child: _Screen(
              'ID document',
              next: (_) => const _Screen('Receipts'),
            ),
          ),
        ),
      );
      expect(calls, ['enable']);

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(calls, ['enable', 'disable'], reason: 'Receipts are capturable');

      await tester.pageBack();
      await tester.pump(); // the covered screen is visible from the first frame
      expect(calls, ['enable', 'disable', 'enable']);
      await tester.pumpAndSettle();
      expect(window.isOn, isTrue);
    });

    testWidgets('two marked screens in a row never drop the guard between', (
      tester,
    ) async {
      final calls = _mockChannel();
      final window = SecureWindow();
      await tester.pumpWidget(
        MaterialApp(
          home: SecureScreen(
            window: window,
            child: _Screen(
              'ID document',
              next: (_) => SecureScreen(
                window: window,
                child: const _Screen('Payout account'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(calls, ['enable'], reason: 'one long hold, never a gap');
      expect(window.holders, 1);
    });

    testWidgets('off once it leaves the tree', (tester) async {
      final calls = _mockChannel();
      final window = SecureWindow();
      await tester.pumpWidget(
        SecureScreen(window: window, child: const SizedBox()),
      );
      await tester.pumpWidget(const SizedBox());

      expect(calls, ['enable', 'disable']);
      expect(window.isOn, isFalse);
    });
  });

  group('SecureScreen in tabs', () {
    testWidgets('visible: false is a tab that is not the selected one', (
      tester,
    ) async {
      final calls = _mockChannel();
      final window = SecureWindow();
      Widget tabs(int selected) => MaterialApp(
        home: IndexedStack(
          index: selected,
          children: [
            const _Screen('Home'),
            SecureScreen(
              window: window,
              visible: selected == 1,
              child: const _Screen('Payouts'),
            ),
          ],
        ),
      );

      await tester.pumpWidget(tabs(0));
      expect(calls, isEmpty);
      await tester.pumpWidget(tabs(1));
      expect(calls, ['enable']);
      await tester.pumpWidget(tabs(0));
      expect(calls, ['enable', 'disable']);
    });

    testWidgets('follows the selected go_router shell tab on its own', (
      tester,
    ) async {
      final calls = _mockChannel();
      final window = SecureWindow();
      final router = GoRouter(
        initialLocation: '/home',
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, shell) => Scaffold(
              body: shell,
              bottomNavigationBar: Row(
                children: [
                  TextButton(
                    onPressed: () => shell.goBranch(0),
                    child: const Text('tab home'),
                  ),
                  TextButton(
                    onPressed: () => shell.goBranch(1),
                    child: const Text('tab payouts'),
                  ),
                ],
              ),
            ),
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/home',
                    builder: (_, _) => const _Screen('Home'),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/payouts',
                    builder: (_, _) => SecureScreen(
                      window: window,
                      child: const _Screen('Payouts'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      expect(calls, isEmpty);

      await tester.tap(find.text('tab payouts'));
      await tester.pumpAndSettle();
      expect(calls, ['enable']);

      // The Payouts tab stays built in the IndexedStack, but is not seen.
      await tester.tap(find.text('tab home'));
      await tester.pumpAndSettle();
      expect(calls, ['enable', 'disable']);

      await tester.tap(find.text('tab payouts'));
      await tester.pumpAndSettle();
      expect(calls, ['enable', 'disable', 'enable']);
    });
  });

  group('in the app', () {
    testWidgets('only the marked screen turns the guard on (check 1)', (
      tester,
    ) async {
      final calls = _mockChannel();
      await AppHarness(
        store: FakeSecureStore({LanguageStore.key: 'en'}),
      ).launch(tester);
      expect(find.byType(WelcomeScreen), findsOneWidget);

      final router = GoRouter.of(tester.element(find.byType(WelcomeScreen)));
      unawaited(router.push(Routes.devMenu));
      await tester.pumpAndSettle();
      expect(find.byType(DevMenuScreen), findsOneWidget);
      expect(calls, isEmpty, reason: 'Welcome and the menu are capturable');

      unawaited(router.push(Routes.devCaptureGuard));
      await tester.pumpAndSettle();
      expect(find.byType(CaptureGuardScreen), findsOneWidget);
      expect(calls, ['enable']);

      router.pop();
      await tester.pumpAndSettle();
      expect(find.byType(DevMenuScreen), findsOneWidget);
      expect(calls, ['enable', 'disable']);
      expect(SecureWindow.instance.isOn, isFalse);
    });

    testWidgets('the test screen fits a small phone, in Hindi', (tester) async {
      _mockChannel();
      useSurface(tester, smallPhone);
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(
        localized(const CaptureGuardScreen(), locale: hindi),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(englishOnScreen(tester), isEmpty);
      await tester.pumpWidget(const SizedBox());
    });
  });
}
