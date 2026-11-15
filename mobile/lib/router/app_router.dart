import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/bloc/auth_bloc.dart';
import '../features/auth/otp_screen.dart';
import '../features/auth/sign_in_screen.dart';
import '../features/auth/session_error_screen.dart';
import '../features/dev_menu/capture_guard_screen.dart';
import '../features/dev_menu/crash_log_screen.dart';
import '../features/dev_menu/dev_menu_screen.dart';
import '../features/dev_menu/states_gallery_screen.dart';
import '../features/home/home_shell.dart';
import '../features/jobs/campus_web_view.dart';
import '../features/language/bloc/language_bloc.dart';
import '../features/language/language_screen.dart';
import '../features/linking/already_paid_screen.dart';
import '../features/onboarding/consent_screen.dart';
import '../features/join/join_holding_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/startup/bloc/startup_bloc.dart';
import '../features/update_required/update_required_screen.dart';
import '../features/welcome/welcome_screen.dart';

abstract final class Routes {
  static const splash = '/';
  static const updateRequired = '/update-required';
  static const language = '/language';
  static const welcome = '/welcome';
  static const signIn = '/sign-in';
  static const otp = '/sign-in/code';
  static const consent = '/consent';
  static const home = '/home';
  static const alreadyPaid = '/already-paid';
  static const joinHolding = '/join';
  static const campus = '/jobs/campus';
  static const sessionError = '/session-error';
  static const devMenu = '/dev';
  static const devStates = '/dev/states';
  static const devCrashLog = '/dev/crash-log';
  static const devCaptureGuard = '/dev/capture-guard';
}

/// The one auth fact the router needs, so it stays testable without a bloc.
class AuthRedirect {
  const AuthRedirect({
    this.checking = false,
    this.signedIn = false,
    this.onboardingComplete = true,
    this.failed = false,
  });

  final bool checking;
  final bool signedIn;
  final bool onboardingComplete;
  final bool failed;

  const AuthRedirect.signedOut()
    : checking = false,
      signedIn = false,
      onboardingComplete = true,
      failed = false;
}

/// Where the app must be, given the launch state (student_app #1) and the
/// sign-in state (student_app #2):
///
/// * while the session is restored and the version checked: the splash;
/// * a build that is too old: the Update-required screen, and nowhere else;
/// * no language chosen yet: the language screen;
/// * no session: Welcome, where sign-in starts;
/// * a session whose account could not be read: the session-error screen;
/// * signed in without the age tick or the required consent: Consent;
/// * signed in and onboarded: the tabbed Home shell.
///
/// Null keeps the requested [location].
String? redirectFor({
  required String location,
  required StartupState startup,
  required LanguageState language,
  required bool isDev,
  AuthRedirect auth = const AuthRedirect.signedOut(),
}) {
  switch (startup.status) {
    case StartupStatus.checking:
      return location == Routes.splash ? null : Routes.splash;
    case StartupStatus.updateRequired:
      return location == Routes.updateRequired ? null : Routes.updateRequired;
    case StartupStatus.ready:
      if (!language.hasChosen) {
        return location == Routes.language ? null : Routes.language;
      }
      if (auth.failed) {
        return location == Routes.sessionError ? null : Routes.sessionError;
      }
      if (auth.checking) {
        return location == Routes.splash || _mayWait(location)
            ? null
            : Routes.splash;
      }
      if (!auth.signedIn) {
        final devOk = isDev && location.startsWith(Routes.devMenu);
        return _signedOutMaySee(location) || devOk ? null : Routes.welcome;
      }
      if (!auth.onboardingComplete) {
        return location == Routes.consent ? null : Routes.consent;
      }
      if (_signedOutOnly(location)) return Routes.home;
      if (location.startsWith(Routes.devMenu) && !isDev) return Routes.home;
      return null;
  }
}

/// Screens a signed-out student may see while the session is restored.
bool _mayWait(String location) =>
    location == Routes.welcome ||
    location == Routes.signIn ||
    location == Routes.otp ||
    location == Routes.language;

/// Screens a signed-out student may open.
bool _signedOutMaySee(String location) =>
    location == Routes.welcome ||
    location == Routes.signIn ||
    location == Routes.otp ||
    location == Routes.language;

/// Screens that belong before sign-in; a signed-in student is sent Home.
bool _signedOutOnly(String location) =>
    location == Routes.splash ||
    location == Routes.welcome ||
    location == Routes.signIn ||
    location == Routes.otp ||
    location == Routes.consent;

GoRouter createRouter({
  required StartupBloc startup,
  required LanguageBloc language,
  required AuthBloc auth,
  required bool isDev,
}) {
  return GoRouter(
    initialLocation: Routes.splash,
    redirect: (BuildContext context, GoRouterState state) {
      final authState = auth.state;
      return redirectFor(
        location: state.matchedLocation,
        startup: startup.state,
        language: language.state,
        isDev: isDev,
        auth: AuthRedirect(
          checking: authState.status == AuthStatus.checking,
          signedIn: authState.signedIn,
          onboardingComplete: authState.account?.onboardingComplete ?? false,
          failed: authState.status == AuthStatus.failure,
        ),
      );
    },
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
        path: Routes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(path: Routes.otp, builder: (context, state) => const OtpScreen()),
      GoRoute(
        path: Routes.consent,
        builder: (context, state) => const ConsentScreen(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeShell(),
      ),
      GoRoute(
        path: Routes.alreadyPaid,
        builder: (context, state) => const AlreadyPaidScreen(),
      ),
      GoRoute(
        path: Routes.joinHolding,
        builder: (context, state) => const JoinHoldingScreen(),
      ),
      GoRoute(
        path: Routes.campus,
        builder: (context, state) {
          final url = state.extra;
          return CampusWebView(
            url: url is Uri ? url : Uri.tryParse('$url'),
          );
        },
      ),
      GoRoute(
        path: Routes.sessionError,
        builder: (context, state) => const SessionErrorScreen(),
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
          GoRoute(
            path: 'capture-guard',
            builder: (context, state) => const CaptureGuardScreen(),
          ),
        ],
      ),
    ],
  );
}
