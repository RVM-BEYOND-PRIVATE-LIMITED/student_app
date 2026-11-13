import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class ConnectivityEvent {
  const ConnectivityEvent();
}

final class _StatusChanged extends ConnectivityEvent {
  const _StatusChanged(this.online);

  final bool online;
}

/// The app came back to the foreground (`AppLifecycleState.resumed`): while
/// the banner shows, check again at once and start the back-off afresh.
final class ConnectivityResumed extends ConnectivityEvent {
  const ConnectivityResumed();
}

/// The app went to the background (`AppLifecycleState.hidden` or `paused`):
/// the back-off stops until [ConnectivityResumed], so a phone left offline in
/// someone's pocket does not wake up every minute to look for the network.
final class ConnectivityPaused extends ConnectivityEvent {
  const ConnectivityPaused();
}

/// The next check of the back-off is due.
final class _RecheckDue extends ConnectivityEvent {
  const _RecheckDue();
}

class ConnectivityState extends Equatable {
  const ConnectivityState({required this.online});

  final bool online;

  @override
  List<Object?> get props => [online];
}

/// Online or not, from core_network's `ConnectivityService` (a network
/// interface that is up, and a lookup that really reaches the internet).
/// Drives the offline banner. The app starts as online, so a phone that is
/// fine never flashes the banner while the first check runs.
///
/// [status] speaks only when a network interface changes, so a lookup that
/// failed once (a network still waking up) could leave the banner up for
/// good. With [check] given (`ConnectivityService.isOnline` in the app),
/// while the banner shows the bloc checks again on its own, after each of
/// [recheckDelays] in turn and then every last delay, and at once when the
/// app comes back to the foreground ([ConnectivityResumed]). The checks stop
/// as soon as the phone is online again, and while the app is in the
/// background ([ConnectivityPaused]). A check that has not answered within
/// [checkTimeout] counts as still offline, so a platform call that never
/// returns cannot stop the checks for good. Without [check] it only follows
/// [status].
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc(
    Stream<bool> status, {
    Future<bool> Function()? check,
    this.recheckDelays = defaultRecheckDelays,
    this.checkTimeout = defaultCheckTimeout,
  }) : assert(recheckDelays.isNotEmpty),
       _check = check,
       super(const ConnectivityState(online: true)) {
    on<_StatusChanged>((event, emit) {
      // A newer word from the network: a check already running is stale.
      _generation++;
      _attempt = 0;
      _show(event.online, emit);
    });
    on<ConnectivityResumed>((event, emit) async {
      _paused = false;
      if (state.online) return;
      _attempt = 0;
      await _recheck(emit);
    });
    on<ConnectivityPaused>((event, emit) {
      _paused = true;
      _timer?.cancel();
      _timer = null;
    });
    on<_RecheckDue>((event, emit) => _recheck(emit));
    _subscription = status.listen(
      (online) => add(_StatusChanged(online)),
      // A failing check says nothing about the network: keep the last state.
      onError: (Object _) {},
    );
  }

  /// 5 s, 10 s, 20 s, 40 s, then every minute while offline.
  static const defaultRecheckDelays = [
    Duration(seconds: 5),
    Duration(seconds: 10),
    Duration(seconds: 20),
    Duration(seconds: 40),
    Duration(minutes: 1),
  ];

  /// How long one [check] may take. Longer than core_network's own 3 s
  /// lookup, so only a call that hangs (such as `checkConnectivity()` on a
  /// device whose platform side never answers) runs into it.
  static const defaultCheckTimeout = Duration(seconds: 6);

  final List<Duration> recheckDelays;

  final Duration checkTimeout;

  final Future<bool> Function()? _check;
  late final StreamSubscription<bool> _subscription;
  Timer? _timer;
  int _attempt = 0;
  int _generation = 0;
  bool _checking = false;

  /// In the background: no back-off timer runs.
  bool _paused = false;

  void _show(bool online, Emitter<ConnectivityState> emit) {
    emit(ConnectivityState(online: online));
    _timer?.cancel();
    _timer = null;
    if (!online && _check != null && !_paused && !isClosed) {
      final delay =
          recheckDelays[_attempt < recheckDelays.length
              ? _attempt
              : recheckDelays.length - 1];
      _attempt++;
      _timer = Timer(delay, () {
        if (!isClosed) add(const _RecheckDue());
      });
    }
  }

  Future<void> _recheck(Emitter<ConnectivityState> emit) async {
    final check = _check;
    if (check == null || _checking || state.online) return;
    _checking = true;
    final generation = _generation;
    bool online;
    try {
      online = await check().timeout(checkTimeout);
    } catch (_) {
      // A failing or hung check says nothing about the network: the banner
      // stays and the back-off tries again later. A hung call is left behind;
      // if it ever answers, nothing listens.
      online = false;
    } finally {
      _checking = false;
    }
    if (isClosed || emit.isDone) return;
    // The network spoke while the check ran: its word stands. If that word was
    // "offline" while the app was paused, no timer was started then; start
    // the back-off now so re-checks cannot stop (a resume during this check
    // returned early because a check was running).
    if (generation != _generation) {
      if (!state.online && _timer == null) _show(false, emit);
      return;
    }
    _show(online, emit);
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    // Not awaited: core_network's `onStatusChanged()` finishes cancelling
    // only at the next interface change, which may never come.
    unawaited(_subscription.cancel());
    return super.close();
  }
}
