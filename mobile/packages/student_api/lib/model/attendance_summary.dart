//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AttendanceSummary {
  /// Returns a new [AttendanceSummary] instance.
  AttendanceSummary({
    this.batchId,
    required this.present,
    required this.marked,
    required this.percent,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? batchId;

  /// Minimum value: 0
  int present;

  /// Minimum value: 0
  int marked;

  num? percent;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AttendanceSummary &&
    other.batchId == batchId &&
    other.present == present &&
    other.marked == marked &&
    other.percent == percent;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (batchId == null ? 0 : batchId!.hashCode) +
    (present.hashCode) +
    (marked.hashCode) +
    (percent == null ? 0 : percent!.hashCode);

  @override
  String toString() => 'AttendanceSummary[batchId=$batchId, present=$present, marked=$marked, percent=$percent]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.batchId != null) {
      json[r'batch_id'] = this.batchId;
    } else {
      json[r'batch_id'] = null;
    }
      json[r'present'] = this.present;
      json[r'marked'] = this.marked;
    if (this.percent != null) {
      json[r'percent'] = this.percent;
    } else {
      json[r'percent'] = null;
    }
    return json;
  }

  /// Returns a new [AttendanceSummary] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AttendanceSummary? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'present'), 'Required key "AttendanceSummary[present]" is missing from JSON.');
        assert(json[r'present'] != null, 'Required key "AttendanceSummary[present]" has a null value in JSON.');
        assert(json.containsKey(r'marked'), 'Required key "AttendanceSummary[marked]" is missing from JSON.');
        assert(json[r'marked'] != null, 'Required key "AttendanceSummary[marked]" has a null value in JSON.');
        assert(json.containsKey(r'percent'), 'Required key "AttendanceSummary[percent]" is missing from JSON.');
        return true;
      }());

      return AttendanceSummary(
        batchId: mapValueOfType<String>(json, r'batch_id'),
        present: mapValueOfType<int>(json, r'present')!,
        marked: mapValueOfType<int>(json, r'marked')!,
        percent: json[r'percent'] == null
            ? null
            : num.parse('${json[r'percent']}'),
      );
    }
    return null;
  }

  static List<AttendanceSummary> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AttendanceSummary>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AttendanceSummary.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AttendanceSummary> mapFromJson(dynamic json) {
    final map = <String, AttendanceSummary>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AttendanceSummary.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AttendanceSummary-objects as value to a dart map
  static Map<String, List<AttendanceSummary>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AttendanceSummary>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AttendanceSummary.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'present',
    'marked',
    'percent',
  };
}

