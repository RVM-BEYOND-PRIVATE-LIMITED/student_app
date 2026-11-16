//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OtpVerify {
  /// Returns a new [OtpVerify] instance.
  OtpVerify({
    required this.challengeId,
    required this.code,
    required this.device,
  });

  String challengeId;

  String code;

  Device device;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OtpVerify &&
    other.challengeId == challengeId &&
    other.code == code &&
    other.device == device;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (challengeId.hashCode) +
    (code.hashCode) +
    (device.hashCode);

  @override
  String toString() => 'OtpVerify[challengeId=$challengeId, code=$code, device=$device]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'challenge_id'] = this.challengeId;
      json[r'code'] = this.code;
      json[r'device'] = this.device;
    return json;
  }

  /// Returns a new [OtpVerify] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OtpVerify? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'challenge_id'), 'Required key "OtpVerify[challenge_id]" is missing from JSON.');
        assert(json[r'challenge_id'] != null, 'Required key "OtpVerify[challenge_id]" has a null value in JSON.');
        assert(json.containsKey(r'code'), 'Required key "OtpVerify[code]" is missing from JSON.');
        assert(json[r'code'] != null, 'Required key "OtpVerify[code]" has a null value in JSON.');
        assert(json.containsKey(r'device'), 'Required key "OtpVerify[device]" is missing from JSON.');
        assert(json[r'device'] != null, 'Required key "OtpVerify[device]" has a null value in JSON.');
        return true;
      }());

      return OtpVerify(
        challengeId: mapValueOfType<String>(json, r'challenge_id')!,
        code: mapValueOfType<String>(json, r'code')!,
        device: Device.fromJson(json[r'device'])!,
      );
    }
    return null;
  }

  static List<OtpVerify> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OtpVerify>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OtpVerify.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OtpVerify> mapFromJson(dynamic json) {
    final map = <String, OtpVerify>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OtpVerify.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OtpVerify-objects as value to a dart map
  static Map<String, List<OtpVerify>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OtpVerify>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OtpVerify.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'challenge_id',
    'code',
    'device',
  };
}

