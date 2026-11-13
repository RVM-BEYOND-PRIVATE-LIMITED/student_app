import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/app_info.dart';
import 'core/crash/crash_log.dart';
import 'core/env/student_env.dart';
import 'core/security/device_hints.dart';
import 'core/session/student_session.dart';
import 'features/connectivity/connectivity_bloc.dart';
import 'features/connectivity/offline_banner.dart';
import 'features/language/bloc/language_bloc.dart';
import 'features/startup/bloc/startup_bloc.dart';
import 'injection.dart';
import 'l10n/l10n.dart';
import 'router/app_router.dart';
import 'theme/student_theme.dart';

/// The student app (student_app #1), built from what [configureDependencies]
/// registered.
class StudentApp extends StatefulWidget {
  const StudentApp({super.key});

  @override
  State<StudentApp> createState() => _StudentAppState();
}

class _StudentAppState extends State<StudentApp> {
  final StartupBloc _startup = getIt<StartupBloc>();
  final LanguageBloc _language = getIt<LanguageBloc>();
  late final GoRouter _router = createRouter(
    startup: _startup,
    language: _language,
    isDev: getIt<StudentEnv>().isDev,
  );

  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Back in the foreground: the offline banner checks again at once.
    _lifecycle = AppLifecycleListener(
      onResume: () =>
          getIt<ConnectivityBloc>().add(const ConnectivityResumed()),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: getIt<StudentEnv>()),
        RepositoryProvider.value(value: getIt<AppInfo>()),
        RepositoryProvider.value(value: getIt<StudentSession>()),
        RepositoryProvider.value(value: getIt<CrashLogStore>()),
        RepositoryProvider.value(value: getIt<DeviceHintsSource>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _startup),
          BlocProvider.value(value: _language),
          BlocProvider.value(value: getIt<ConnectivityBloc>()),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<StartupBloc, StartupState>(
              listenWhen: (p, c) => p.status != c.status,
              listener: (_, _) => _router.refresh(),
            ),
            BlocListener<LanguageBloc, LanguageState>(
              listenWhen: (p, c) => p.hasChosen != c.hasChosen,
              listener: (_, _) => _router.refresh(),
            ),
          ],
          child: BlocBuilder<LanguageBloc, LanguageState>(
            buildWhen: (p, c) => p.language != c.language,
            builder: (context, state) => MaterialApp.router(
              onGenerateTitle: (context) => context.l10n.appTitle,
              debugShowCheckedModeBanner: false,
              // Light only, as the Team app: every screen is drawn for the
              // light palette.
              theme: StudentTheme.forLanguageCode(state.language.name),
              themeMode: ThemeMode.light,
              locale: state.language.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              routerConfig: _router,
              builder: (context, child) =>
                  OfflineBannerHost(child: child ?? const SizedBox.shrink()),
            ),
          ),
        ),
      ),
    );
  }
}
