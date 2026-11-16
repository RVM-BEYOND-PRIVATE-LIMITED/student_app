//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TestScores {
  /// Returns a new [TestScores] instance.
  TestScores({
    required this.overallPct,
    this.courses = const [],
    this.tests = const [],
  });

  num? overallPct;

  List<TestScoresCoursesInner> courses;

  List<TestScoresTestsInner> tests;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TestScores &&
    other.overallPct == overallPct &&
    _deepEquality.equals(other.courses, courses) &&
    _deepEquality.equals(other.tests, tests);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (overallPct == null ? 0 : overallPct!.hashCode) +
    (courses.hashCode) +
    (tests.hashCode);

  @override
  String toString() => 'TestScores[overallPct=$overallPct, courses=$courses, tests=$tests]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.overallPct != null) {
      json[r'overall_pct'] = this.overallPct;
    } else {
      json[r'overall_pct'] = null;
    }
      json[r'courses'] = this.courses;
      json[r'tests'] = this.tests;
    return json;
  }

  /// Returns a new [TestScores] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TestScores? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'overall_pct'), 'Required key "TestScores[overall_pct]" is missing from JSON.');
        assert(json.containsKey(r'courses'), 'Required key "TestScores[courses]" is missing from JSON.');
        assert(json[r'courses'] != null, 'Required key "TestScores[courses]" has a null value in JSON.');
        assert(json.containsKey(r'tests'), 'Required key "TestScores[tests]" is missing from JSON.');
        assert(json[r'tests'] != null, 'Required key "TestScores[tests]" has a null value in JSON.');
        return true;
      }());

      return TestScores(
        overallPct: json[r'overall_pct'] == null
            ? null
            : num.parse('${json[r'overall_pct']}'),
        courses: TestScoresCoursesInner.listFromJson(json[r'courses']),
        tests: TestScoresTestsInner.listFromJson(json[r'tests']),
      );
    }
    return null;
  }

  static List<TestScores> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TestScores>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TestScores.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TestScores> mapFromJson(dynamic json) {
    final map = <String, TestScores>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TestScores.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TestScores-objects as value to a dart map
  static Map<String, List<TestScores>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TestScores>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TestScores.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'overall_pct',
    'courses',
    'tests',
  };
}

