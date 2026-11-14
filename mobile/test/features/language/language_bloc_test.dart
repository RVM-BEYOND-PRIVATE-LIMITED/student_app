import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/features/language/bloc/language_bloc.dart';
import 'package:rvm_student/features/language/language_store.dart';
import 'package:rvm_student/l10n/l10n.dart';

import '../../support/fakes.dart';

void main() {
  late FakeSecureStore store;

  setUp(() => store = FakeSecureStore());

  group('AppLanguage', () {
    test('the phone\'s first language the app speaks, else English', () {
      expect(
        AppLanguage.fromDevice(const [Locale('hi', 'IN')]),
        AppLanguage.hi,
      );
      expect(
        AppLanguage.fromDevice(const [
          Locale('ta'),
          Locale('hi'),
          Locale('en'),
        ]),
        AppLanguage.hi,
      );
      expect(
        AppLanguage.fromDevice(const [Locale('en', 'IN'), Locale('hi')]),
        AppLanguage.en,
      );
      expect(AppLanguage.fromDevice(const [Locale('ta')]), AppLanguage.en);
      expect(AppLanguage.fromDevice(const []), AppLanguage.en);
    });

    test('codes', () {
      expect(AppLanguage.fromCode('hi'), AppLanguage.hi);
      expect(AppLanguage.fromCode('en'), AppLanguage.en);
      expect(AppLanguage.fromCode('fr'), isNull);
      expect(AppLanguage.fromCode(null), isNull);
      expect(AppLanguage.hi.locale, const Locale('hi'));
    });

    test('every language the app speaks has its translations', () {
      expect(
        AppLanguage.values.map((l) => l.locale).toSet(),
        AppLocalizations.supportedLocales.toSet(),
      );
    });
  });

  group('LanguageStore', () {
    test('nothing saved reads as no choice', () async {
      expect(await LanguageStore(store).read(), isNull);
    });

    test('a saved choice is read back', () async {
      await LanguageStore(store).write(AppLanguage.hi);

      expect(store.values[LanguageStore.key], 'hi');
      expect(await LanguageStore(store).read(), AppLanguage.hi);
    });

    test('an unreadable or unknown value reads as no choice', () async {
      store.values[LanguageStore.key] = 'xx';
      expect(await LanguageStore(store).read(), isNull);

      store.failReads = StateError('keystore busy');
      expect(await LanguageStore(store).read(), isNull);
    });
  });

  group('LanguageBloc (item 8, check 2)', () {
    test('before a choice the app shows the phone\'s language', () {
      final bloc = LanguageBloc(
        store: LanguageStore(store),
        deviceDefault: AppLanguage.hi,
      );
      addTearDown(bloc.close);

      expect(bloc.state.hasChosen, isFalse);
      expect(bloc.state.language, AppLanguage.hi);
    });

    blocTest<LanguageBloc, LanguageState>(
      'a choice switches the app at once and is saved',
      build: () => LanguageBloc(
        store: LanguageStore(store),
        deviceDefault: AppLanguage.en,
      ),
      act: (bloc) => bloc.add(const LanguageSelected(AppLanguage.hi)),
      expect: () => [
        const LanguageState(
          deviceDefault: AppLanguage.en,
          chosen: AppLanguage.hi,
        ),
      ],
      verify: (_) => expect(store.values[LanguageStore.key], 'hi'),
    );

    test('the choice survives a restart', () async {
      final first = LanguageBloc(
        store: LanguageStore(store),
        deviceDefault: AppLanguage.en,
      );
      first.add(const LanguageSelected(AppLanguage.hi));
      await first.stream.firstWhere((s) => s.hasChosen);
      await first.close();

      // The next launch reads the saved choice before the first frame
      // (lib/main.dart) and starts with it.
      final saved = await LanguageStore(store).read();
      final next = LanguageBloc(
        store: LanguageStore(store),
        deviceDefault: AppLanguage.en,
        saved: saved,
      );
      addTearDown(next.close);

      expect(next.state.hasChosen, isTrue);
      expect(next.state.language, AppLanguage.hi);
    });

    blocTest<LanguageBloc, LanguageState>(
      'a choice that cannot be saved still holds for this run',
      setUp: () => store.failWrites = StateError('disk full'),
      build: () => LanguageBloc(
        store: LanguageStore(store),
        deviceDefault: AppLanguage.en,
      ),
      act: (bloc) => bloc.add(const LanguageSelected(AppLanguage.hi)),
      expect: () => [
        const LanguageState(
          deviceDefault: AppLanguage.en,
          chosen: AppLanguage.hi,
        ),
      ],
      errors: () => isEmpty,
    );
  });
}
