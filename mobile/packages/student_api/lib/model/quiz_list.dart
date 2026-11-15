//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class QuizList {
  /// Returns a new [QuizList] instance.
  QuizList({
    this.quizzes = const [],
  });

  List<QuizListQuizzesInner> quizzes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is QuizList &&
    _deepEquality.equals(other.quizzes, quizzes);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (quizzes.hashCode);

  @override
  String toString() => 'QuizList[quizzes=$quizzes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'quizzes'] = this.quizzes;
    return json;
  }

  /// Returns a new [QuizList] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static QuizList? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'quizzes'), 'Required key "QuizList[quizzes]" is missing from JSON.');
        assert(json[r'quizzes'] != null, 'Required key "QuizList[quizzes]" has a null value in JSON.');
        return true;
      }());

      return QuizList(
        quizzes: QuizListQuizzesInner.listFromJson(json[r'quizzes']),
      );
    }
    return null;
  }

  static List<QuizList> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <QuizList>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QuizList.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QuizList> mapFromJson(dynamic json) {
    final map = <String, QuizList>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = QuizList.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QuizList-objects as value to a dart map
  static Map<String, List<QuizList>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<QuizList>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QuizList.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'quizzes',
  };
}

