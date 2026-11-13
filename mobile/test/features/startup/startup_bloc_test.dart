import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/session/student_session.dart';
import 'package:rvm_student/core/version/version_gate.dart';
import 'package:rvm_student/features/startup/bloc/startup_bloc.dart';

import '../../support/fakes.dart';

void main() {
  late FakeSecureStore store;
  late StudentSession session;

  setUp(() {
    store = FakeSecureStore();
    session = StudentSession(store);
  });

  StartupBloc bloc(
    Future<MinimumVersion> Function() answer, {
    Duration sessionTimeout = const Duration(seconds: 5),
  }) => StartupBloc(
    session: session,
    gate: VersionGate(
      source: FakeVersionSource(answer),
      installedVersion: '0.1.0',
    ),
    sessionTimeout: sessionTimeout,
  );

  test('starts on the splash', () {
    final startup = bloc(() async => const MinimumVersionUnknown());
    addTearDown(startup.close);

    expect(startup.state.status, StartupStatus.checking);
  });

  blocTest<StartupBloc, StartupState>(
    'restores the session, then opens the app when nothing blocks it',
    setUp: () {
      store.values[StudentSession.accessTokenKey] = 'access-1';
    },
    build: () => bloc(() async => const MinimumVersionUnknown()),
    act: (b) => b.add(const StartupStarted()),
    expect: () => [
      const StartupState(),
      const StartupState(status: StartupStatus.ready),
    ],
    verify: (_) async {
      // The session was read during the splash: no later read is needed.
      final reads = store.reads;
      expect(await session.hasSession(), isTrue);
      expect(store.reads, reads);
      // And the install id was made once.
      expect(store.values[StudentSession.installIdKey], isNotNull);
    },
  );

  blocTest<StartupBloc, StartupState>(
    'a build older than the published minimum stops on Update required',
    build: () => bloc(() async => const MinimumVersionKnown('0.2.0')),
    act: (b) => b.add(const StartupStarted()),
    expect: () => [
      const StartupState(),
      const StartupState(
        status: StartupStatus.updateRequired,
        minimumVersion: '0.2.0',
      ),
    ],
  );

  blocTest<StartupBloc, StartupState>(
    'a failing version check opens the app (fail open)',
    build: () => bloc(() async => throw Exception('offline')),
    act: (b) => b.add(const StartupStarted()),
    expect: () => [
      const StartupState(),
      const StartupState(status: StartupStatus.ready),
    ],
  );

  blocTest<StartupBloc, StartupState>(
    'a secure store that fails does not hold the splash',
    setUp: () => store.failReads = StateError('keystore busy'),
    build: () => bloc(() async => const MinimumVersionUnknown()),
    act: (b) => b.add(const StartupStarted()),
    expect: () => [
      const StartupState(),
      const StartupState(status: StartupStatus.ready),
    ],
  );

  blocTest<StartupBloc, StartupState>(
    'a secure store that never answers does not hold the splash',
    build: () {
      final hanging = _HangingStore();
      session = StudentSession(hanging);
      return bloc(
        () async => const MinimumVersionUnknown(),
        sessionTimeout: const Duration(milliseconds: 20),
      );
    },
    act: (b) => b.add(const StartupStarted()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      const StartupState(),
      const StartupState(status: StartupStatus.ready),
    ],
  );

  blocTest<StartupBloc, StartupState>(
    '"Check again" opens the app once the phone has the new build',
    build: () {
      var calls = 0;
      return bloc(() async {
        calls++;
        return calls == 1
            ? const MinimumVersionKnown('0.2.0')
            : const MinimumVersionKnown('0.1.0');
      });
    },
    act: (b) async {
      b.add(const StartupStarted());
      await b.stream.firstWhere(
        (s) => s.status == StartupStatus.updateRequired,
      );
      b.add(const StartupRetried());
    },
    expect: () => [
      const StartupState(),
      const StartupState(
        status: StartupStatus.updateRequired,
        minimumVersion: '0.2.0',
      ),
      const StartupState(
        status: StartupStatus.updateRequired,
        minimumVersion: '0.2.0',
        rechecking: true,
      ),
      const StartupState(status: StartupStatus.ready),
    ],
  );

  blocTest<StartupBloc, StartupState>(
    'taps on "Check again" while it runs are ignored',
    build: () {
      final source = FakeVersionSource(
        () async => const MinimumVersionKnown('0.2.0'),
      );
      return StartupBloc(
        session: session,
        gate: VersionGate(source: source, installedVersion: '0.1.0'),
      );
    },
    seed: () => const StartupState(
      status: StartupStatus.updateRequired,
      minimumVersion: '0.2.0',
      rechecking: true,
    ),
    act: (b) => b.add(const StartupRetried()),
    expect: () => <StartupState>[],
  );
}

/// A secure store whose reads never finish, like a Keystore that hangs.
class _HangingStore extends FakeSecureStore {
  @override
  Future<String?> read({required String key}) => Completer<String?>().future;
}
