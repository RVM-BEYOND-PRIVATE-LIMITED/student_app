//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class InterviewPacks {
  /// Returns a new [InterviewPacks] instance.
  InterviewPacks({
    this.roles = const [],
  });

  List<InterviewPacksRolesInner> roles;

  @override
  bool operator ==(Object other) => identical(this, other) || other is InterviewPacks &&
    _deepEquality.equals(other.roles, roles);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (roles.hashCode);

  @override
  String toString() => 'InterviewPacks[roles=$roles]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'roles'] = this.roles;
    return json;
  }

  /// Returns a new [InterviewPacks] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static InterviewPacks? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'roles'), 'Required key "InterviewPacks[roles]" is missing from JSON.');
        assert(json[r'roles'] != null, 'Required key "InterviewPacks[roles]" has a null value in JSON.');
        return true;
      }());

      return InterviewPacks(
        roles: InterviewPacksRolesInner.listFromJson(json[r'roles']),
      );
    }
    return null;
  }

  static List<InterviewPacks> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <InterviewPacks>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = InterviewPacks.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, InterviewPacks> mapFromJson(dynamic json) {
    final map = <String, InterviewPacks>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = InterviewPacks.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of InterviewPacks-objects as value to a dart map
  static Map<String, List<InterviewPacks>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<InterviewPacks>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = InterviewPacks.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'roles',
  };
}

