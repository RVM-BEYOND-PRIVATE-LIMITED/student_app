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
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc(Stream<bool> status)
    : super(const ConnectivityState(online: true)) {
    on<_StatusChanged>((event, emit) {
      emit(ConnectivityState(online: event.online));
    });
    _subscription = status.listen(
      (online) => add(_StatusChanged(online)),
      // A failing check says nothing about the network: keep the last state.
      onError: (Object _) {},
    );
  }

  late final StreamSubscription<bool> _subscription;

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
