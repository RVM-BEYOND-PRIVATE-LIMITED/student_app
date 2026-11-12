import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../features/dev_menu/crash_log_screen.dart';
import '../features/dev_menu/dev_menu_screen.dart';
import '../features/dev_menu/states_gallery_screen.dart';
import '../features/language/bloc/language_bloc.dart';
import '../features/language/language_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/startup/bloc/startup_bloc.dart';
import '../features/update_required/update_required_screen.dart';
import '../features/welcome/welcome_screen.dart';

abstract final class Routes {
  static const splash = '/';
  static const updateRequired = '/update-required';
  static const language = '/language';
  static const welcome = '/welcome';
  static const devMenu = '/dev';
  static const devStates = '/dev/states';
  static const devCrashLog = '/dev/crash-log';
}

/// Where the app must be, given the launch state (student_app #1):
///
/// * while the session is restored and the version checked: the splash;
/// * a build that is too old: the Update-required screen, and nowhere else;
/// * no language chosen yet: the language screen;
/// * the Developer menu only in a dev build.
///
/// Null keeps the requested [location].
String? redirectFor({
  required String location,
  required StartupState startup,
  required LanguageState language,
  required bool isDev,
}) {
  switch (startup.status) {
    case StartupStatus.checking:
      return location == Routes.splash ? null : Routes.splash;
    case StartupStatus.updateRequired:
      return location == Routes.updateRequired ? null : Routes.updateRequired;
    case StartupStatus.ready:
      if (location == Routes.splash || location == Routes.updateRequired) {
        return language.hasChosen ? Routes.welcome : Routes.language;
      }
      if (!language.hasChosen && location != Routes.language) {
        return Routes.language;
      }
      if (location.startsWith(Routes.devMenu) && !isDev) return Routes.welcome;
      return null;
  }
}

GoRouter createRouter({
  required StartupBloc startup,
  required LanguageBloc language,
  required bool isDev,
}) {
  return GoRouter(
    initialLocation: Routes.splash,
    redirect: (BuildContext context, GoRouterState state) => redirectFor(
      location: state.matchedLocation,
      startup: startup.state,
      language: language.state,
      isDev: isDev,
    ),
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.updateRequired,
        builder: (context, state) => const UpdateRequiredScreen(),
      ),
      GoRoute(
        path: Routes.language,
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: Routes.devMenu,
        builder: (context, state) => const DevMenuScreen(),
        routes: [
          GoRoute(
            path: 'states',
            builder: (context, state) => const StatesGalleryScreen(),
          ),
          GoRoute(
            path: 'crash-log',
            builder: (context, state) => const CrashLogScreen(),
          ),
        ],
      ),
    ],
  );
}
