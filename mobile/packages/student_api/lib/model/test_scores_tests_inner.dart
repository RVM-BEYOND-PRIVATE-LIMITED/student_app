//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TestScoresTestsInner {
  /// Returns a new [TestScoresTestsInner] instance.
  TestScoresTestsInner({
    required this.testId,
    required this.courseId,
    required this.moduleName,
    required this.testDate,
    required this.maxMarks,
    required this.marks,
    required this.absent,
    required this.pct,
  });

  String testId;

  String courseId;

  String moduleName;

  DateTime testDate;

  num maxMarks;

  num? marks;

  bool absent;

  num? pct;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TestScoresTestsInner &&
    other.testId == testId &&
    other.courseId == courseId &&
    other.moduleName == moduleName &&
    other.testDate == testDate &&
    other.maxMarks == maxMarks &&
    other.marks == marks &&
    other.absent == absent &&
    other.pct == pct;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (testId.hashCode) +
    (courseId.hashCode) +
    (moduleName.hashCode) +
    (testDate.hashCode) +
    (maxMarks.hashCode) +
    (marks == null ? 0 : marks!.hashCode) +
    (absent.hashCode) +
    (pct == null ? 0 : pct!.hashCode);

  @override
  String toString() => 'TestScoresTestsInner[testId=$testId, courseId=$courseId, moduleName=$moduleName, testDate=$testDate, maxMarks=$maxMarks, marks=$marks, absent=$absent, pct=$pct]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'test_id'] = this.testId;
      json[r'course_id'] = this.courseId;
      json[r'module_name'] = this.moduleName;
      json[r'test_date'] = _dateFormatter.format(this.testDate);
      json[r'max_marks'] = this.maxMarks;
    if (this.marks != null) {
      json[r'marks'] = this.marks;
    } else {
      json[r'marks'] = null;
    }
      json[r'absent'] = this.absent;
    if (this.pct != null) {
      json[r'pct'] = this.pct;
    } else {
      json[r'pct'] = null;
    }
    return json;
  }

  /// Returns a new [TestScoresTestsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TestScoresTestsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'test_id'), 'Required key "TestScoresTestsInner[test_id]" is missing from JSON.');
        assert(json[r'test_id'] != null, 'Required key "TestScoresTestsInner[test_id]" has a null value in JSON.');
        assert(json.containsKey(r'course_id'), 'Required key "TestScoresTestsInner[course_id]" is missing from JSON.');
        assert(json[r'course_id'] != null, 'Required key "TestScoresTestsInner[course_id]" has a null value in JSON.');
        assert(json.containsKey(r'module_name'), 'Required key "TestScoresTestsInner[module_name]" is missing from JSON.');
        assert(json[r'module_name'] != null, 'Required key "TestScoresTestsInner[module_name]" has a null value in JSON.');
        assert(json.containsKey(r'test_date'), 'Required key "TestScoresTestsInner[test_date]" is missing from JSON.');
        assert(json[r'test_date'] != null, 'Required key "TestScoresTestsInner[test_date]" has a null value in JSON.');
        assert(json.containsKey(r'max_marks'), 'Required key "TestScoresTestsInner[max_marks]" is missing from JSON.');
        assert(json[r'max_marks'] != null, 'Required key "TestScoresTestsInner[max_marks]" has a null value in JSON.');
        assert(json.containsKey(r'marks'), 'Required key "TestScoresTestsInner[marks]" is missing from JSON.');
        assert(json.containsKey(r'absent'), 'Required key "TestScoresTestsInner[absent]" is missing from JSON.');
        assert(json[r'absent'] != null, 'Required key "TestScoresTestsInner[absent]" has a null value in JSON.');
        assert(json.containsKey(r'pct'), 'Required key "TestScoresTestsInner[pct]" is missing from JSON.');
        return true;
      }());

      return TestScoresTestsInner(
        testId: mapValueOfType<String>(json, r'test_id')!,
        courseId: mapValueOfType<String>(json, r'course_id')!,
        moduleName: mapValueOfType<String>(json, r'module_name')!,
        testDate: mapDateTime(json, r'test_date', r'')!,
        maxMarks: num.parse('${json[r'max_marks']}'),
        marks: json[r'marks'] == null
            ? null
            : num.parse('${json[r'marks']}'),
        absent: mapValueOfType<bool>(json, r'absent')!,
        pct: json[r'pct'] == null
            ? null
            : num.parse('${json[r'pct']}'),
      );
    }
    return null;
  }

  static List<TestScoresTestsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TestScoresTestsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TestScoresTestsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TestScoresTestsInner> mapFromJson(dynamic json) {
    final map = <String, TestScoresTestsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TestScoresTestsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TestScoresTestsInner-objects as value to a dart map
  static Map<String, List<TestScoresTestsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TestScoresTestsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TestScoresTestsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'test_id',
    'course_id',
    'module_name',
    'test_date',
    'max_marks',
    'marks',
    'absent',
    'pct',
  };
}

