//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class InterviewPacksRolesInner {
  /// Returns a new [InterviewPacksRolesInner] instance.
  InterviewPacksRolesInner({
    required this.id,
    required this.name,
    this.packs = const [],
  });

  String id;

  String name;

  List<InterviewPacksRolesInnerPacksInner> packs;

  @override
  bool operator ==(Object other) => identical(this, other) || other is InterviewPacksRolesInner &&
    other.id == id &&
    other.name == name &&
    _deepEquality.equals(other.packs, packs);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (packs.hashCode);

  @override
  String toString() => 'InterviewPacksRolesInner[id=$id, name=$name, packs=$packs]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'packs'] = this.packs;
    return json;
  }

  /// Returns a new [InterviewPacksRolesInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static InterviewPacksRolesInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "InterviewPacksRolesInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "InterviewPacksRolesInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "InterviewPacksRolesInner[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "InterviewPacksRolesInner[name]" has a null value in JSON.');
        assert(json.containsKey(r'packs'), 'Required key "InterviewPacksRolesInner[packs]" is missing from JSON.');
        assert(json[r'packs'] != null, 'Required key "InterviewPacksRolesInner[packs]" has a null value in JSON.');
        return true;
      }());

      return InterviewPacksRolesInner(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        packs: InterviewPacksRolesInnerPacksInner.listFromJson(json[r'packs']),
      );
    }
    return null;
  }

  static List<InterviewPacksRolesInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <InterviewPacksRolesInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = InterviewPacksRolesInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, InterviewPacksRolesInner> mapFromJson(dynamic json) {
    final map = <String, InterviewPacksRolesInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = InterviewPacksRolesInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of InterviewPacksRolesInner-objects as value to a dart map
  static Map<String, List<InterviewPacksRolesInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<InterviewPacksRolesInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = InterviewPacksRolesInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'packs',
  };
}

