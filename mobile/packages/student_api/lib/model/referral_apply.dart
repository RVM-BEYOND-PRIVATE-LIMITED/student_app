//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReferralApply {
  /// Returns a new [ReferralApply] instance.
  ReferralApply({
    required this.code,
  });

  String code;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReferralApply &&
    other.code == code;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (code.hashCode);

  @override
  String toString() => 'ReferralApply[code=$code]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'code'] = this.code;
    return json;
  }

  /// Returns a new [ReferralApply] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReferralApply? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'code'), 'Required key "ReferralApply[code]" is missing from JSON.');
        assert(json[r'code'] != null, 'Required key "ReferralApply[code]" has a null value in JSON.');
        return true;
      }());

      return ReferralApply(
        code: mapValueOfType<String>(json, r'code')!,
      );
    }
    return null;
  }

  static List<ReferralApply> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReferralApply>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReferralApply.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReferralApply> mapFromJson(dynamic json) {
    final map = <String, ReferralApply>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReferralApply.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReferralApply-objects as value to a dart map
  static Map<String, List<ReferralApply>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReferralApply>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReferralApply.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'code',
  };
}

