import 'package:core_network/core_network.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/models.dart';
import '../../../core/api/student_api.dart';

sealed class ConsentEvent {
  const ConsentEvent();
}

final class ConsentStarted extends ConsentEvent {
  const ConsentStarted({required this.language, required this.account});
  final String language;
  final StudentAccount account;
}

final class ConsentAgeChanged extends ConsentEvent {
  const ConsentAgeChanged(this.value);
  final bool value;
}

final class ConsentShareProfileChanged extends ConsentEvent {
  const ConsentShareProfileChanged(this.value);
  final bool value;
}

final class ConsentMarketingChanged extends ConsentEvent {
  const ConsentMarketingChanged(this.value);
  final bool value;
}

final class ConsentSubmitted extends ConsentEvent {
  const ConsentSubmitted();
}

class ConsentState extends Equatable {
  const ConsentState({
    this.loading = true,
    this.texts = const [],
    this.ageConfirmed = false,
    this.shareProfile = false,
    this.marketingStory = false,
    this.saving = false,
    this.failure,
    this.savedAccount,
  });

  final bool loading;

  /// The server's lines for the app's language, required first.
  final List<ConsentText> texts;
  final bool ageConfirmed;
  final bool shareProfile;
  final bool marketingStory;
  final bool saving;
  final Failure? failure;

  /// Set once the server has stored the ticks; the screen then moves on.
  final StudentAccount? savedAccount;

  ConsentText? get shareProfileText => _find('share_profile');
  ConsentText? get marketingText => _find('marketing_story');

  ConsentText? _find(String purpose) {
    for (final text in texts) {
      if (text.purpose == purpose) return text;
    }
    return null;
  }

  bool get canSubmit =>
      !loading &&
      !saving &&
      ageConfirmed &&
      shareProfile &&
      (shareProfileText?.version ?? 0) > 0;

  ConsentState copyWith({
    bool? loading,
    List<ConsentText>? texts,
    bool? ageConfirmed,
    bool? shareProfile,
    bool? marketingStory,
    bool? saving,
    Failure? failure,
    bool clearFailure = false,
    StudentAccount? savedAccount,
  }) => ConsentState(
    loading: loading ?? this.loading,
    texts: texts ?? this.texts,
    ageConfirmed: ageConfirmed ?? this.ageConfirmed,
    shareProfile: shareProfile ?? this.shareProfile,
    marketingStory: marketingStory ?? this.marketingStory,
    saving: saving ?? this.saving,
    failure: clearFailure ? null : (failure ?? this.failure),
    savedAccount: savedAccount ?? this.savedAccount,
  );

  @override
  List<Object?> get props => [
    loading,
    texts,
    ageConfirmed,
    shareProfile,
    marketingStory,
    saving,
    failure,
    savedAccount,
  ];
}

/// The 18+ tick and the two consent lines (student_app #2, item 2). The text
/// and its version come from the server; the app sends back the versions it
/// showed. The marketing line is optional and may stay unticked.
class ConsentBloc extends Bloc<ConsentEvent, ConsentState> {
  ConsentBloc(this._api) : super(const ConsentState()) {
    on<ConsentStarted>(_onStarted);
    on<ConsentAgeChanged>(
      (event, emit) => emit(state.copyWith(ageConfirmed: event.value)),
    );
    on<ConsentShareProfileChanged>(
      (event, emit) => emit(state.copyWith(shareProfile: event.value)),
    );
    on<ConsentMarketingChanged>(
      (event, emit) => emit(state.copyWith(marketingStory: event.value)),
    );
    on<ConsentSubmitted>(_onSubmitted);
  }

  final StudentApi _api;

  Future<void> _onStarted(
    ConsentStarted event,
    Emitter<ConsentState> emit,
  ) async {
    emit(const ConsentState());
    try {
      final texts = await _api.consentTexts();
      final forLanguage = texts.where((t) => t.language == event.language);
      final chosen = forLanguage.isEmpty
          ? texts.where((t) => t.language == 'en')
          : forLanguage;
      emit(
        ConsentState(
          loading: false,
          texts: chosen.toList()
            ..sort((a, b) => a.required == b.required
                ? a.purpose.compareTo(b.purpose)
                : (a.required ? -1 : 1)),
          ageConfirmed: event.account.ageConfirmed,
          shareProfile: event.account.requiredConsentGiven,
        ),
      );
    } on Failure catch (failure) {
      emit(ConsentState(loading: false, failure: failure));
    }
  }

  Future<void> _onSubmitted(
    ConsentEvent event,
    Emitter<ConsentState> emit,
  ) async {
    if (!state.canSubmit) return;
    emit(state.copyWith(saving: true, clearFailure: true));
    try {
      var account = await _api.confirmAge();
      final share = state.shareProfileText!.version;
      final marketing = state.marketingText?.version ?? share;
      await _api.setConsents(
        shareProfile: true,
        marketingStory: state.marketingStory,
        shareProfileVersion: share,
        marketingStoryVersion: marketing,
      );
      account = await _api.me();
      emit(state.copyWith(saving: false, savedAccount: account));
    } on Failure catch (failure) {
      emit(state.copyWith(saving: false, failure: failure));
    }
  }
}
