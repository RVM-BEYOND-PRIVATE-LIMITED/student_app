//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ConsentChoiceTextVersions {
  /// Returns a new [ConsentChoiceTextVersions] instance.
  ConsentChoiceTextVersions({
    required this.shareProfile,
    required this.marketingStory,
  });

  /// Minimum value: 1
  int shareProfile;

  /// Minimum value: 1
  int marketingStory;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConsentChoiceTextVersions &&
    other.shareProfile == shareProfile &&
    other.marketingStory == marketingStory;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (shareProfile.hashCode) +
    (marketingStory.hashCode);

  @override
  String toString() => 'ConsentChoiceTextVersions[shareProfile=$shareProfile, marketingStory=$marketingStory]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'share_profile'] = this.shareProfile;
      json[r'marketing_story'] = this.marketingStory;
    return json;
  }

  /// Returns a new [ConsentChoiceTextVersions] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConsentChoiceTextVersions? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'share_profile'), 'Required key "ConsentChoiceTextVersions[share_profile]" is missing from JSON.');
        assert(json[r'share_profile'] != null, 'Required key "ConsentChoiceTextVersions[share_profile]" has a null value in JSON.');
        assert(json.containsKey(r'marketing_story'), 'Required key "ConsentChoiceTextVersions[marketing_story]" is missing from JSON.');
        assert(json[r'marketing_story'] != null, 'Required key "ConsentChoiceTextVersions[marketing_story]" has a null value in JSON.');
        return true;
      }());

      return ConsentChoiceTextVersions(
        shareProfile: mapValueOfType<int>(json, r'share_profile')!,
        marketingStory: mapValueOfType<int>(json, r'marketing_story')!,
      );
    }
    return null;
  }

  static List<ConsentChoiceTextVersions> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConsentChoiceTextVersions>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConsentChoiceTextVersions.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConsentChoiceTextVersions> mapFromJson(dynamic json) {
    final map = <String, ConsentChoiceTextVersions>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConsentChoiceTextVersions.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConsentChoiceTextVersions-objects as value to a dart map
  static Map<String, List<ConsentChoiceTextVersions>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConsentChoiceTextVersions>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConsentChoiceTextVersions.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'share_profile',
    'marketing_story',
  };
}

