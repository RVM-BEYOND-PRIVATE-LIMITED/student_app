//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PlacementProofList {
  /// Returns a new [PlacementProofList] instance.
  PlacementProofList({
    this.proofs = const [],
  });

  List<PlacementProofListProofsInner> proofs;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PlacementProofList &&
    _deepEquality.equals(other.proofs, proofs);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (proofs.hashCode);

  @override
  String toString() => 'PlacementProofList[proofs=$proofs]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'proofs'] = this.proofs;
    return json;
  }

  /// Returns a new [PlacementProofList] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PlacementProofList? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'proofs'), 'Required key "PlacementProofList[proofs]" is missing from JSON.');
        assert(json[r'proofs'] != null, 'Required key "PlacementProofList[proofs]" has a null value in JSON.');
        return true;
      }());

      return PlacementProofList(
        proofs: PlacementProofListProofsInner.listFromJson(json[r'proofs']),
      );
    }
    return null;
  }

  static List<PlacementProofList> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PlacementProofList>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PlacementProofList.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PlacementProofList> mapFromJson(dynamic json) {
    final map = <String, PlacementProofList>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PlacementProofList.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PlacementProofList-objects as value to a dart map
  static Map<String, List<PlacementProofList>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PlacementProofList>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PlacementProofList.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'proofs',
  };
}

