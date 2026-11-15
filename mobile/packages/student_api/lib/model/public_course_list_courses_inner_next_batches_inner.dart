//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicCourseListCoursesInnerNextBatchesInner {
  /// Returns a new [PublicCourseListCoursesInnerNextBatchesInner] instance.
  PublicCourseListCoursesInnerNextBatchesInner({
    required this.branchId,
    required this.branch,
    required this.startDate,
    this.days = const [],
    required this.startTime,
    required this.endTime,
  });

  int branchId;

  String? branch;

  DateTime startDate;

  List<int> days;

  String? startTime;

  String? endTime;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicCourseListCoursesInnerNextBatchesInner &&
    other.branchId == branchId &&
    other.branch == branch &&
    other.startDate == startDate &&
    _deepEquality.equals(other.days, days) &&
    other.startTime == startTime &&
    other.endTime == endTime;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (branchId.hashCode) +
    (branch == null ? 0 : branch!.hashCode) +
    (startDate.hashCode) +
    (days.hashCode) +
    (startTime == null ? 0 : startTime!.hashCode) +
    (endTime == null ? 0 : endTime!.hashCode);

  @override
  String toString() => 'PublicCourseListCoursesInnerNextBatchesInner[branchId=$branchId, branch=$branch, startDate=$startDate, days=$days, startTime=$startTime, endTime=$endTime]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'branch_id'] = this.branchId;
    if (this.branch != null) {
      json[r'branch'] = this.branch;
    } else {
      json[r'branch'] = null;
    }
      json[r'start_date'] = _dateFormatter.format(this.startDate);
      json[r'days'] = this.days;
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
    return json;
  }

  /// Returns a new [PublicCourseListCoursesInnerNextBatchesInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicCourseListCoursesInnerNextBatchesInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'branch_id'), 'Required key "PublicCourseListCoursesInnerNextBatchesInner[branch_id]" is missing from JSON.');
        assert(json[r'branch_id'] != null, 'Required key "PublicCourseListCoursesInnerNextBatchesInner[branch_id]" has a null value in JSON.');
        assert(json.containsKey(r'branch'), 'Required key "PublicCourseListCoursesInnerNextBatchesInner[branch]" is missing from JSON.');
        assert(json.containsKey(r'start_date'), 'Required key "PublicCourseListCoursesInnerNextBatchesInner[start_date]" is missing from JSON.');
        assert(json[r'start_date'] != null, 'Required key "PublicCourseListCoursesInnerNextBatchesInner[start_date]" has a null value in JSON.');
        assert(json.containsKey(r'days'), 'Required key "PublicCourseListCoursesInnerNextBatchesInner[days]" is missing from JSON.');
        assert(json[r'days'] != null, 'Required key "PublicCourseListCoursesInnerNextBatchesInner[days]" has a null value in JSON.');
        assert(json.containsKey(r'start_time'), 'Required key "PublicCourseListCoursesInnerNextBatchesInner[start_time]" is missing from JSON.');
        assert(json.containsKey(r'end_time'), 'Required key "PublicCourseListCoursesInnerNextBatchesInner[end_time]" is missing from JSON.');
        return true;
      }());

      return PublicCourseListCoursesInnerNextBatchesInner(
        branchId: mapValueOfType<int>(json, r'branch_id')!,
        branch: mapValueOfType<String>(json, r'branch'),
        startDate: mapDateTime(json, r'start_date', r'')!,
        days: json[r'days'] is Iterable
            ? (json[r'days'] as Iterable).cast<int>().toList(growable: false)
            : const [],
        startTime: mapValueOfType<String>(json, r'start_time'),
        endTime: mapValueOfType<String>(json, r'end_time'),
      );
    }
    return null;
  }

  static List<PublicCourseListCoursesInnerNextBatchesInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicCourseListCoursesInnerNextBatchesInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicCourseListCoursesInnerNextBatchesInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicCourseListCoursesInnerNextBatchesInner> mapFromJson(dynamic json) {
    final map = <String, PublicCourseListCoursesInnerNextBatchesInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicCourseListCoursesInnerNextBatchesInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicCourseListCoursesInnerNextBatchesInner-objects as value to a dart map
  static Map<String, List<PublicCourseListCoursesInnerNextBatchesInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicCourseListCoursesInnerNextBatchesInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicCourseListCoursesInnerNextBatchesInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'branch_id',
    'branch',
    'start_date',
    'days',
    'start_time',
    'end_time',
  };
}

