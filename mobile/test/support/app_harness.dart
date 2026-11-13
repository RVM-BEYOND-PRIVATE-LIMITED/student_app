import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/app.dart';
import 'package:rvm_student/core/app_info.dart';
import 'package:rvm_student/core/crash/crash_log.dart';
import 'package:rvm_student/core/env/student_env.dart';
import 'package:rvm_student/core/security/device_hints.dart';
import 'package:rvm_student/core/version/version_gate.dart';
import 'package:rvm_student/features/language/language_store.dart';
import 'package:rvm_student/features/startup/bloc/startup_bloc.dart';
import 'package:rvm_student/injection.dart';
import 'package:rvm_student/l10n/l10n.dart';

import 'fakes.dart';

/// The installed build every app test runs as.
const testAppInfo = AppInfo(version: '0.1.0', buildNumber: '1');

/// One launch of the whole app, as `main.dart` does it, on fakes.
///
/// [store] stands for the phone's secure storage: pass the same one to a
/// second launch to test a restart. [online] drives the offline banner.
class AppHarness {
  AppHarness({
    FakeSecureStore? store,
    this.deviceLocales = const [Locale('en', 'IN')],
    this.versionSource = const UnpublishedVersionSource(),
    StudentEnv? env,
    CrashLogStore? crashLog,
    this.httpAdapter,
    this.appInfo = testAppInfo,
    this.deviceHints = const FakeDeviceHints(),
  }) : store = store ?? FakeSecureStore(),
       env = env ?? StudentEnv.resolve(flavor: 'dev', host: ''),
       crashLog = crashLog ?? MemoryCrashLogStore();

  final FakeSecureStore store;
  final List<Locale> deviceLocales;
  final VersionSource versionSource;
  final StudentEnv env;
  final CrashLogStore crashLog;

  /// Stands in for the network under the app's Student API client.
  final HttpClientAdapter? httpAdapter;

  /// The installed build, as Android reports it.
  final AppInfo appInfo;

  /// The phone's device hints (student_app #8, item 2).
  final DeviceHintsSource deviceHints;

  final StreamController<bool> online = StreamController<bool>.broadcast();

  /// Launches the app and lets the launch checks finish.
  Future<void> launch(WidgetTester tester, {bool settle = true}) async {
    // A previous launch in the same test is closed first, as a restart
    // would.
    await tester.pumpWidget(const SizedBox.shrink());
    await resetDependencies();
    addTearDown(resetDependencies);
    addTearDown(online.close);
    // The skeleton's shimmer and the splash dots stand still, so a frame
    // can settle.
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    tester.platformDispatcher.localesTestValue = deviceLocales;
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    final saved = await LanguageStore(store).read();
    configureDependencies(
      env: env,
      appInfo: appInfo,
      secureStore: store,
      crashLog: crashLog,
      connectivity: online.stream,
      deviceLocales: deviceLocales,
      savedLanguage: saved,
      versionSource: versionSource,
      httpAdapter: httpAdapter,
      deviceHints: deviceHints,
    );
    getIt<StartupBloc>().add(const StartupStarted());
    await tester.pumpWidget(const StudentApp());
    if (settle) await tester.pumpAndSettle();
  }
}

/// The app's translations for [locale], outside a widget tree.
Future<AppLocalizations> l10nFor(Locale locale) =>
    AppLocalizations.delegate.load(locale);
