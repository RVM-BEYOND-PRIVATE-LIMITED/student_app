import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:core_auth/core_auth.dart';
import 'package:core_network/core_network.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'app_crash.dart';
import 'config_error_app.dart';
import 'core/app_info.dart';
import 'core/crash/crash_log.dart';
import 'core/env/student_env.dart';
import 'features/language/language_store.dart';
import 'features/startup/bloc/startup_bloc.dart';
import 'injection.dart';
import 'theme/font_licenses.dart';

void main() {
  // Every error, in every async gap, ends up in the on-device crash log
  // (app_crash.dart), cleaned of personal data.
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    installCrashCapture(FileCrashLogStore.inAppStorage());
    registerFontLicenses();

    final StudentEnv env;
    try {
      env = StudentEnv.fromDefines();
    } on StudentEnvError catch (error, stack) {
      await CrashLog.record(error, stack, kind: CrashKind.zone);
      runApp(const ConfigErrorApp());
      return;
    }

    final secureStore = SecureStore();
    final appInfo = await AppInfo.load();
    // The saved language is read before the first frame, so the app never
    // flashes in the wrong language. A store that does not answer in time is
    // treated as "no choice yet".
    final savedLanguage = await LanguageStore(
      secureStore,
    ).read().timeout(const Duration(seconds: 3), onTimeout: () => null);

    configureDependencies(
      env: env,
      appInfo: appInfo,
      secureStore: secureStore,
      crashLog: CrashLog.store,
      connectivity: ConnectivityService().onStatusChanged(),
      deviceLocales: PlatformDispatcher.instance.locales,
      savedLanguage: savedLanguage,
    );
    getIt<StartupBloc>().add(const StartupStarted());

    runApp(const StudentApp());
  }, recordZoneError);
}
