import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/features/language/bloc/language_bloc.dart';
import 'package:rvm_student/features/startup/bloc/startup_bloc.dart';
import 'package:rvm_student/l10n/l10n.dart';
import 'package:rvm_student/router/app_router.dart';

void main() {
  const checking = StartupState();
  const ready = StartupState(status: StartupStatus.ready);
  const tooOld = StartupState(
    status: StartupStatus.updateRequired,
    minimumVersion: '0.2.0',
  );
  const noChoice = LanguageState(deviceDefault: AppLanguage.en);
  const chosen = LanguageState(
    deviceDefault: AppLanguage.en,
    chosen: AppLanguage.hi,
  );

  String? go(
    String location, {
    StartupState startup = ready,
    LanguageState language = chosen,
    bool isDev = true,
  }) => redirectFor(
    location: location,
    startup: startup,
    language: language,
    isDev: isDev,
  );

  test('the splash holds every route while the launch checks run', () {
    expect(go(Routes.splash, startup: checking), isNull);
    expect(go(Routes.welcome, startup: checking), Routes.splash);
    expect(go(Routes.devMenu, startup: checking), Routes.splash);
  });

  test('a build that is too old reaches only Update required', () {
    for (final location in [
      Routes.splash,
      Routes.language,
      Routes.welcome,
      Routes.devMenu,
      Routes.devStates,
    ]) {
      expect(
        go(location, startup: tooOld),
        Routes.updateRequired,
        reason: location,
      );
    }
    expect(go(Routes.updateRequired, startup: tooOld), isNull);
  });

  test('the first launch asks for the language before anything else', () {
    expect(go(Routes.splash, language: noChoice), Routes.language);
    expect(go(Routes.welcome, language: noChoice), Routes.language);
    expect(go(Routes.devMenu, language: noChoice), Routes.language);
    expect(go(Routes.language, language: noChoice), isNull);
  });

  test('later launches go straight to the app', () {
    expect(go(Routes.splash), Routes.welcome);
    expect(go(Routes.updateRequired), Routes.welcome);
    expect(go(Routes.welcome), isNull);
    expect(go(Routes.language), isNull);
  });

  test('the Developer menu exists in dev builds only', () {
    expect(go(Routes.devMenu), isNull);
    expect(go(Routes.devStates), isNull);
    expect(go(Routes.devCrashLog), isNull);
    expect(go(Routes.devCaptureGuard), isNull);

    expect(go(Routes.devMenu, isDev: false), Routes.welcome);
    expect(go(Routes.devStates, isDev: false), Routes.welcome);
    expect(go(Routes.devCrashLog, isDev: false), Routes.welcome);
    expect(go(Routes.devCaptureGuard, isDev: false), Routes.welcome);
  });
}
