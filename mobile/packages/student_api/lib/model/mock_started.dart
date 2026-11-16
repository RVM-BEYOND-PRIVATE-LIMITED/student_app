//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MockStarted {
  /// Returns a new [MockStarted] instance.
  MockStarted({
    required this.attemptId,
    required this.deadlineAt,
    this.questions = const [],
  });

  String attemptId;

  DateTime deadlineAt;

  List<DailyQuizQuestionsInner> questions;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MockStarted &&
    other.attemptId == attemptId &&
    other.deadlineAt == deadlineAt &&
    _deepEquality.equals(other.questions, questions);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (attemptId.hashCode) +
    (deadlineAt.hashCode) +
    (questions.hashCode);

  @override
  String toString() => 'MockStarted[attemptId=$attemptId, deadlineAt=$deadlineAt, questions=$questions]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'attempt_id'] = this.attemptId;
      json[r'deadline_at'] = this.deadlineAt.toUtc().toIso8601String();
      json[r'questions'] = this.questions;
    return json;
  }

  /// Returns a new [MockStarted] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MockStarted? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'attempt_id'), 'Required key "MockStarted[attempt_id]" is missing from JSON.');
        assert(json[r'attempt_id'] != null, 'Required key "MockStarted[attempt_id]" has a null value in JSON.');
        assert(json.containsKey(r'deadline_at'), 'Required key "MockStarted[deadline_at]" is missing from JSON.');
        assert(json[r'deadline_at'] != null, 'Required key "MockStarted[deadline_at]" has a null value in JSON.');
        assert(json.containsKey(r'questions'), 'Required key "MockStarted[questions]" is missing from JSON.');
        assert(json[r'questions'] != null, 'Required key "MockStarted[questions]" has a null value in JSON.');
        return true;
      }());

      return MockStarted(
        attemptId: mapValueOfType<String>(json, r'attempt_id')!,
        deadlineAt: mapDateTime(json, r'deadline_at', r'')!,
        questions: DailyQuizQuestionsInner.listFromJson(json[r'questions']),
      );
    }
    return null;
  }

  static List<MockStarted> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MockStarted>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MockStarted.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MockStarted> mapFromJson(dynamic json) {
    final map = <String, MockStarted>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MockStarted.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MockStarted-objects as value to a dart map
  static Map<String, List<MockStarted>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MockStarted>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MockStarted.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'attempt_id',
    'deadline_at',
    'questions',
  };
}

