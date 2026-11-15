import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:core_auth/core_auth.dart';
import 'package:core_network/core_network.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'app_crash.dart';
import 'config_error_app.dart';
import 'core/api/models.dart';
import 'core/api/student_api.dart';
import 'core/app_info.dart';
import 'core/crash/crash_log.dart';
import 'core/env/student_env.dart';
import 'core/push/push_service.dart';
import 'core/version/config_version_source.dart';
import 'features/language/language_store.dart';
import 'features/theme/theme_store.dart';
import 'features/startup/bloc/startup_bloc.dart';
import 'injection.dart';
import 'theme/font_licenses.dart';

void main() {
  // Every error, in every async gap, ends up in the on-device crash log
  // (app_crash.dart), cleaned of personal data.
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    installCrashCapture(FileCrashLogStore.inAppStorage());
    await CrashReporter.init();
    unawaited(PushService.instance.init());
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
    final connectivity = ConnectivityService();
    final appInfo = await AppInfo.load();
    // The saved language is read before the first frame, so the app never
    // flashes in the wrong language. A store that does not answer in time is
    // treated as "no choice yet".
    final savedLanguage = await LanguageStore(
      secureStore,
    ).read().timeout(const Duration(seconds: 3), onTimeout: () => null);
    // Same for the theme: the saved choice is read before the first frame so
    // a cold start in Dark never flashes Light (student_app #59).
    final savedTheme = await ThemeStore(secureStore).read().timeout(
      const Duration(seconds: 3),
      onTimeout: () => const SavedTheme(
        choice: ThemeChoice.light,
        open: false,
        pending: false,
      ),
    );

    configureDependencies(
      env: env,
      appInfo: appInfo,
      secureStore: secureStore,
      crashLog: CrashLog.store,
      connectivity: connectivity.onStatusChanged(),
      connectivityCheck: () => connectivity.isOnline,
      deviceLocales: PlatformDispatcher.instance.locales,
      savedLanguage: savedLanguage,
      savedTheme: savedTheme,
      // The launch minimum comes from the published contract now
      // (student_app #1, item 10). A server that cannot be read fails open.
      versionSource: ConfigVersionSource(
        () async => (await getIt<StudentApi>().config()).minSupportedVersion,
      ),
    );
    getIt<StartupBloc>().add(const StartupStarted());

    runApp(const StudentApp());
  }, recordZoneError);
}
