//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ConsentChoice {
  /// Returns a new [ConsentChoice] instance.
  ConsentChoice({
    required this.shareProfile,
    required this.marketingStory,
    required this.textVersions,
  });

  bool shareProfile;

  bool marketingStory;

  ConsentChoiceTextVersions textVersions;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConsentChoice &&
    other.shareProfile == shareProfile &&
    other.marketingStory == marketingStory &&
    other.textVersions == textVersions;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (shareProfile.hashCode) +
    (marketingStory.hashCode) +
    (textVersions.hashCode);

  @override
  String toString() => 'ConsentChoice[shareProfile=$shareProfile, marketingStory=$marketingStory, textVersions=$textVersions]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'share_profile'] = this.shareProfile;
      json[r'marketing_story'] = this.marketingStory;
      json[r'text_versions'] = this.textVersions;
    return json;
  }

  /// Returns a new [ConsentChoice] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConsentChoice? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'share_profile'), 'Required key "ConsentChoice[share_profile]" is missing from JSON.');
        assert(json[r'share_profile'] != null, 'Required key "ConsentChoice[share_profile]" has a null value in JSON.');
        assert(json.containsKey(r'marketing_story'), 'Required key "ConsentChoice[marketing_story]" is missing from JSON.');
        assert(json[r'marketing_story'] != null, 'Required key "ConsentChoice[marketing_story]" has a null value in JSON.');
        assert(json.containsKey(r'text_versions'), 'Required key "ConsentChoice[text_versions]" is missing from JSON.');
        assert(json[r'text_versions'] != null, 'Required key "ConsentChoice[text_versions]" has a null value in JSON.');
        return true;
      }());

      return ConsentChoice(
        shareProfile: mapValueOfType<bool>(json, r'share_profile')!,
        marketingStory: mapValueOfType<bool>(json, r'marketing_story')!,
        textVersions: ConsentChoiceTextVersions.fromJson(json[r'text_versions'])!,
      );
    }
    return null;
  }

  static List<ConsentChoice> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConsentChoice>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConsentChoice.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConsentChoice> mapFromJson(dynamic json) {
    final map = <String, ConsentChoice>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConsentChoice.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConsentChoice-objects as value to a dart map
  static Map<String, List<ConsentChoice>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConsentChoice>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConsentChoice.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'share_profile',
    'marketing_story',
    'text_versions',
  };
}

