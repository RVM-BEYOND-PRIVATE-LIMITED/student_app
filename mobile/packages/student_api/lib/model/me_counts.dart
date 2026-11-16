//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MeCounts {
  /// Returns a new [MeCounts] instance.
  MeCounts({
    required this.placementPrompts,
    required this.consentRequests,
  });

  /// Minimum value: 0
  int placementPrompts;

  /// Minimum value: 0
  int consentRequests;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MeCounts &&
    other.placementPrompts == placementPrompts &&
    other.consentRequests == consentRequests;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (placementPrompts.hashCode) +
    (consentRequests.hashCode);

  @override
  String toString() => 'MeCounts[placementPrompts=$placementPrompts, consentRequests=$consentRequests]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'placement_prompts'] = this.placementPrompts;
      json[r'consent_requests'] = this.consentRequests;
    return json;
  }

  /// Returns a new [MeCounts] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MeCounts? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'placement_prompts'), 'Required key "MeCounts[placement_prompts]" is missing from JSON.');
        assert(json[r'placement_prompts'] != null, 'Required key "MeCounts[placement_prompts]" has a null value in JSON.');
        assert(json.containsKey(r'consent_requests'), 'Required key "MeCounts[consent_requests]" is missing from JSON.');
        assert(json[r'consent_requests'] != null, 'Required key "MeCounts[consent_requests]" has a null value in JSON.');
        return true;
      }());

      return MeCounts(
        placementPrompts: mapValueOfType<int>(json, r'placement_prompts')!,
        consentRequests: mapValueOfType<int>(json, r'consent_requests')!,
      );
    }
    return null;
  }

  static List<MeCounts> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MeCounts>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MeCounts.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MeCounts> mapFromJson(dynamic json) {
    final map = <String, MeCounts>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MeCounts.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MeCounts-objects as value to a dart map
  static Map<String, List<MeCounts>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MeCounts>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MeCounts.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'placement_prompts',
    'consent_requests',
  };
}

