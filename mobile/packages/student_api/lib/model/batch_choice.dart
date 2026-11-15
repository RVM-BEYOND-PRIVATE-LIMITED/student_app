//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class BatchChoice {
  /// Returns a new [BatchChoice] instance.
  BatchChoice({
    required this.batchId,
    required this.courseId,
  });

  String batchId;

  String courseId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BatchChoice &&
    other.batchId == batchId &&
    other.courseId == courseId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (batchId.hashCode) +
    (courseId.hashCode);

  @override
  String toString() => 'BatchChoice[batchId=$batchId, courseId=$courseId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'batch_id'] = this.batchId;
      json[r'course_id'] = this.courseId;
    return json;
  }

  /// Returns a new [BatchChoice] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BatchChoice? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'batch_id'), 'Required key "BatchChoice[batch_id]" is missing from JSON.');
        assert(json[r'batch_id'] != null, 'Required key "BatchChoice[batch_id]" has a null value in JSON.');
        assert(json.containsKey(r'course_id'), 'Required key "BatchChoice[course_id]" is missing from JSON.');
        assert(json[r'course_id'] != null, 'Required key "BatchChoice[course_id]" has a null value in JSON.');
        return true;
      }());

      return BatchChoice(
        batchId: mapValueOfType<String>(json, r'batch_id')!,
        courseId: mapValueOfType<String>(json, r'course_id')!,
      );
    }
    return null;
  }

  static List<BatchChoice> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BatchChoice>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BatchChoice.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BatchChoice> mapFromJson(dynamic json) {
    final map = <String, BatchChoice>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BatchChoice.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BatchChoice-objects as value to a dart map
  static Map<String, List<BatchChoice>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BatchChoice>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BatchChoice.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'batch_id',
    'course_id',
  };
}

