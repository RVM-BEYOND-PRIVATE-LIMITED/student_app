import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core_network/core_network.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/features/connectivity/connectivity_bloc.dart';

/// Android's network interfaces, as connectivity_plus reports them.
class _FakeInterfaces implements Connectivity {
  final _changes = StreamController<List<ConnectivityResult>>.broadcast();
  List<ConnectivityResult> now = const [ConnectivityResult.wifi];

  void change(List<ConnectivityResult> to) {
    now = to;
    _changes.add(to);
  }

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => now;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => _changes.stream;
}

/// core_network's real `ConnectivityService` over fake interfaces and a
/// reachability probe the test answers.
class _FakeConnectivity {
  _FakeConnectivity() {
    service = ConnectivityService(
      connectivity: interfaces,
      probe: () async {
        probes++;
        // The answer is what the network was when the probe started.
        final answer = reachable;
        final hold = holdProbe;
        if (hold != null) await hold.future;
        return answer;
      },
    );
  }

  final interfaces = _FakeInterfaces();
  late final ConnectivityService service;

  /// What the next probe finds.
  bool reachable = true;

  /// Set to make the next probes wait until it completes.
  Completer<void>? holdProbe;
  int probes = 0;

  ConnectivityBloc bloc({
    bool rechecks = true,
    List<Duration> delays = const [Duration(seconds: 5), Duration(seconds: 10)],
  }) => ConnectivityBloc(
    service.onStatusChanged(),
    check: rechecks ? () => service.isOnline : null,
    recheckDelays: delays,
  );
}

/// Closes [bloc] from a test on the fake clock. Its re-check timer stops at
/// once, so no timer is left behind; the rest of `close()` is not waited for,
/// since a bloc's close does not finish inside the test's fake-async zone.
Future<void> _close(WidgetTester tester, ConnectivityBloc bloc) async {
  unawaited(bloc.close());
  await tester.pump();
}

/// The bloc's timers run on the test's clock, so `tester.pump(d)` moves time
/// on by exactly `d`. Each test closes its bloc before it ends.
void main() {
  late _FakeConnectivity net;

  setUp(() => net = _FakeConnectivity());

  testWidgets('a lookup that failed once no longer keeps the banner up: it '
      'checks again on its own, without an interface change', (tester) async {
    net.reachable = false;
    final bloc = net.bloc();
    await tester.pump();
    expect(bloc.state.online, isFalse);

    // The network wakes up; no interface changes, so the stream is silent.
    net.reachable = true;
    await tester.pump(const Duration(seconds: 4));
    expect(bloc.state.online, isFalse, reason: 'the first check is at 5 s');
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(bloc.state.online, isTrue);
    await _close(tester, bloc);
  });

  testWidgets('the checks back off while offline, then stop once online', (
    tester,
  ) async {
    net.reachable = false;
    final bloc = net.bloc();
    await tester.pump();
    final first = net.probes;

    await tester.pump(const Duration(seconds: 5));
    expect(net.probes, first + 1, reason: 'at 5 s');
    await tester.pump(const Duration(seconds: 9));
    expect(net.probes, first + 1, reason: 'the next waits 10 s');
    await tester.pump(const Duration(seconds: 1));
    expect(net.probes, first + 2, reason: 'at 15 s');
    await tester.pump(const Duration(seconds: 10));
    expect(net.probes, first + 3, reason: 'the last delay repeats');

    net.reachable = true;
    await tester.pump(const Duration(seconds: 10));
    await tester.pump();
    expect(bloc.state.online, isTrue);
    final online = net.probes;
    await tester.pump(const Duration(minutes: 5));
    expect(net.probes, online, reason: 'no checks while online');
    await _close(tester, bloc);
  });

  testWidgets('back in the foreground, an offline phone checks again at once', (
    tester,
  ) async {
    net.reachable = false;
    final bloc = net.bloc(delays: const [Duration(minutes: 1)]);
    await tester.pump();
    expect(bloc.state.online, isFalse);

    net.reachable = true;
    bloc.add(const ConnectivityResumed());
    await tester.pump();

    expect(bloc.state.online, isTrue);
    await _close(tester, bloc);
  });

  testWidgets('back in the foreground, an online phone makes no extra check', (
    tester,
  ) async {
    final bloc = net.bloc();
    await tester.pump();
    final probes = net.probes;

    bloc.add(const ConnectivityResumed());
    await tester.pump();

    expect(net.probes, probes);
    expect(bloc.state.online, isTrue);
    await _close(tester, bloc);
  });

  testWidgets('in the background the checks stop; back in the foreground it '
      'checks at once and the back-off starts again', (tester) async {
    net.reachable = false;
    final bloc = net.bloc();
    await tester.pump();
    final first = net.probes;
    await tester.pump(const Duration(seconds: 5));
    expect(net.probes, first + 1, reason: 'at 5 s; the next waits 10 s');

    bloc.add(const ConnectivityPaused());
    await tester.pump();
    await tester.pump(const Duration(minutes: 10));
    expect(net.probes, first + 1, reason: 'no checks in the background');
    expect(bloc.state.online, isFalse);

    bloc.add(const ConnectivityResumed());
    await tester.pump();
    expect(net.probes, first + 2, reason: 'checked at once');
    expect(bloc.state.online, isFalse);
    await tester.pump(const Duration(seconds: 4));
    expect(net.probes, first + 2);
    await tester.pump(const Duration(seconds: 1));
    expect(net.probes, first + 3, reason: 'the back-off starts again at 5 s');
    await _close(tester, bloc);
  });

  testWidgets('in the background neither a network change nor a check that '
      'ends starts the back-off', (tester) async {
    net.reachable = false;
    final bloc = net.bloc(delays: const [Duration(seconds: 5)]);
    await tester.pump();

    // A check is running when the student leaves the app.
    final hold = net.holdProbe = Completer<void>();
    bloc.add(const ConnectivityResumed());
    await tester.pump();
    bloc.add(const ConnectivityPaused());
    await tester.pump();
    net.holdProbe = null;
    hold.complete();
    await tester.pump();
    // The phone moves to mobile data, which does not work either.
    net.interfaces.change(const [ConnectivityResult.mobile]);
    await tester.pump();
    expect(bloc.state.online, isFalse);
    final probes = net.probes;

    await tester.pump(const Duration(minutes: 10));
    expect(net.probes, probes, reason: 'no timer runs in the background');

    net.reachable = true;
    bloc.add(const ConnectivityResumed());
    await tester.pump();
    expect(bloc.state.online, isTrue);
    await _close(tester, bloc);
  });

  testWidgets('a check that hangs counts as offline after its timeout, and '
      'the checks go on', (tester) async {
    var calls = 0;
    final hung = Completer<bool>();
    final status = StreamController<bool>();
    final bloc = ConnectivityBloc(
      status.stream,
      check: () {
        calls++;
        // The first call never answers, as a stuck platform call.
        return calls == 1 ? hung.future : Future.value(true);
      },
      recheckDelays: const [Duration(seconds: 5)],
      checkTimeout: const Duration(seconds: 6),
    );

    status.add(false);
    await tester.pump(const Duration(seconds: 5));
    expect(calls, 1);
    await tester.pump(const Duration(seconds: 5));
    expect(calls, 1, reason: 'still waiting on the first check');
    await tester.pump(const Duration(seconds: 1));
    expect(bloc.state.online, isFalse, reason: 'a timeout is still offline');

    await tester.pump(const Duration(seconds: 5));
    await tester.pump();
    expect(calls, 2, reason: 'the hung call did not stop the checks');
    expect(bloc.state.online, isTrue);

    // The hung call answers at last: nothing listens any more.
    hung.complete(false);
    await tester.pump();
    expect(bloc.state.online, isTrue);
    await _close(tester, bloc);
    unawaited(status.close());
  });

  testWidgets('the foreground check is not lost behind a hung one', (
    tester,
  ) async {
    var calls = 0;
    final status = StreamController<bool>();
    final bloc = ConnectivityBloc(
      status.stream,
      check: () {
        calls++;
        return calls == 1 ? Completer<bool>().future : Future.value(false);
      },
      recheckDelays: const [Duration(seconds: 5)],
    );
    status.add(false);
    await tester.pump();

    bloc.add(const ConnectivityResumed());
    await tester.pump();
    expect(calls, 1);
    await tester.pump(ConnectivityBloc.defaultCheckTimeout);
    await tester.pump();
    expect(bloc.state.online, isFalse);
    await tester.pump(const Duration(seconds: 5));
    expect(calls, 2, reason: 'the back-off runs on after the timeout');
    await _close(tester, bloc);
    unawaited(status.close());
  });

  testWidgets('a check still running when the network speaks is dropped', (
    tester,
  ) async {
    net.reachable = false;
    final bloc = net.bloc(delays: const [Duration(minutes: 1)]);
    await tester.pump();
    expect(bloc.state.online, isFalse);

    // A check starts while offline, and hangs.
    final hold = net.holdProbe = Completer<void>();
    bloc.add(const ConnectivityResumed());
    await tester.pump();
    // Meanwhile the phone moves to mobile data, which works.
    net
      ..holdProbe = null
      ..reachable = true;
    net.interfaces.change(const [ConnectivityResult.mobile]);
    await tester.pump();
    expect(bloc.state.online, isTrue);

    // The stale check ends with "offline": it does not bring the banner back.
    hold.complete();
    await tester.pump();
    expect(bloc.state.online, isTrue);
    await _close(tester, bloc);
  });

  testWidgets('a check that throws keeps the banner and tries again later', (
    tester,
  ) async {
    var calls = 0;
    final status = StreamController<bool>();
    final bloc = ConnectivityBloc(
      status.stream,
      check: () async {
        calls++;
        if (calls == 1) throw StateError('lookup broke');
        return true;
      },
      recheckDelays: const [Duration(seconds: 5)],
    );

    status.add(false);
    await tester.pump(const Duration(seconds: 5));
    await tester.pump();
    expect(calls, 1);
    expect(bloc.state.online, isFalse);

    await tester.pump(const Duration(seconds: 5));
    await tester.pump();
    expect(calls, 2);
    expect(bloc.state.online, isTrue);
    await _close(tester, bloc);
    unawaited(status.close());
  });

  testWidgets('without a check it follows the stream only, as before', (
    tester,
  ) async {
    net.reachable = false;
    final bloc = net.bloc(rechecks: false);
    await tester.pump();
    final probes = net.probes;

    net.reachable = true;
    bloc.add(const ConnectivityResumed());
    await tester.pump(const Duration(minutes: 5));

    expect(bloc.state.online, isFalse);
    expect(net.probes, probes);
    await _close(tester, bloc);
  });

  testWidgets('closing stops the checks', (tester) async {
    net.reachable = false;
    final bloc = net.bloc();
    await tester.pump();
    await _close(tester, bloc);
    final probes = net.probes;

    await tester.pump(const Duration(minutes: 5));

    expect(net.probes, probes);
  });

  test('closing finishes even though the service\'s stream never ends, and '
      'no check runs after it', () async {
    net.reachable = false;
    final bloc = net.bloc(delays: const [Duration(milliseconds: 10)]);
    await Future<void>.delayed(const Duration(milliseconds: 5));

    await bloc.close().timeout(const Duration(seconds: 5));
    final probes = net.probes;
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(bloc.isClosed, isTrue);
    expect(net.probes, probes);
  });

  test('the default check timeout outlasts core_network\'s 3 s lookup', () {
    expect(
      ConnectivityBloc.defaultCheckTimeout,
      greaterThan(const Duration(seconds: 3)),
    );
  });

  test('the default back-off is modest: 5 s first, at most a minute', () {
    expect(
      ConnectivityBloc.defaultRecheckDelays.first,
      const Duration(seconds: 5),
    );
    expect(
      ConnectivityBloc.defaultRecheckDelays,
      everyElement(lessThanOrEqualTo(const Duration(minutes: 1))),
    );
  });
}
