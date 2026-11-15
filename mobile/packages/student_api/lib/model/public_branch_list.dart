//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicBranchList {
  /// Returns a new [PublicBranchList] instance.
  PublicBranchList({
    this.branches = const [],
  });

  List<AdmissionBranch> branches;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicBranchList &&
    _deepEquality.equals(other.branches, branches);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (branches.hashCode);

  @override
  String toString() => 'PublicBranchList[branches=$branches]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'branches'] = this.branches;
    return json;
  }

  /// Returns a new [PublicBranchList] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicBranchList? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'branches'), 'Required key "PublicBranchList[branches]" is missing from JSON.');
        assert(json[r'branches'] != null, 'Required key "PublicBranchList[branches]" has a null value in JSON.');
        return true;
      }());

      return PublicBranchList(
        branches: AdmissionBranch.listFromJson(json[r'branches']),
      );
    }
    return null;
  }

  static List<PublicBranchList> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicBranchList>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicBranchList.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicBranchList> mapFromJson(dynamic json) {
    final map = <String, PublicBranchList>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicBranchList.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicBranchList-objects as value to a dart map
  static Map<String, List<PublicBranchList>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicBranchList>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicBranchList.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'branches',
  };
}

