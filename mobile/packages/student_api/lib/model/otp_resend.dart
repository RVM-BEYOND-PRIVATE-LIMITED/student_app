//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OtpResend {
  /// Returns a new [OtpResend] instance.
  OtpResend({
    required this.challengeId,
  });

  String challengeId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OtpResend &&
    other.challengeId == challengeId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (challengeId.hashCode);

  @override
  String toString() => 'OtpResend[challengeId=$challengeId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'challenge_id'] = this.challengeId;
    return json;
  }

  /// Returns a new [OtpResend] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OtpResend? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'challenge_id'), 'Required key "OtpResend[challenge_id]" is missing from JSON.');
        assert(json[r'challenge_id'] != null, 'Required key "OtpResend[challenge_id]" has a null value in JSON.');
        return true;
      }());

      return OtpResend(
        challengeId: mapValueOfType<String>(json, r'challenge_id')!,
      );
    }
    return null;
  }

  static List<OtpResend> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OtpResend>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OtpResend.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OtpResend> mapFromJson(dynamic json) {
    final map = <String, OtpResend>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OtpResend.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OtpResend-objects as value to a dart map
  static Map<String, List<OtpResend>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OtpResend>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OtpResend.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'challenge_id',
  };
}

