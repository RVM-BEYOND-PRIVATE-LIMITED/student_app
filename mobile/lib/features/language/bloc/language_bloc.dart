import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/l10n.dart';
import '../language_store.dart';

sealed class LanguageEvent {
  const LanguageEvent();
}

/// The student picked [language].
final class LanguageSelected extends LanguageEvent {
  const LanguageSelected(this.language);

  final AppLanguage language;
}

class LanguageState extends Equatable {
  const LanguageState({required this.deviceDefault, this.chosen});

  /// The student's saved choice; null until they make one.
  final AppLanguage? chosen;

  /// What the app shows before a choice: the phone's language, if the app
  /// speaks it, else English.
  final AppLanguage deviceDefault;

  /// The language on screen and in every request's `Accept-Language`.
  AppLanguage get language => chosen ?? deviceDefault;

  /// True once the student has picked a language; until then the app opens
  /// on the language screen.
  bool get hasChosen => chosen != null;

  @override
  List<Object?> get props => [chosen, deviceDefault];
}

/// The app's language (student_app #1, item 8).
///
/// A choice switches the app at once and is saved, so the next launch opens
/// in it. If saving fails, the choice still holds until the app closes.
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc({
    required LanguageStore store,
    required AppLanguage deviceDefault,
    AppLanguage? saved,
  }) : _store = store,
       super(LanguageState(deviceDefault: deviceDefault, chosen: saved)) {
    on<LanguageSelected>(_onSelected);
  }

  final LanguageStore _store;

  Future<void> _onSelected(
    LanguageSelected event,
    Emitter<LanguageState> emit,
  ) async {
    emit(
      LanguageState(deviceDefault: state.deviceDefault, chosen: event.language),
    );
    try {
      await _store.write(event.language);
    } catch (_) {
      // Shown for this run; asked again at the next launch.
    }
  }
}
