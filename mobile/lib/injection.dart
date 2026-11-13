import 'package:core_auth/core_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'core/app_info.dart';
import 'core/crash/crash_log.dart';
import 'core/env/student_env.dart';
import 'core/network/student_dio.dart';
import 'core/session/student_session.dart';
import 'core/version/version_gate.dart';
import 'features/connectivity/connectivity_bloc.dart';
import 'features/language/bloc/language_bloc.dart';
import 'features/language/language_store.dart';
import 'features/startup/bloc/startup_bloc.dart';
import 'l10n/l10n.dart';

final GetIt getIt = GetIt.instance;

/// Wires the app once at launch. Tests call it with their own fakes.
///
/// [connectivity] is the online/offline stream (core_network's
/// `ConnectivityService.onStatusChanged()` in the app). [versionSource] is
/// where the launch check reads the minimum version; until Scheduler_Backend
/// #158 publishes one, nothing does. [httpAdapter] replaces the network in
/// tests.
void configureDependencies({
  required StudentEnv env,
  required AppInfo appInfo,
  required SecureStore secureStore,
  required CrashLogStore crashLog,
  required Stream<bool> connectivity,
  required List<Locale> deviceLocales,
  AppLanguage? savedLanguage,
  VersionSource versionSource = const UnpublishedVersionSource(),
  HttpClientAdapter? httpAdapter,
}) {
  final session = StudentSession(secureStore);
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
    ..registerSingleton<ConnectivityBloc>(ConnectivityBloc(connectivity))
    // The Student API client. Nothing calls it yet: its calls come with the
    // generated client once the contract is published (student_app #10).
    ..registerLazySingleton<Dio>(
      () => StudentDio.create(
        env: env,
        appVersion: appInfo.version,
        languageTag: () => language.state.language.name,
        session: session,
        adapter: httpAdapter,
      ),
    );
}

/// Undoes [configureDependencies] (tests).
Future<void> resetDependencies() => getIt.reset();
