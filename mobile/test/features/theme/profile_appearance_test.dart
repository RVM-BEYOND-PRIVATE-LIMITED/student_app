import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/api/models.dart';
import 'package:rvm_student/core/api/student_api.dart';
import 'package:rvm_student/core/session/student_session.dart';
import 'package:rvm_student/features/auth/bloc/auth_bloc.dart';
import 'package:rvm_student/features/language/bloc/language_bloc.dart';
import 'package:rvm_student/features/language/language_store.dart';
import 'package:rvm_student/features/profile/profile_tab.dart';
import 'package:rvm_student/features/theme/theme_controller.dart';
import 'package:rvm_student/features/theme/theme_store.dart';
import 'package:rvm_student/injection.dart';
import 'package:rvm_student/l10n/l10n.dart';

import '../../support/fakes.dart';
import '../../support/screen.dart';

class _FakeApi extends StudentApi {
  _FakeApi() : super(Dio());

  ThemePreference preference = const ThemePreference(
    theme: ThemeChoice.light,
    themeOpen: false,
  );

  @override
  Future<ThemePreference> preferences() async => preference;

  @override
  Future<ThemePreference> setPreferences(ThemeChoice theme) async {
    preference = ThemePreference(theme: theme, themeOpen: true);
    return preference;
  }

  @override
  Future<List<ConsentRecord>> consents() async => const [];
}

const _account = StudentAccount(
  id: '11111111-1111-4111-8111-111111111111',
  phoneMasked: '••••••3210',
  language: 'en',
  stage: StudentStage.registered,
  feeFullyPaid: false,
  isAlumni: false,
  linkState: LinkState.linked,
  ageConfirmed: true,
  requiredConsentGiven: true,
  placementPrompts: 0,
  consentRequests: 0,
);

Future<({AuthBloc auth, LanguageBloc language, ThemeController theme})>
_pumpProfile(WidgetTester tester, {required bool open}) async {
  await getIt.reset();
  addTearDown(getIt.reset);
  final store = FakeSecureStore();
  final api = _FakeApi()
    ..preference = ThemePreference(
      theme: ThemeChoice.light,
      themeOpen: open,
    );
  final auth = AuthBloc(
    api: api,
    session: StudentSession(store),
    appVersion: '0.1.0',
  )..add(const AuthAccountUpdated(_account));
  final language = LanguageBloc(
    store: LanguageStore(store),
    deviceDefault: AppLanguage.en,
    saved: AppLanguage.en,
  );
  final theme = ThemeController(
    api: api,
    store: ThemeStore(store),
    saved: SavedTheme(
      choice: ThemeChoice.light,
      open: open,
      pending: false,
    ),
  );
  getIt
    ..registerSingleton<StudentApi>(api)
    ..registerSingleton<AuthBloc>(auth)
    ..registerSingleton<LanguageBloc>(language)
    ..registerSingleton<ThemeController>(theme);
  addTearDown(auth.close);
  addTearDown(language.close);

  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: auth),
        BlocProvider.value(value: language),
      ],
      child: localized(const Scaffold(body: ProfileTab())),
    ),
  );
  await tester.pumpAndSettle();
  return (auth: auth, language: language, theme: theme);
}

void main() {
  testWidgets('the Appearance row shows only when the switch is open', (
    tester,
  ) async {
    await _pumpProfile(tester, open: false);
    expect(find.text('Appearance'), findsNothing);

    await _pumpProfile(tester, open: true);
    expect(find.text('Appearance'), findsOneWidget);
  });

  testWidgets('picking Dark applies it at once', (tester) async {
    final deps = await _pumpProfile(tester, open: true);

    await tester.tap(find.byIcon(Icons.chevron_right_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Choose appearance'), findsOneWidget);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(deps.theme.choice, ThemeChoice.dark);
    expect(deps.theme.mode, ThemeMode.dark);
    // The sheet stays until its button is pressed.
    expect(find.text('Choose appearance'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Choose appearance'), findsNothing);
  });
}
