import 'package:core_bloc/core_bloc.dart';
import 'package:core_network/core_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/features/connectivity/offline_banner.dart';
import 'package:rvm_student/l10n/l10n.dart';
import 'package:rvm_student/widgets/load_state_view.dart';
import 'package:rvm_student/widgets/states.dart';

import '../support/screen.dart';

/// Every kind of failure core_network makes.
const _failures = <Failure>[
  NoConnectionFailure(),
  TimeoutFailure(),
  UnauthorizedFailure(),
  ForbiddenFailure(),
  NotFoundFailure(),
  TooManyRequestsFailure(),
  ServerFailure(),
  BadResponseFailure('Request could not be completed.', statusCode: 409),
  ParseFailure(),
  UnknownFailure(),
];

void main() {
  late AppLocalizations en;
  late AppLocalizations hi;

  setUpAll(() async {
    en = await AppLocalizations.delegate.load(english);
    hi = await AppLocalizations.delegate.load(hindi);
  });

  Widget scaffold(Widget body, {Locale locale = english}) =>
      localized(Scaffold(body: body), locale: locale);

  group('error state (item 7)', () {
    testWidgets('shows the cause, the request id and a retry', (tester) async {
      var retries = 0;
      await tester.pumpWidget(
        scaffold(
          StudentErrorState(
            failure: const ServerFailure.status(503, requestId: 'req-test-01'),
            onRetry: () => retries++,
          ),
        ),
      );

      expect(find.text(en.errorServerTitle), findsOneWidget);
      expect(find.text(en.errorServerBody), findsOneWidget);
      expect(find.text(en.requestIdLabel), findsOneWidget);
      expect(find.text('req-test-01'), findsOneWidget);

      await tester.tap(find.text(en.retry));
      expect(retries, 1);
    });

    testWidgets('the request id can be copied for support', (tester) async {
      final copied = <String>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied.add((call.arguments as Map)['text'] as String);
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await tester.pumpWidget(
        scaffold(
          const StudentErrorState(
            failure: NotFoundFailure(null, null, 'req-test-02'),
          ),
          locale: hindi,
        ),
      );

      await tester.tap(find.byTooltip(hi.copyRequestId));
      await tester.pump();

      expect(copied, ['req-test-02']);
      expect(find.text(hi.copied), findsOneWidget);
    });

    testWidgets('a reply without a request id shows no id box', (tester) async {
      await tester.pumpWidget(
        scaffold(
          StudentErrorState(failure: const TimeoutFailure(), onRetry: () {}),
        ),
      );

      expect(find.byType(RequestIdBox), findsNothing);
      expect(find.text(en.errorTimeoutTitle), findsOneWidget);
    });

    testWidgets('no retry button when there is nothing to retry', (
      tester,
    ) async {
      await tester.pumpWidget(
        scaffold(const StudentErrorState(failure: UnknownFailure())),
      );

      expect(find.text(en.retry), findsNothing);
    });

    testWidgets('every failure has its own words, never the English message', (
      tester,
    ) async {
      final titles = <String>{};
      for (final failure in _failures) {
        final copy = FailureCopy.of(failure, hi);
        titles.add(copy.title);
        expect(copy.title, isNot(failure.message));
        expect(copy.body, isNot(failure.message));
      }
      // No connection and the offline banner may share words; every other
      // cause reads differently.
      expect(titles, hasLength(_failures.length));
    });

    for (final failure in _failures) {
      testWidgets(
        'check 2: ${failure.runtimeType} in Hindi has no English, and fits a '
        'small phone at large text',
        (tester) async {
          useSurface(tester, smallPhone);
          tester.platformDispatcher.textScaleFactorTestValue = 1.5;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          await tester.pumpWidget(
            scaffold(
              StudentErrorState(
                failure: _withRequestId(failure),
                onRetry: () {},
              ),
              locale: hindi,
            ),
          );

          expect(englishOnScreen(tester), isEmpty);
          expect(tester.takeException(), isNull);
        },
      );
    }
  });

  group('empty, skeleton and offline (shared states)', () {
    testWidgets('empty state in Hindi', (tester) async {
      await tester.pumpWidget(
        scaffold(
          StudentEmptyState(
            icon: Icons.inbox_outlined,
            title: hi.emptyTitle,
            message: hi.emptyBody,
          ),
          locale: hindi,
        ),
      );

      expect(find.text(hi.emptyTitle), findsOneWidget);
      expect(englishOnScreen(tester), isEmpty);
    });

    testWidgets('the skeleton is read out as loading, in the language', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(scaffold(const SkeletonList(), locale: hindi));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.bySemanticsLabel(hi.loading), findsOneWidget);
      expect(englishOnScreen(tester), isEmpty);
      semantics.dispose();
    });

    testWidgets('the skeleton stands still when the phone asks for less '
        'motion', (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await tester.pumpWidget(scaffold(const SkeletonList()));
      await tester.pump();

      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('the offline bar in Hindi', (tester) async {
      await tester.pumpWidget(
        scaffold(const Column(children: [OfflineBar()]), locale: hindi),
      );

      expect(find.text(hi.offlineBanner), findsOneWidget);
      expect(englishOnScreen(tester), isEmpty);
    });
  });

  group('LoadStateView', () {
    Future<void> pump(WidgetTester tester, LoadState<List<int>> state) =>
        tester.pumpWidget(
          scaffold(
            LoadStateView<List<int>>(
              state: state,
              onRetry: () {},
              builder: (context, data) => Text('items ${data.length}'),
            ),
          ),
        );

    testWidgets('loading shows the skeleton', (tester) async {
      await pump(tester, const LoadState<List<int>>());
      expect(find.byType(SkeletonList), findsOneWidget);

      await pump(
        tester,
        const LoadState<List<int>>(status: LoadStatus.loading),
      );
      expect(find.byType(SkeletonList), findsOneWidget);
    });

    testWidgets('data shows the content', (tester) async {
      await pump(
        tester,
        const LoadState<List<int>>(status: LoadStatus.success, data: [1, 2]),
      );
      expect(find.text('items 2'), findsOneWidget);
    });

    testWidgets('nothing to show shows the empty state', (tester) async {
      await pump(tester, const LoadState<List<int>>(status: LoadStatus.empty));
      expect(find.text(en.emptyTitle), findsOneWidget);
    });

    testWidgets('a failed first load shows the error with its request id', (
      tester,
    ) async {
      await pump(
        tester,
        const LoadState<List<int>>(
          status: LoadStatus.failure,
          failure: ServerFailure.status(500, requestId: 'req-test-03'),
        ),
      );
      expect(find.byType(StudentErrorState), findsOneWidget);
      expect(find.text('req-test-03'), findsOneWidget);
    });

    testWidgets('a failed refresh keeps the data on screen', (tester) async {
      await pump(
        tester,
        const LoadState<List<int>>(
          status: LoadStatus.failure,
          data: [1],
          failure: NoConnectionFailure(),
        ),
      );
      expect(find.text('items 1'), findsOneWidget);
      expect(find.byType(StudentErrorState), findsNothing);
    });
  });
}

/// [failure] as a reply carrying a request id would make it, where the type
/// can hold one.
Failure _withRequestId(Failure failure) => switch (failure) {
  ServerFailure() => const ServerFailure.status(500, requestId: 'req-test-04'),
  NotFoundFailure() => const NotFoundFailure(null, null, 'req-test-04'),
  ForbiddenFailure() => const ForbiddenFailure(null, null, 'req-test-04'),
  UnauthorizedFailure() => const UnauthorizedFailure(requestId: 'req-test-04'),
  TooManyRequestsFailure() => const TooManyRequestsFailure(null, 'req-test-04'),
  BadResponseFailure() => const BadResponseFailure(
    'x',
    statusCode: 409,
    requestId: 'req-test-04',
  ),
  _ => failure,
};
