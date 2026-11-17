//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OtpChallenge {
  /// Returns a new [OtpChallenge] instance.
  OtpChallenge({
    required this.challengeId,
    required this.channel,
    required this.expiresAt,
    required this.resendAvailableAt,
    this.pilot,
    this.smsFallbackAt,
  });

  String challengeId;

  OtpChallengeChannelEnum channel;

  DateTime expiresAt;

  /// When the SMS resend opens. Null once it has been used.
  DateTime? resendAvailableAt;

  /// Present and true while the app is open only to a pilot list. The reply is then the same for every number, whether or not a code was sent, so show wording that is true either way (for example \"If this number is on the pilot, your code is on its way\"). Absent once the app is open to everyone. 
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? pilot;

  /// Present when the code went on WhatsApp and the automatic SMS fallback is on: unless WhatsApp has confirmed delivery by this time, the same code is sent by SMS. Absent when the fallback is off or the code went by SMS. 
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? smsFallbackAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OtpChallenge &&
    other.challengeId == challengeId &&
    other.channel == channel &&
    other.expiresAt == expiresAt &&
    other.resendAvailableAt == resendAvailableAt &&
    other.pilot == pilot &&
    other.smsFallbackAt == smsFallbackAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (challengeId.hashCode) +
    (channel.hashCode) +
    (expiresAt.hashCode) +
    (resendAvailableAt == null ? 0 : resendAvailableAt!.hashCode) +
    (pilot == null ? 0 : pilot!.hashCode) +
    (smsFallbackAt == null ? 0 : smsFallbackAt!.hashCode);

  @override
  String toString() => 'OtpChallenge[challengeId=$challengeId, channel=$channel, expiresAt=$expiresAt, resendAvailableAt=$resendAvailableAt, pilot=$pilot, smsFallbackAt=$smsFallbackAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'challenge_id'] = this.challengeId;
      json[r'channel'] = this.channel;
      json[r'expires_at'] = this.expiresAt.toUtc().toIso8601String();
    if (this.resendAvailableAt != null) {
      json[r'resend_available_at'] = this.resendAvailableAt!.toUtc().toIso8601String();
    } else {
      json[r'resend_available_at'] = null;
    }
    if (this.pilot != null) {
      json[r'pilot'] = this.pilot;
    } else {
      json[r'pilot'] = null;
    }
    if (this.smsFallbackAt != null) {
      json[r'sms_fallback_at'] = this.smsFallbackAt!.toUtc().toIso8601String();
    } else {
      json[r'sms_fallback_at'] = null;
    }
    return json;
  }

  /// Returns a new [OtpChallenge] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OtpChallenge? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'challenge_id'), 'Required key "OtpChallenge[challenge_id]" is missing from JSON.');
        assert(json[r'challenge_id'] != null, 'Required key "OtpChallenge[challenge_id]" has a null value in JSON.');
        assert(json.containsKey(r'channel'), 'Required key "OtpChallenge[channel]" is missing from JSON.');
        assert(json[r'channel'] != null, 'Required key "OtpChallenge[channel]" has a null value in JSON.');
        assert(json.containsKey(r'expires_at'), 'Required key "OtpChallenge[expires_at]" is missing from JSON.');
        assert(json[r'expires_at'] != null, 'Required key "OtpChallenge[expires_at]" has a null value in JSON.');
        assert(json.containsKey(r'resend_available_at'), 'Required key "OtpChallenge[resend_available_at]" is missing from JSON.');
        return true;
      }());

      return OtpChallenge(
        challengeId: mapValueOfType<String>(json, r'challenge_id')!,
        channel: OtpChallengeChannelEnum.fromJson(json[r'channel'])!,
        expiresAt: mapDateTime(json, r'expires_at', r'')!,
        resendAvailableAt: mapDateTime(json, r'resend_available_at', r''),
        pilot: mapValueOfType<bool>(json, r'pilot'),
        smsFallbackAt: mapDateTime(json, r'sms_fallback_at', r''),
      );
    }
    return null;
  }

  static List<OtpChallenge> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OtpChallenge>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OtpChallenge.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OtpChallenge> mapFromJson(dynamic json) {
    final map = <String, OtpChallenge>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OtpChallenge.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OtpChallenge-objects as value to a dart map
  static Map<String, List<OtpChallenge>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OtpChallenge>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OtpChallenge.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'challenge_id',
    'channel',
    'expires_at',
    'resend_available_at',
  };
}


enum OtpChallengeChannelEnum {
  whatsapp._(r'whatsapp'),
  sms._(r'sms'),
  ;

  /// Instantiate a new enum with the provided value.
  const OtpChallengeChannelEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [OtpChallengeChannelEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static OtpChallengeChannelEnum? fromJson(dynamic value) => OtpChallengeChannelEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [OtpChallengeChannelEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<OtpChallengeChannelEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OtpChallengeChannelEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OtpChallengeChannelEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [OtpChallengeChannelEnum] to String,
/// and [decode] dynamic data back to [OtpChallengeChannelEnum].
class OtpChallengeChannelEnumTypeTransformer {
  factory OtpChallengeChannelEnumTypeTransformer() => _instance ??= const OtpChallengeChannelEnumTypeTransformer._();

  const OtpChallengeChannelEnumTypeTransformer._();

  String encode(OtpChallengeChannelEnum data) => data._value;

  /// Returns the instance of [OtpChallengeChannelEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  OtpChallengeChannelEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is OtpChallengeChannelEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'whatsapp': return OtpChallengeChannelEnum.whatsapp;
        case r'sms': return OtpChallengeChannelEnum.sms;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static OtpChallengeChannelEnumTypeTransformer? _instance;
}


