import 'package:core_network/core_network.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/models.dart';
import '../../../core/api/student_api.dart';

sealed class JobsEvent {
  const JobsEvent();
}

final class JobsStarted extends JobsEvent {
  const JobsStarted();
}

final class JobsRetried extends JobsEvent {
  const JobsRetried();
}

final class JobsHandoffRequested extends JobsEvent {
  const JobsHandoffRequested();
}

class JobsState extends Equatable {
  const JobsState({
    this.loading = true,
    this.access,
    this.header,
    this.failure,
    this.requesting = false,
    this.handoffUrl,
  });

  final bool loading;
  final JobsAccess? access;
  final JobsHeader? header;
  final Failure? failure;
  final bool requesting;

  /// Set once the server returns the one-minute link. The screen opens it
  /// and never keeps it.
  final Uri? handoffUrl;

  JobsState copyWith({
    bool? loading,
    JobsAccess? access,
    JobsHeader? header,
    Failure? failure,
    bool clearFailure = false,
    bool? requesting,
    Uri? handoffUrl,
    bool clearHandoff = false,
  }) => JobsState(
    loading: loading ?? this.loading,
    access: access ?? this.access,
    header: header ?? this.header,
    failure: clearFailure ? null : (failure ?? this.failure),
    requesting: requesting ?? this.requesting,
    handoffUrl: clearHandoff ? null : (handoffUrl ?? this.handoffUrl),
  );

  @override
  List<Object?> get props => [
    loading,
    access,
    header,
    failure,
    requesting,
    handoffUrl,
  ];
}

/// The Jobs tab's gate (student_app #2, items 7 and 8). Every open asks
/// `GET /v1/me/jobs-access`; only an allowed answer asks for a hand-off link.
/// The fee and consent checks live on the server: the app never decides
/// access itself.
class JobsBloc extends Bloc<JobsEvent, JobsState> {
  JobsBloc(this._api) : super(const JobsState()) {
    on<JobsStarted>(_onStarted);
    on<JobsRetried>(_onStarted);
    on<JobsHandoffRequested>(_onHandoff);
  }

  final StudentApi _api;

  Future<void> _onStarted(JobsEvent event, Emitter<JobsState> emit) async {
    emit(
      state.copyWith(
        loading: true,
        clearFailure: true,
        clearHandoff: true,
      ),
    );
    try {
      final header = (await _api.config()).jobsHeader;
      final access = await _api.jobsAccess();
      emit(
        state.copyWith(
          loading: false,
          header: header,
          access: access,
          clearFailure: true,
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(loading: false, failure: failure));
    }
  }

  Future<void> _onHandoff(
    JobsEvent event,
    Emitter<JobsState> emit,
  ) async {
    // The server decides access. A closed gate never asks for a hand-off,
    // whatever the screen does.
    final access = state.access;
    if (state.requesting || access == null || !access.allowed) return;
    emit(state.copyWith(requesting: true, clearFailure: true));
    try {
      final handoff = await _api.campusHandoff();
      emit(
        state.copyWith(
          requesting: false,
          handoffUrl: handoff.uri,
          clearFailure: true,
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(requesting: false, failure: failure));
    }
  }
}
