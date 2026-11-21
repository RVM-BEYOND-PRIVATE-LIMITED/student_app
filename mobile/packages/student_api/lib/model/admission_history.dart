//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdmissionHistory {
  /// Returns a new [AdmissionHistory] instance.
  AdmissionHistory({
    this.admissions = const [],
  });

  List<AdmissionHistoryAdmissionsInner> admissions;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdmissionHistory &&
    _deepEquality.equals(other.admissions, admissions);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (admissions.hashCode);

  @override
  String toString() => 'AdmissionHistory[admissions=$admissions]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'admissions'] = this.admissions;
    return json;
  }

  /// Returns a new [AdmissionHistory] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdmissionHistory? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'admissions'), 'Required key "AdmissionHistory[admissions]" is missing from JSON.');
        assert(json[r'admissions'] != null, 'Required key "AdmissionHistory[admissions]" has a null value in JSON.');
        return true;
      }());

      return AdmissionHistory(
        admissions: AdmissionHistoryAdmissionsInner.listFromJson(json[r'admissions']),
      );
    }
    return null;
  }

  static List<AdmissionHistory> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdmissionHistory>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdmissionHistory.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdmissionHistory> mapFromJson(dynamic json) {
    final map = <String, AdmissionHistory>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdmissionHistory.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdmissionHistory-objects as value to a dart map
  static Map<String, List<AdmissionHistory>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdmissionHistory>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdmissionHistory.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'admissions',
  };
}

