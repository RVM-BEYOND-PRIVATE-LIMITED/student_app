import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/app_info.dart';
import 'core/crash/crash_log.dart';
import 'core/env/student_env.dart';
import 'core/push/notification_routes.dart';
import 'core/push/push_service.dart';
import 'core/security/device_hints.dart';
import 'core/session/student_session.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/connectivity/connectivity_bloc.dart';
import 'features/connectivity/offline_banner.dart';
import 'features/language/bloc/language_bloc.dart';
import 'features/startup/bloc/startup_bloc.dart';
import 'features/theme/theme_controller.dart';
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
  final AuthBloc _auth = getIt<AuthBloc>();
  final ThemeController _theme = getIt<ThemeController>();
  late final GoRouter _router = createRouter(
    startup: _startup,
    language: _language,
    auth: _auth,
    isDev: getIt<StudentEnv>().isDev,
  );

  late final AppLifecycleListener _lifecycle;
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    // Restore the session and read the account (student_app #2). It runs
    // beside the launch checks: neither waits on the other.
    _auth.add(const AuthStarted());
    PushService.instance.openedRoute.addListener(_onNotificationRoute);
    PushService.instance.foregroundNotice.addListener(_onForegroundNotice);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onNotificationRoute();
      _onForegroundNotice();
    });
    // In the background the offline banner's re-checks stop; back in the
    // foreground it checks again at once and starts its back-off afresh.
    // Hidden always comes before paused; both are sent, and the second one
    // changes nothing.
    final connectivity = getIt<ConnectivityBloc>();
    _lifecycle = AppLifecycleListener(
      onHide: () => connectivity.add(const ConnectivityPaused()),
      onPause: () => connectivity.add(const ConnectivityPaused()),
      onResume: () {
        connectivity.add(const ConnectivityResumed());
        // A theme the server did not take is retried here, and the server's
        // copy is read again in case the switch changed (student_app #59).
        if (_auth.state.signedIn) _theme.refreshFromServer();
      },
    );
  }

  @override
  void dispose() {
    PushService.instance.openedRoute.removeListener(_onNotificationRoute);
    PushService.instance.foregroundNotice.removeListener(_onForegroundNotice);
    _lifecycle.dispose();
    _router.dispose();
    super.dispose();
  }

  /// Shows a notice that arrived while the app was open. It is an in-app
  /// banner, not a second system notification, and its Open action follows
  /// the same guarded route mapping as a tapped push.
  void _onForegroundNotice() {
    final message = PushService.instance.foregroundNotice.value;
    if (message == null) return;
    PushService.instance.foregroundNotice.value = null;
    final title = (message.notification?.title ?? '').trim();
    final body = (message.notification?.body ?? '').trim();
    if (title.isEmpty && body.isEmpty) return;
    final messenger = _messengerKey.currentState;
    if (messenger == null) return;
    final context = _messengerKey.currentContext;
    final route = NotificationRoutes.forMessage(message);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            [title, body].where((line) => line.isNotEmpty).join('\n'),
          ),
          duration: const Duration(seconds: 8),
          action: route == null
              ? null
              : SnackBarAction(
                  label: context?.l10n.noticeOpen ?? 'Open',
                  onPressed: () {
                    PushService.instance.openedRoute.value = route;
                  },
                ),
        ),
      );
  }

  /// Opens the screen a notification asked for, but only for a signed-in,
  /// onboarded student. A tap while signed out waits until sign-in finishes.
  void _onNotificationRoute() {
    final route = PushService.instance.openedRoute.value;
    if (route == null) return;
    final account = _auth.state.account;
    if (!_auth.state.signedIn ||
        account == null ||
        !account.onboardingComplete) {
      return;
    }
    PushService.instance.openedRoute.value = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _router.go(route);
    });
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
          BlocProvider.value(value: _auth),
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
            BlocListener<AuthBloc, AuthState>(
              listenWhen: (p, c) =>
                  p.status != c.status ||
                  p.account?.onboardingComplete !=
                      c.account?.onboardingComplete,
              listener: (context, state) {
                _router.refresh();
                if (state.signedIn) {
                  // Sign-in and a restored session: read the theme, then a
                  // notification tap that waited for this sign-in.
                  _theme.refreshFromServer();
                  _onNotificationRoute();
                } else if (state.status == AuthStatus.signedOut) {
                  _theme.signOut();
                }
              },
            ),
          ],
          child: ListenableBuilder(
            listenable: _theme,
            builder: (context, _) => BlocBuilder<LanguageBloc, LanguageState>(
              buildWhen: (p, c) => p.language != c.language,
              builder: (context, state) => MaterialApp.router(
                onGenerateTitle: (context) => context.l10n.appTitle,
                debugShowCheckedModeBanner: false,
                // Light is today's look. Dark exists only when the server's
                // theme switch is open to this student (student_app #57, #59).
                theme: StudentTheme.forLanguageCode(state.language.name),
                darkTheme: StudentTheme.dark(
                  devanagari: state.language.name == 'hi',
                ),
                themeMode: _theme.mode,
                locale: state.language.locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                routerConfig: _router,
                scaffoldMessengerKey: _messengerKey,
                builder: (context, child) =>
                    OfflineBannerHost(child: child ?? const SizedBox.shrink()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
