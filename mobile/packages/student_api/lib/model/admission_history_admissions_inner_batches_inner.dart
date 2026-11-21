//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdmissionHistoryAdmissionsInnerBatchesInner {
  /// Returns a new [AdmissionHistoryAdmissionsInnerBatchesInner] instance.
  AdmissionHistoryAdmissionsInnerBatchesInner({
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  String name;

  DateTime? startDate;

  DateTime? endDate;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdmissionHistoryAdmissionsInnerBatchesInner &&
    other.name == name &&
    other.startDate == startDate &&
    other.endDate == endDate;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (startDate == null ? 0 : startDate!.hashCode) +
    (endDate == null ? 0 : endDate!.hashCode);

  @override
  String toString() => 'AdmissionHistoryAdmissionsInnerBatchesInner[name=$name, startDate=$startDate, endDate=$endDate]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
    if (this.startDate != null) {
      json[r'start_date'] = _dateFormatter.format(this.startDate!);
    } else {
      json[r'start_date'] = null;
    }
    if (this.endDate != null) {
      json[r'end_date'] = _dateFormatter.format(this.endDate!);
    } else {
      json[r'end_date'] = null;
    }
    return json;
  }

  /// Returns a new [AdmissionHistoryAdmissionsInnerBatchesInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdmissionHistoryAdmissionsInnerBatchesInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'name'), 'Required key "AdmissionHistoryAdmissionsInnerBatchesInner[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "AdmissionHistoryAdmissionsInnerBatchesInner[name]" has a null value in JSON.');
        assert(json.containsKey(r'start_date'), 'Required key "AdmissionHistoryAdmissionsInnerBatchesInner[start_date]" is missing from JSON.');
        assert(json.containsKey(r'end_date'), 'Required key "AdmissionHistoryAdmissionsInnerBatchesInner[end_date]" is missing from JSON.');
        return true;
      }());

      return AdmissionHistoryAdmissionsInnerBatchesInner(
        name: mapValueOfType<String>(json, r'name')!,
        startDate: mapDateTime(json, r'start_date', r''),
        endDate: mapDateTime(json, r'end_date', r''),
      );
    }
    return null;
  }

  static List<AdmissionHistoryAdmissionsInnerBatchesInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdmissionHistoryAdmissionsInnerBatchesInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdmissionHistoryAdmissionsInnerBatchesInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdmissionHistoryAdmissionsInnerBatchesInner> mapFromJson(dynamic json) {
    final map = <String, AdmissionHistoryAdmissionsInnerBatchesInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdmissionHistoryAdmissionsInnerBatchesInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdmissionHistoryAdmissionsInnerBatchesInner-objects as value to a dart map
  static Map<String, List<AdmissionHistoryAdmissionsInnerBatchesInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdmissionHistoryAdmissionsInnerBatchesInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdmissionHistoryAdmissionsInnerBatchesInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'start_date',
    'end_date',
  };
}

