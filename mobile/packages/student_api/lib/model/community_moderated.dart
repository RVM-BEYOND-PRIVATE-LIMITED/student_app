//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CommunityModerated {
  /// Returns a new [CommunityModerated] instance.
  CommunityModerated({
    required this.id,
    required this.hidden,
  });

  String id;

  bool hidden;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CommunityModerated &&
    other.id == id &&
    other.hidden == hidden;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (hidden.hashCode);

  @override
  String toString() => 'CommunityModerated[id=$id, hidden=$hidden]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'hidden'] = this.hidden;
    return json;
  }

  /// Returns a new [CommunityModerated] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CommunityModerated? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "CommunityModerated[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "CommunityModerated[id]" has a null value in JSON.');
        assert(json.containsKey(r'hidden'), 'Required key "CommunityModerated[hidden]" is missing from JSON.');
        assert(json[r'hidden'] != null, 'Required key "CommunityModerated[hidden]" has a null value in JSON.');
        return true;
      }());

      return CommunityModerated(
        id: mapValueOfType<String>(json, r'id')!,
        hidden: mapValueOfType<bool>(json, r'hidden')!,
      );
    }
    return null;
  }

  static List<CommunityModerated> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CommunityModerated>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CommunityModerated.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CommunityModerated> mapFromJson(dynamic json) {
    final map = <String, CommunityModerated>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CommunityModerated.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CommunityModerated-objects as value to a dart map
  static Map<String, List<CommunityModerated>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CommunityModerated>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CommunityModerated.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'hidden',
  };
}

