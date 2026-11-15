//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TestScoresCoursesInner {
  /// Returns a new [TestScoresCoursesInner] instance.
  TestScoresCoursesInner({
    required this.courseId,
    required this.name,
    required this.scorePct,
    required this.tests,
  });

  String courseId;

  String? name;

  num? scorePct;

  /// Minimum value: 0
  int tests;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TestScoresCoursesInner &&
    other.courseId == courseId &&
    other.name == name &&
    other.scorePct == scorePct &&
    other.tests == tests;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (courseId.hashCode) +
    (name == null ? 0 : name!.hashCode) +
    (scorePct == null ? 0 : scorePct!.hashCode) +
    (tests.hashCode);

  @override
  String toString() => 'TestScoresCoursesInner[courseId=$courseId, name=$name, scorePct=$scorePct, tests=$tests]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'course_id'] = this.courseId;
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.scorePct != null) {
      json[r'score_pct'] = this.scorePct;
    } else {
      json[r'score_pct'] = null;
    }
      json[r'tests'] = this.tests;
    return json;
  }

  /// Returns a new [TestScoresCoursesInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TestScoresCoursesInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'course_id'), 'Required key "TestScoresCoursesInner[course_id]" is missing from JSON.');
        assert(json[r'course_id'] != null, 'Required key "TestScoresCoursesInner[course_id]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "TestScoresCoursesInner[name]" is missing from JSON.');
        assert(json.containsKey(r'score_pct'), 'Required key "TestScoresCoursesInner[score_pct]" is missing from JSON.');
        assert(json.containsKey(r'tests'), 'Required key "TestScoresCoursesInner[tests]" is missing from JSON.');
        assert(json[r'tests'] != null, 'Required key "TestScoresCoursesInner[tests]" has a null value in JSON.');
        return true;
      }());

      return TestScoresCoursesInner(
        courseId: mapValueOfType<String>(json, r'course_id')!,
        name: mapValueOfType<String>(json, r'name'),
        scorePct: json[r'score_pct'] == null
            ? null
            : num.parse('${json[r'score_pct']}'),
        tests: mapValueOfType<int>(json, r'tests')!,
      );
    }
    return null;
  }

  static List<TestScoresCoursesInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TestScoresCoursesInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TestScoresCoursesInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TestScoresCoursesInner> mapFromJson(dynamic json) {
    final map = <String, TestScoresCoursesInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TestScoresCoursesInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TestScoresCoursesInner-objects as value to a dart map
  static Map<String, List<TestScoresCoursesInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TestScoresCoursesInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TestScoresCoursesInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'course_id',
    'name',
    'score_pct',
    'tests',
  };
}

