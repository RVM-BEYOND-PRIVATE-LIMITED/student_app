import 'package:core_auth/core_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'core/api/models.dart';
import 'core/api/student_api.dart';
import 'core/app_info.dart';
import 'core/crash/crash_log.dart';
import 'core/env/student_env.dart';
import 'core/network/student_dio.dart';
import 'core/security/device_hints.dart';
import 'core/session/student_renewer.dart';
import 'core/session/student_session.dart';
import 'core/version/version_gate.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/connectivity/connectivity_bloc.dart';
import 'features/language/bloc/language_bloc.dart';
import 'features/language/language_store.dart';
import 'features/startup/bloc/startup_bloc.dart';
import 'features/theme/theme_controller.dart';
import 'features/theme/theme_store.dart';
import 'l10n/l10n.dart';

final GetIt getIt = GetIt.instance;

/// Wires the app once at launch. Tests call it with their own fakes.
///
/// [connectivity] is the online/offline stream (core_network's
/// `ConnectivityService.onStatusChanged()` in the app) and
/// [connectivityCheck] one check of it (`ConnectivityService.isOnline`),
/// which lets the offline banner check again while it shows; without it the
/// banner only follows the stream. [versionSource] is
/// where the launch check reads the minimum version; until Scheduler_Backend
/// #158 publishes one, nothing does. [httpAdapter] replaces the network in
/// tests. [deviceHints] reads the phone's device hints (student_app #8,
/// item 2); they are for messages only and never decide anything.
void configureDependencies({
  required StudentEnv env,
  required AppInfo appInfo,
  required SecureStore secureStore,
  required CrashLogStore crashLog,
  required Stream<bool> connectivity,
  Future<bool> Function()? connectivityCheck,
  required List<Locale> deviceLocales,
  AppLanguage? savedLanguage,
  SavedTheme? savedTheme,
  VersionSource versionSource = const UnpublishedVersionSource(),
  HttpClientAdapter? httpAdapter,
  DeviceHintsSource? deviceHints,
}) {
  final session = StudentSession(secureStore);
  final renewer = ApiSessionRenewer(session);
  final language = LanguageBloc(
    store: LanguageStore(secureStore),
    deviceDefault: AppLanguage.fromDevice(deviceLocales),
    saved: savedLanguage,
  );
  getIt
    ..registerSingleton<StudentEnv>(env)
    ..registerSingleton<AppInfo>(appInfo)
    ..registerSingleton<SecureStore>(secureStore)
    ..registerSingleton<CrashLogStore>(crashLog)
    ..registerSingleton<DeviceHintsSource>(deviceHints ?? PlatformDeviceHints())
    ..registerSingleton<StudentSession>(session)
    ..registerSingleton<LanguageBloc>(language)
    ..registerSingleton<StartupBloc>(
      StartupBloc(
        session: session,
        gate: VersionGate(
          source: versionSource,
          installedVersion: appInfo.isKnown ? appInfo.version : null,
        ),
      ),
    )
    ..registerSingleton<ConnectivityBloc>(
      ConnectivityBloc(connectivity, check: connectivityCheck),
    )
    ..registerSingleton<ApiSessionRenewer>(renewer)
    // The Student API client, against the published contract (student_app
    // #10). The renewer is filled in when the client exists.
    ..registerLazySingleton<Dio>(
      () => StudentDio.create(
        env: env,
        // An unknown build sends no version rather than a made-up one.
        appVersion: appInfo.isKnown ? appInfo.version : null,
        languageTag: () => language.state.language.name,
        session: session,
        renewer: renewer,
        adapter: httpAdapter,
      ),
    )
    ..registerLazySingleton<StudentApi>(() {
      final api = StudentApi(getIt<Dio>());
      renewer.attach(api);
      return api;
    })
    ..registerLazySingleton<ThemeController>(
      () => ThemeController(
        api: getIt<StudentApi>(),
        store: ThemeStore(secureStore),
        saved:
            savedTheme ??
            const SavedTheme(
              choice: ThemeChoice.light,
              open: false,
              pending: false,
            ),
      ),
    )
    // Sign-in, onboarding and the signed-in account (student_app #2).
    ..registerSingleton<AuthBloc>(
      AuthBloc(
        api: getIt<StudentApi>(),
        session: session,
        appVersion: appInfo.isKnown ? appInfo.version : null,
      ),
    );
}

/// Undoes [configureDependencies] (tests).
Future<void> resetDependencies() => getIt.reset();
