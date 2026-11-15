import 'package:core_network/core_network.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/models.dart';
import '../../../core/api/student_api.dart';

sealed class HomeEvent {
  const HomeEvent();
}

final class HomeStarted extends HomeEvent {
  const HomeStarted();
}

final class HomePromptDismissed extends HomeEvent {
  const HomePromptDismissed(this.id);
  final String id;
}

final class HomeConsentAnswered extends HomeEvent {
  const HomeConsentAnswered({required this.id, required this.yes});
  final String id;
  final bool yes;
}

class HomeState extends Equatable {
  const HomeState({
    this.loading = true,
    this.prompts = const [],
    this.consentRequests = const [],
    this.failure,
  });

  final bool loading;
  final List<PlacementPrompt> prompts;
  final List<ConsentRequest> consentRequests;
  final Failure? failure;

  HomeState copyWith({
    bool? loading,
    List<PlacementPrompt>? prompts,
    List<ConsentRequest>? consentRequests,
    Failure? failure,
    bool clearFailure = false,
  }) => HomeState(
    loading: loading ?? this.loading,
    prompts: prompts ?? this.prompts,
    consentRequests: consentRequests ?? this.consentRequests,
    failure: clearFailure ? null : (failure ?? this.failure),
  );

  @override
  List<Object?> get props => [loading, prompts, consentRequests, failure];
}

/// The two in-app cards of Stage 1A (student_app #2, item 12): "You were
/// selected: upload your proof" and a company's consent question. The server
/// keeps both lists; the app answers and shows what the server returns.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._api) : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomePromptDismissed>(_onDismiss);
    on<HomeConsentAnswered>(_onAnswer);
  }

  final StudentApi _api;

  Future<void> _onStarted(HomeEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(loading: true, clearFailure: true));
    try {
      final prompts = await _api.placementPrompts();
      final requests = await _api.consentRequests();
      emit(
        state.copyWith(
          loading: false,
          prompts: prompts.where((p) => p.status == 'open').toList(),
          consentRequests: requests
              .where((r) => r.status == 'pending')
              .toList(),
          clearFailure: true,
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(loading: false, failure: failure));
    }
  }

  Future<void> _onDismiss(
    HomePromptDismissed event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await _api.dismissPlacementPrompt(event.id);
      emit(
        state.copyWith(
          prompts: state.prompts.where((p) => p.id != event.id).toList(),
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure));
    }
  }

  Future<void> _onAnswer(
    HomeConsentAnswered event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await _api.answerConsentRequest(id: event.id, yes: event.yes);
      emit(
        state.copyWith(
          consentRequests: state.consentRequests
              .where((r) => r.id != event.id)
              .toList(),
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure));
    }
  }
}
