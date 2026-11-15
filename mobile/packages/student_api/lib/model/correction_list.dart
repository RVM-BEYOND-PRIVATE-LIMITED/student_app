//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CorrectionList {
  /// Returns a new [CorrectionList] instance.
  CorrectionList({
    this.requests = const [],
  });

  List<Correction> requests;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CorrectionList &&
    _deepEquality.equals(other.requests, requests);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (requests.hashCode);

  @override
  String toString() => 'CorrectionList[requests=$requests]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'requests'] = this.requests;
    return json;
  }

  /// Returns a new [CorrectionList] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CorrectionList? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'requests'), 'Required key "CorrectionList[requests]" is missing from JSON.');
        assert(json[r'requests'] != null, 'Required key "CorrectionList[requests]" has a null value in JSON.');
        return true;
      }());

      return CorrectionList(
        requests: Correction.listFromJson(json[r'requests']),
      );
    }
    return null;
  }

  static List<CorrectionList> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CorrectionList>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CorrectionList.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CorrectionList> mapFromJson(dynamic json) {
    final map = <String, CorrectionList>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CorrectionList.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CorrectionList-objects as value to a dart map
  static Map<String, List<CorrectionList>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CorrectionList>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CorrectionList.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'requests',
  };
}

