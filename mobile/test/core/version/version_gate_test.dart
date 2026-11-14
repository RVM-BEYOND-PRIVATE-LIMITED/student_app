import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/version/version_gate.dart';

import '../../support/fakes.dart';

void main() {
  group('AppVersion', () {
    test('reads dotted versions, ignoring build and pre-release parts', () {
      expect(AppVersion.parse('1.2.3'), [1, 2, 3]);
      expect(AppVersion.parse('0.1'), [0, 1, 0]);
      expect(AppVersion.parse('2'), [2, 0, 0]);
      expect(AppVersion.parse(' 1.2.3+45 '), [1, 2, 3]);
      expect(AppVersion.parse('1.2.3-beta.1'), [1, 2, 3]);
    });

    test('anything else is not a version', () {
      for (final text in ['', 'x', '1.x', '1..2', '1.2.3.4', 'v1.2', '-1']) {
        expect(AppVersion.parse(text), isNull, reason: text);
      }
    });

    test('compares part by part, as numbers', () {
      expect(AppVersion.isOlder('0.1.0', '0.2.0'), isTrue);
      expect(AppVersion.isOlder('0.9.0', '0.10.0'), isTrue);
      expect(AppVersion.isOlder('1.0.0', '1.0.1'), isTrue);
      expect(AppVersion.isOlder('1.0.0', '1.0.0'), isFalse);
      expect(AppVersion.isOlder('1.0', '1.0.0'), isFalse);
      expect(AppVersion.isOlder('1.10.0', '1.9.0'), isFalse);
      expect(AppVersion.isOlder('2.0.0', '1.99.99'), isFalse);
    });

    test('a value nobody can read never makes a build old', () {
      expect(AppVersion.isOlder('0.1.0', 'soon'), isFalse);
      expect(AppVersion.isOlder('unknown', '9.0.0'), isFalse);
    });
  });

  group('VersionGate (item 10)', () {
    VersionGate gate(
      Future<MinimumVersion> Function() answer, {
      String installed = '0.1.0',
      Duration timeout = const Duration(seconds: 5),
    }) => VersionGate(
      source: FakeVersionSource(answer),
      installedVersion: installed,
      timeout: timeout,
    );

    test('a minimum newer than this build blocks the app', () async {
      expect(
        await gate(() async => const MinimumVersionKnown('0.2.0')).check(),
        const GateUpdateRequired('0.2.0'),
      );
    });

    test('a minimum this build meets lets the app through', () async {
      for (final minimum in ['0.1.0', '0.0.9', '0.1']) {
        expect(
          await gate(() async => MinimumVersionKnown(minimum)).check(),
          const GatePass(),
          reason: minimum,
        );
      }
    });

    group('fails open', () {
      test('when no minimum is published', () async {
        expect(
          await gate(() async => const MinimumVersionUnknown()).check(),
          const GatePass(),
        );
      });

      test('when the check throws (no network, a server error)', () async {
        expect(
          await gate(() async => throw Exception('offline')).check(),
          const GatePass(),
        );
      });

      test('when the check is too slow', () async {
        // A reply that never comes: the app opens once the timeout passes.
        final never = Completer<MinimumVersion>();
        final watch = Stopwatch()..start();

        final decision = await gate(
          () => never.future,
          timeout: const Duration(milliseconds: 50),
        ).check();

        expect(decision, const GatePass());
        expect(watch.elapsed, lessThan(const Duration(seconds: 5)));
      });

      test('the app waits five seconds at most by default', () {
        expect(
          VersionGate(
            source: const UnpublishedVersionSource(),
            installedVersion: '0.1.0',
          ).timeout,
          const Duration(seconds: 5),
        );
      });

      test('when the minimum is not a version', () async {
        expect(
          await gate(() async => const MinimumVersionKnown('latest')).check(),
          const GatePass(),
        );
      });

      test('when this build could not read its own version', () async {
        final source = FakeVersionSource(
          () async => const MinimumVersionKnown('9.0.0'),
        );

        final decision = await VersionGate(
          source: source,
          installedVersion: null,
        ).check();

        expect(decision, const GatePass());
        expect(source.calls, 0);
      });
    });

    test('this build\'s source publishes nothing, so the app opens', () async {
      expect(
        await const UnpublishedVersionSource().minimumVersion(),
        const MinimumVersionUnknown(),
      );
      expect(
        await VersionGate(
          source: const UnpublishedVersionSource(),
          installedVersion: '0.1.0',
        ).check(),
        const GatePass(),
      );
    });
  });
}
