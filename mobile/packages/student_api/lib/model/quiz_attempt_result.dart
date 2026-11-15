//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class QuizAttemptResult {
  /// Returns a new [QuizAttemptResult] instance.
  QuizAttemptResult({
    required this.id,
    required this.score,
    required this.maxScore,
    required this.suggestedCourse,
  });

  String id;

  /// Minimum value: 0
  int score;

  /// Minimum value: 0
  int maxScore;

  QuizAttemptResultSuggestedCourse? suggestedCourse;

  @override
  bool operator ==(Object other) => identical(this, other) || other is QuizAttemptResult &&
    other.id == id &&
    other.score == score &&
    other.maxScore == maxScore &&
    other.suggestedCourse == suggestedCourse;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (score.hashCode) +
    (maxScore.hashCode) +
    (suggestedCourse == null ? 0 : suggestedCourse!.hashCode);

  @override
  String toString() => 'QuizAttemptResult[id=$id, score=$score, maxScore=$maxScore, suggestedCourse=$suggestedCourse]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'score'] = this.score;
      json[r'max_score'] = this.maxScore;
    if (this.suggestedCourse != null) {
      json[r'suggested_course'] = this.suggestedCourse;
    } else {
      json[r'suggested_course'] = null;
    }
    return json;
  }

  /// Returns a new [QuizAttemptResult] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static QuizAttemptResult? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "QuizAttemptResult[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "QuizAttemptResult[id]" has a null value in JSON.');
        assert(json.containsKey(r'score'), 'Required key "QuizAttemptResult[score]" is missing from JSON.');
        assert(json[r'score'] != null, 'Required key "QuizAttemptResult[score]" has a null value in JSON.');
        assert(json.containsKey(r'max_score'), 'Required key "QuizAttemptResult[max_score]" is missing from JSON.');
        assert(json[r'max_score'] != null, 'Required key "QuizAttemptResult[max_score]" has a null value in JSON.');
        assert(json.containsKey(r'suggested_course'), 'Required key "QuizAttemptResult[suggested_course]" is missing from JSON.');
        return true;
      }());

      return QuizAttemptResult(
        id: mapValueOfType<String>(json, r'id')!,
        score: mapValueOfType<int>(json, r'score')!,
        maxScore: mapValueOfType<int>(json, r'max_score')!,
        suggestedCourse: QuizAttemptResultSuggestedCourse.fromJson(json[r'suggested_course']),
      );
    }
    return null;
  }

  static List<QuizAttemptResult> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <QuizAttemptResult>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QuizAttemptResult.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QuizAttemptResult> mapFromJson(dynamic json) {
    final map = <String, QuizAttemptResult>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = QuizAttemptResult.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QuizAttemptResult-objects as value to a dart map
  static Map<String, List<QuizAttemptResult>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<QuizAttemptResult>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QuizAttemptResult.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'score',
    'max_score',
    'suggested_course',
  };
}

