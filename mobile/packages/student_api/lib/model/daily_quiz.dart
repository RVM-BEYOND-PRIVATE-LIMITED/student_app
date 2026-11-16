//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DailyQuiz {
  /// Returns a new [DailyQuiz] instance.
  DailyQuiz({
    required this.date,
    required this.available,
    required this.answered,
    required this.score,
    required this.maxScore,
    this.questions = const [],
  });

  DateTime date;

  bool available;

  bool answered;

  int? score;

  int? maxScore;

  List<DailyQuizQuestionsInner> questions;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DailyQuiz &&
    other.date == date &&
    other.available == available &&
    other.answered == answered &&
    other.score == score &&
    other.maxScore == maxScore &&
    _deepEquality.equals(other.questions, questions);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (date.hashCode) +
    (available.hashCode) +
    (answered.hashCode) +
    (score == null ? 0 : score!.hashCode) +
    (maxScore == null ? 0 : maxScore!.hashCode) +
    (questions.hashCode);

  @override
  String toString() => 'DailyQuiz[date=$date, available=$available, answered=$answered, score=$score, maxScore=$maxScore, questions=$questions]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'date'] = _dateFormatter.format(this.date);
      json[r'available'] = this.available;
      json[r'answered'] = this.answered;
    if (this.score != null) {
      json[r'score'] = this.score;
    } else {
      json[r'score'] = null;
    }
    if (this.maxScore != null) {
      json[r'max_score'] = this.maxScore;
    } else {
      json[r'max_score'] = null;
    }
      json[r'questions'] = this.questions;
    return json;
  }

  /// Returns a new [DailyQuiz] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DailyQuiz? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'date'), 'Required key "DailyQuiz[date]" is missing from JSON.');
        assert(json[r'date'] != null, 'Required key "DailyQuiz[date]" has a null value in JSON.');
        assert(json.containsKey(r'available'), 'Required key "DailyQuiz[available]" is missing from JSON.');
        assert(json[r'available'] != null, 'Required key "DailyQuiz[available]" has a null value in JSON.');
        assert(json.containsKey(r'answered'), 'Required key "DailyQuiz[answered]" is missing from JSON.');
        assert(json[r'answered'] != null, 'Required key "DailyQuiz[answered]" has a null value in JSON.');
        assert(json.containsKey(r'score'), 'Required key "DailyQuiz[score]" is missing from JSON.');
        assert(json.containsKey(r'max_score'), 'Required key "DailyQuiz[max_score]" is missing from JSON.');
        assert(json.containsKey(r'questions'), 'Required key "DailyQuiz[questions]" is missing from JSON.');
        assert(json[r'questions'] != null, 'Required key "DailyQuiz[questions]" has a null value in JSON.');
        return true;
      }());

      return DailyQuiz(
        date: mapDateTime(json, r'date', r'')!,
        available: mapValueOfType<bool>(json, r'available')!,
        answered: mapValueOfType<bool>(json, r'answered')!,
        score: mapValueOfType<int>(json, r'score'),
        maxScore: mapValueOfType<int>(json, r'max_score'),
        questions: DailyQuizQuestionsInner.listFromJson(json[r'questions']),
      );
    }
    return null;
  }

  static List<DailyQuiz> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DailyQuiz>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DailyQuiz.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DailyQuiz> mapFromJson(dynamic json) {
    final map = <String, DailyQuiz>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DailyQuiz.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DailyQuiz-objects as value to a dart map
  static Map<String, List<DailyQuiz>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DailyQuiz>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DailyQuiz.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'date',
    'available',
    'answered',
    'score',
    'max_score',
    'questions',
  };
}

