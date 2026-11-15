//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PracticeSlotBranch {
  /// Returns a new [PracticeSlotBranch] instance.
  PracticeSlotBranch({
    required this.id,
    required this.name,
    required this.callNumber,
  });

  int id;

  String name;

  String? callNumber;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PracticeSlotBranch &&
    other.id == id &&
    other.name == name &&
    other.callNumber == callNumber;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (callNumber == null ? 0 : callNumber!.hashCode);

  @override
  String toString() => 'PracticeSlotBranch[id=$id, name=$name, callNumber=$callNumber]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
    if (this.callNumber != null) {
      json[r'call_number'] = this.callNumber;
    } else {
      json[r'call_number'] = null;
    }
    return json;
  }

  /// Returns a new [PracticeSlotBranch] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PracticeSlotBranch? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "PracticeSlotBranch[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "PracticeSlotBranch[id]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "PracticeSlotBranch[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "PracticeSlotBranch[name]" has a null value in JSON.');
        assert(json.containsKey(r'call_number'), 'Required key "PracticeSlotBranch[call_number]" is missing from JSON.');
        return true;
      }());

      return PracticeSlotBranch(
        id: mapValueOfType<int>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        callNumber: mapValueOfType<String>(json, r'call_number'),
      );
    }
    return null;
  }

  static List<PracticeSlotBranch> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PracticeSlotBranch>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PracticeSlotBranch.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PracticeSlotBranch> mapFromJson(dynamic json) {
    final map = <String, PracticeSlotBranch>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PracticeSlotBranch.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PracticeSlotBranch-objects as value to a dart map
  static Map<String, List<PracticeSlotBranch>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PracticeSlotBranch>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PracticeSlotBranch.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'call_number',
  };
}

