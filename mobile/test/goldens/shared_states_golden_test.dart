@Tags(['golden'])
library;

import 'package:core_network/core_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/features/connectivity/offline_banner.dart';
import 'package:rvm_student/l10n/l10n.dart';
import 'package:rvm_student/theme/student_theme.dart';
import 'package:rvm_student/widgets/states.dart';

import 'pseudo_locale.dart';

/// Golden images of the shared states (student_app #11): skeleton, empty,
/// error with its request id, and offline, each in English, Hindi and the
/// long-text pseudo-locale, drawn with the bundled fonts
/// (flutter_test_config.dart) on a small Android phone.
///
/// Made and checked on Linux only:
///   flutter test --tags golden                   # check
///   flutter test --tags golden --update-goldens  # remake after a UI change
/// A plain `flutter test` runs them too; `--exclude-tags golden` skips them.
void main() {
  /// A small Android phone, in logical pixels.
  const phone = Size(360, 640);

  /// A fixed, made-up request id (not a server's).
  const requestId = '3f2b9c1e-7d4a-4b8e-9f10-2a6c5e8d1b47';

  final locales = <String, Locale>{
    'en': const Locale('en'),
    'hi': const Locale('hi'),
    'long': pseudoLocale,
  };

  Widget app(Locale locale, Widget Function(BuildContext context) body) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: StudentTheme.forLanguageCode(locale.languageCode),
      locale: locale,
      supportedLocales: [...AppLocalizations.supportedLocales, pseudoLocale],
      localizationsDelegates: const [
        PseudoLongLocalizationsDelegate(),
        ...AppLocalizations.localizationsDelegates,
      ],
      home: Builder(builder: body),
    );
  }

  /// One shared state as it sits on a screen: the screen's title bar, then
  /// the state.
  final states = <String, Widget Function(BuildContext context)>{
    'skeleton': (context) => Scaffold(
      appBar: AppBar(title: Text(context.l10n.gallerySkeleton)),
      body: const SkeletonList(),
    ),
    'empty': (context) => Scaffold(
      appBar: AppBar(title: Text(context.l10n.galleryEmpty)),
      body: StudentEmptyState(
        icon: Icons.inbox_outlined,
        title: context.l10n.emptyTitle,
        message: context.l10n.emptyBody,
      ),
    ),
    'error': (context) => Scaffold(
      appBar: AppBar(title: Text(context.l10n.galleryError)),
      body: StudentErrorState(
        failure: const ServerFailure.status(503, requestId: requestId),
        onRetry: () {},
      ),
    ),
    'offline': (context) => Scaffold(
      body: Column(
        children: [
          const OfflineBar(),
          Expanded(
            child: StudentEmptyState(
              icon: Icons.inbox_outlined,
              title: context.l10n.emptyTitle,
              message: context.l10n.emptyBody,
            ),
          ),
        ],
      ),
    ),
  };

  for (final state in states.entries) {
    for (final locale in locales.entries) {
      testWidgets('${state.key} in ${locale.key}', (tester) async {
        tester.view.physicalSize = phone;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        // The skeleton's shimmer stands still, as on a phone that asks for
        // less motion, so every run draws the same frame.
        tester.platformDispatcher.accessibilityFeaturesTestValue =
            const FakeAccessibilityFeatures(disableAnimations: true);
        addTearDown(
          tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
        );

        await tester.pumpWidget(app(locale.value, state.value));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/${state.key}_${locale.key}.png'),
        );
      });
    }
  }

  test('the long-text locale is about 40 % longer than Hindi', () async {
    final hi = await AppLocalizations.delegate.load(const Locale('hi'));
    final long = PseudoLongLocalizations();

    for (final pair in [
      (hi.emptyBody, long.emptyBody),
      (hi.errorServerBody, long.errorServerBody),
      (hi.offlineBanner, long.offlineBanner),
      (hi.retry, long.retry),
    ]) {
      expect(pair.$2, startsWith('[${pair.$1} '));
      expect(pair.$2.length, greaterThanOrEqualTo(pair.$1.length * 1.4));
      expect(pair.$2, isNot(matches(RegExp('[A-Za-z]'))));
    }
  });
}
