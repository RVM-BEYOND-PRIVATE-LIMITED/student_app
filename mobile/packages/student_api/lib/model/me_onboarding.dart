//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MeOnboarding {
  /// Returns a new [MeOnboarding] instance.
  MeOnboarding({
    required this.ageConfirmed,
    required this.requiredConsentGiven,
  });

  bool ageConfirmed;

  bool requiredConsentGiven;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MeOnboarding &&
    other.ageConfirmed == ageConfirmed &&
    other.requiredConsentGiven == requiredConsentGiven;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (ageConfirmed.hashCode) +
    (requiredConsentGiven.hashCode);

  @override
  String toString() => 'MeOnboarding[ageConfirmed=$ageConfirmed, requiredConsentGiven=$requiredConsentGiven]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'age_confirmed'] = this.ageConfirmed;
      json[r'required_consent_given'] = this.requiredConsentGiven;
    return json;
  }

  /// Returns a new [MeOnboarding] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MeOnboarding? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'age_confirmed'), 'Required key "MeOnboarding[age_confirmed]" is missing from JSON.');
        assert(json[r'age_confirmed'] != null, 'Required key "MeOnboarding[age_confirmed]" has a null value in JSON.');
        assert(json.containsKey(r'required_consent_given'), 'Required key "MeOnboarding[required_consent_given]" is missing from JSON.');
        assert(json[r'required_consent_given'] != null, 'Required key "MeOnboarding[required_consent_given]" has a null value in JSON.');
        return true;
      }());

      return MeOnboarding(
        ageConfirmed: mapValueOfType<bool>(json, r'age_confirmed')!,
        requiredConsentGiven: mapValueOfType<bool>(json, r'required_consent_given')!,
      );
    }
    return null;
  }

  static List<MeOnboarding> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MeOnboarding>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MeOnboarding.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MeOnboarding> mapFromJson(dynamic json) {
    final map = <String, MeOnboarding>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MeOnboarding.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MeOnboarding-objects as value to a dart map
  static Map<String, List<MeOnboarding>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MeOnboarding>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MeOnboarding.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'age_confirmed',
    'required_consent_given',
  };
}

