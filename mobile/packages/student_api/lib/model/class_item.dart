//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ClassItem {
  /// Returns a new [ClassItem] instance.
  ClassItem({
    required this.date,
    required this.batchId,
    required this.startTime,
    required this.endTime,
    required this.facultyName,
    this.courses = const [],
  });

  DateTime date;

  String batchId;

  String? startTime;

  String? endTime;

  String? facultyName;

  List<String> courses;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ClassItem &&
    other.date == date &&
    other.batchId == batchId &&
    other.startTime == startTime &&
    other.endTime == endTime &&
    other.facultyName == facultyName &&
    _deepEquality.equals(other.courses, courses);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (date.hashCode) +
    (batchId.hashCode) +
    (startTime == null ? 0 : startTime!.hashCode) +
    (endTime == null ? 0 : endTime!.hashCode) +
    (facultyName == null ? 0 : facultyName!.hashCode) +
    (courses.hashCode);

  @override
  String toString() => 'ClassItem[date=$date, batchId=$batchId, startTime=$startTime, endTime=$endTime, facultyName=$facultyName, courses=$courses]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'date'] = _dateFormatter.format(this.date);
      json[r'batch_id'] = this.batchId;
    if (this.startTime != null) {
      json[r'start_time'] = this.startTime;
    } else {
      json[r'start_time'] = null;
    }
    if (this.endTime != null) {
      json[r'end_time'] = this.endTime;
    } else {
      json[r'end_time'] = null;
    }
    if (this.facultyName != null) {
      json[r'faculty_name'] = this.facultyName;
    } else {
      json[r'faculty_name'] = null;
    }
      json[r'courses'] = this.courses;
    return json;
  }

  /// Returns a new [ClassItem] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ClassItem? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'date'), 'Required key "ClassItem[date]" is missing from JSON.');
        assert(json[r'date'] != null, 'Required key "ClassItem[date]" has a null value in JSON.');
        assert(json.containsKey(r'batch_id'), 'Required key "ClassItem[batch_id]" is missing from JSON.');
        assert(json[r'batch_id'] != null, 'Required key "ClassItem[batch_id]" has a null value in JSON.');
        assert(json.containsKey(r'start_time'), 'Required key "ClassItem[start_time]" is missing from JSON.');
        assert(json.containsKey(r'end_time'), 'Required key "ClassItem[end_time]" is missing from JSON.');
        assert(json.containsKey(r'faculty_name'), 'Required key "ClassItem[faculty_name]" is missing from JSON.');
        assert(json.containsKey(r'courses'), 'Required key "ClassItem[courses]" is missing from JSON.');
        assert(json[r'courses'] != null, 'Required key "ClassItem[courses]" has a null value in JSON.');
        return true;
      }());

      return ClassItem(
        date: mapDateTime(json, r'date', r'')!,
        batchId: mapValueOfType<String>(json, r'batch_id')!,
        startTime: mapValueOfType<String>(json, r'start_time'),
        endTime: mapValueOfType<String>(json, r'end_time'),
        facultyName: mapValueOfType<String>(json, r'faculty_name'),
        courses: json[r'courses'] is Iterable
            ? (json[r'courses'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<ClassItem> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ClassItem>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ClassItem.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ClassItem> mapFromJson(dynamic json) {
    final map = <String, ClassItem>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ClassItem.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ClassItem-objects as value to a dart map
  static Map<String, List<ClassItem>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ClassItem>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ClassItem.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'date',
    'batch_id',
    'start_time',
    'end_time',
    'faculty_name',
    'courses',
  };
}

