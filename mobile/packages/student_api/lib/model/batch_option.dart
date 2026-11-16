//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class BatchOption {
  /// Returns a new [BatchOption] instance.
  BatchOption({
    required this.batchId,
    required this.course,
    required this.startDate,
    required this.endDate,
    this.daysOfWeek = const [],
    required this.startTime,
    required this.endTime,
  });

  String batchId;

  BatchOptionCourse course;

  DateTime startDate;

  DateTime? endDate;

  List<String> daysOfWeek;

  String? startTime;

  String? endTime;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BatchOption &&
    other.batchId == batchId &&
    other.course == course &&
    other.startDate == startDate &&
    other.endDate == endDate &&
    _deepEquality.equals(other.daysOfWeek, daysOfWeek) &&
    other.startTime == startTime &&
    other.endTime == endTime;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (batchId.hashCode) +
    (course.hashCode) +
    (startDate.hashCode) +
    (endDate == null ? 0 : endDate!.hashCode) +
    (daysOfWeek.hashCode) +
    (startTime == null ? 0 : startTime!.hashCode) +
    (endTime == null ? 0 : endTime!.hashCode);

  @override
  String toString() => 'BatchOption[batchId=$batchId, course=$course, startDate=$startDate, endDate=$endDate, daysOfWeek=$daysOfWeek, startTime=$startTime, endTime=$endTime]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'batch_id'] = this.batchId;
      json[r'course'] = this.course;
      json[r'start_date'] = _dateFormatter.format(this.startDate);
    if (this.endDate != null) {
      json[r'end_date'] = _dateFormatter.format(this.endDate!);
    } else {
      json[r'end_date'] = null;
    }
      json[r'days_of_week'] = this.daysOfWeek;
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

  /// Returns a new [BatchOption] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BatchOption? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'batch_id'), 'Required key "BatchOption[batch_id]" is missing from JSON.');
        assert(json[r'batch_id'] != null, 'Required key "BatchOption[batch_id]" has a null value in JSON.');
        assert(json.containsKey(r'course'), 'Required key "BatchOption[course]" is missing from JSON.');
        assert(json[r'course'] != null, 'Required key "BatchOption[course]" has a null value in JSON.');
        assert(json.containsKey(r'start_date'), 'Required key "BatchOption[start_date]" is missing from JSON.');
        assert(json[r'start_date'] != null, 'Required key "BatchOption[start_date]" has a null value in JSON.');
        assert(json.containsKey(r'end_date'), 'Required key "BatchOption[end_date]" is missing from JSON.');
        assert(json.containsKey(r'days_of_week'), 'Required key "BatchOption[days_of_week]" is missing from JSON.');
        assert(json[r'days_of_week'] != null, 'Required key "BatchOption[days_of_week]" has a null value in JSON.');
        assert(json.containsKey(r'start_time'), 'Required key "BatchOption[start_time]" is missing from JSON.');
        assert(json.containsKey(r'end_time'), 'Required key "BatchOption[end_time]" is missing from JSON.');
        return true;
      }());

      return BatchOption(
        batchId: mapValueOfType<String>(json, r'batch_id')!,
        course: BatchOptionCourse.fromJson(json[r'course'])!,
        startDate: mapDateTime(json, r'start_date', r'')!,
        endDate: mapDateTime(json, r'end_date', r''),
        daysOfWeek: json[r'days_of_week'] is Iterable
            ? (json[r'days_of_week'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        startTime: mapValueOfType<String>(json, r'start_time'),
        endTime: mapValueOfType<String>(json, r'end_time'),
      );
    }
    return null;
  }

  static List<BatchOption> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BatchOption>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BatchOption.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BatchOption> mapFromJson(dynamic json) {
    final map = <String, BatchOption>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BatchOption.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BatchOption-objects as value to a dart map
  static Map<String, List<BatchOption>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BatchOption>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BatchOption.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'batch_id',
    'course',
    'start_date',
    'end_date',
    'days_of_week',
    'start_time',
    'end_time',
  };
}

