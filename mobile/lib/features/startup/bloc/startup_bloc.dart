import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/session/student_session.dart';
import '../../../core/version/version_gate.dart';

sealed class StartupEvent {
  const StartupEvent();
}

/// The app launched: restore the session, then check the version.
final class StartupStarted extends StartupEvent {
  const StartupStarted();
}

/// "Check again" on the Update-required screen.
final class StartupRetried extends StartupEvent {
  const StartupRetried();
}

enum StartupStatus {
  /// The splash: the session is being restored and the version checked.
  checking,

  /// The app may open.
  ready,

  /// This build is too old: the app stays on the Update-required screen.
  updateRequired,
}

class StartupState extends Equatable {
  const StartupState({
    this.status = StartupStatus.checking,
    this.minimumVersion,
    this.rechecking = false,
  });

  final StartupStatus status;

  /// The oldest version the server serves, when [status] is
  /// [StartupStatus.updateRequired].
  final String? minimumVersion;

  /// True while "Check again" runs.
  final bool rechecking;

  @override
  List<Object?> get props => [status, minimumVersion, rechecking];
}

/// What the splash does (student_app #1, items 5 and 10): restore the
/// session, then run the launch version check.
///
/// Neither step can keep the app shut by failing. A session that cannot be
/// read within [sessionTimeout] is left to restore on first use, and the
/// version check fails open (see [VersionGate]). Only a minimum version that
/// was read and is newer than this build stops the app.
class StartupBloc extends Bloc<StartupEvent, StartupState> {
  StartupBloc({
    required StudentSession session,
    required VersionGate gate,
    this.sessionTimeout = const Duration(seconds: 5),
  }) : _session = session,
       _gate = gate,
       super(const StartupState()) {
    on<StartupStarted>(_onStarted);
    on<StartupRetried>(_onRetried);
  }

  final StudentSession _session;
  final VersionGate _gate;
  final Duration sessionTimeout;

  Future<void> _onStarted(
    StartupStarted event,
    Emitter<StartupState> emit,
  ) async {
    emit(const StartupState());
    try {
      await _session.load().timeout(sessionTimeout);
    } catch (_) {
      // A slow or failing secure store must not hold the splash: the session
      // is read again the first time a request needs it.
    }
    emit(_stateFor(await _gate.check()));
  }

  Future<void> _onRetried(
    StartupRetried event,
    Emitter<StartupState> emit,
  ) async {
    if (state.rechecking) return;
    emit(
      StartupState(
        status: state.status,
        minimumVersion: state.minimumVersion,
        rechecking: true,
      ),
    );
    emit(_stateFor(await _gate.check()));
  }

  static StartupState _stateFor(GateDecision decision) => switch (decision) {
    GateUpdateRequired(:final minimumVersion) => StartupState(
      status: StartupStatus.updateRequired,
      minimumVersion: minimumVersion,
    ),
    GatePass() => const StartupState(status: StartupStatus.ready),
  };
}
