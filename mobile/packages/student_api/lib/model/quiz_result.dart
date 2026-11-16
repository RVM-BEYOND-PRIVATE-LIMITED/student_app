//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class QuizResult {
  /// Returns a new [QuizResult] instance.
  QuizResult({
    required this.score,
    required this.maxScore,
    required this.late_,
    this.answers = const {},
  });

  /// Minimum value: 0
  int score;

  /// Minimum value: 0
  int maxScore;

  bool late_;

  Map<String, String?> answers;

  @override
  bool operator ==(Object other) => identical(this, other) || other is QuizResult &&
    other.score == score &&
    other.maxScore == maxScore &&
    other.late_ == late_ &&
    _deepEquality.equals(other.answers, answers);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (score.hashCode) +
    (maxScore.hashCode) +
    (late_.hashCode) +
    (answers.hashCode);

  @override
  String toString() => 'QuizResult[score=$score, maxScore=$maxScore, late_=$late_, answers=$answers]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'score'] = this.score;
      json[r'max_score'] = this.maxScore;
      json[r'late'] = this.late_;
      json[r'answers'] = this.answers;
    return json;
  }

  /// Returns a new [QuizResult] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static QuizResult? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'score'), 'Required key "QuizResult[score]" is missing from JSON.');
        assert(json[r'score'] != null, 'Required key "QuizResult[score]" has a null value in JSON.');
        assert(json.containsKey(r'max_score'), 'Required key "QuizResult[max_score]" is missing from JSON.');
        assert(json[r'max_score'] != null, 'Required key "QuizResult[max_score]" has a null value in JSON.');
        assert(json.containsKey(r'late'), 'Required key "QuizResult[late]" is missing from JSON.');
        assert(json[r'late'] != null, 'Required key "QuizResult[late]" has a null value in JSON.');
        assert(json.containsKey(r'answers'), 'Required key "QuizResult[answers]" is missing from JSON.');
        assert(json[r'answers'] != null, 'Required key "QuizResult[answers]" has a null value in JSON.');
        return true;
      }());

      return QuizResult(
        score: mapValueOfType<int>(json, r'score')!,
        maxScore: mapValueOfType<int>(json, r'max_score')!,
        late_: mapValueOfType<bool>(json, r'late')!,
        answers: mapCastOfType<String, String>(json, r'answers')!,
      );
    }
    return null;
  }

  static List<QuizResult> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <QuizResult>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QuizResult.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QuizResult> mapFromJson(dynamic json) {
    final map = <String, QuizResult>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = QuizResult.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QuizResult-objects as value to a dart map
  static Map<String, List<QuizResult>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<QuizResult>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QuizResult.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'score',
    'max_score',
    'late',
    'answers',
  };
}

