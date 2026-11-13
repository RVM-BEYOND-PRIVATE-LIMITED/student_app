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
/// the banner shows, check again at once.
final class ConnectivityResumed extends ConnectivityEvent {
  const ConnectivityResumed();
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
/// as soon as the phone is online again. Without [check] it only follows
/// [status].
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc(
    Stream<bool> status, {
    Future<bool> Function()? check,
    this.recheckDelays = defaultRecheckDelays,
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
      if (state.online) return;
      _attempt = 0;
      await _recheck(emit);
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

  final List<Duration> recheckDelays;

  final Future<bool> Function()? _check;
  late final StreamSubscription<bool> _subscription;
  Timer? _timer;
  int _attempt = 0;
  int _generation = 0;
  bool _checking = false;

  void _show(bool online, Emitter<ConnectivityState> emit) {
    emit(ConnectivityState(online: online));
    _timer?.cancel();
    _timer = null;
    if (!online && _check != null && !isClosed) {
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
      online = await check();
    } catch (_) {
      // A failing check says nothing about the network: try again later.
      online = false;
    } finally {
      _checking = false;
    }
    if (isClosed || emit.isDone) return;
    // The network spoke while the check ran: its word stands.
    if (generation != _generation) return;
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
