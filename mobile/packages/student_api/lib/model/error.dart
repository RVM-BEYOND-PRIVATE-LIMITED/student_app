//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Error {
  /// Returns a new [Error] instance.
  Error({
    required this.code,
    required this.message,
    required this.details,
    required this.requestId,
  });

  /// What the app branches on. One of: VALIDATION_FAILED, IDEMPOTENCY_KEY_REQUIRED, IDEMPOTENCY_KEY_INVALID, IDEMPOTENCY_KEY_REUSED, IDEMPOTENCY_IN_PROGRESS, UNAUTHENTICATED, CODE_WRONG, CODE_EXPIRED, ONBOARDING_INCOMPLETE, ACCOUNT_BLOCKED, STAGE_REQUIRED, JOBS_CLOSED, NOT_FOUND, DEVICE_CHANGE_NEEDS_CENTRE, PHONE_INVALID, RESEND_USED, RESEND_TOO_SOON, OTP_UNAVAILABLE, LINK_REQUEST_OPEN, ALREADY_ANSWERED, ALREADY_ADMITTED, REGISTRATION_OPEN, REGISTRATION_SUBMITTED, REGISTRATION_INCOMPLETE, VIDEO_NOT_STARTED, VIDEO_TOO_SOON, BATCH_FULL, ALREADY_CHOSEN, FEE_HOLD, CORRECTION_TOO_OLD, NOT_A_SESSION, CORRECTION_OPEN, COMMUNITY_MUTED, CONSENT_TEXT_OUTDATED, UPGRADE_REQUIRED, RATE_LIMITED, MODULE_OFF, MAINTENANCE, NOT_READY, INTERNAL. 
  String code;

  String message;

  /// Extra facts for some codes, otherwise null.
  Object? details;

  String requestId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Error &&
    other.code == code &&
    other.message == message &&
    other.details == details &&
    other.requestId == requestId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (code.hashCode) +
    (message.hashCode) +
    (details == null ? 0 : details!.hashCode) +
    (requestId.hashCode);

  @override
  String toString() => 'Error[code=$code, message=$message, details=$details, requestId=$requestId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'code'] = this.code;
      json[r'message'] = this.message;
    if (this.details != null) {
      json[r'details'] = this.details;
    } else {
      json[r'details'] = null;
    }
      json[r'request_id'] = this.requestId;
    return json;
  }

  /// Returns a new [Error] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Error? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'code'), 'Required key "Error[code]" is missing from JSON.');
        assert(json[r'code'] != null, 'Required key "Error[code]" has a null value in JSON.');
        assert(json.containsKey(r'message'), 'Required key "Error[message]" is missing from JSON.');
        assert(json[r'message'] != null, 'Required key "Error[message]" has a null value in JSON.');
        assert(json.containsKey(r'details'), 'Required key "Error[details]" is missing from JSON.');
        assert(json.containsKey(r'request_id'), 'Required key "Error[request_id]" is missing from JSON.');
        assert(json[r'request_id'] != null, 'Required key "Error[request_id]" has a null value in JSON.');
        return true;
      }());

      return Error(
        code: mapValueOfType<String>(json, r'code')!,
        message: mapValueOfType<String>(json, r'message')!,
        details: mapValueOfType<Object>(json, r'details'),
        requestId: mapValueOfType<String>(json, r'request_id')!,
      );
    }
    return null;
  }

  static List<Error> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Error>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Error.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Error> mapFromJson(dynamic json) {
    final map = <String, Error>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Error.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Error-objects as value to a dart map
  static Map<String, List<Error>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Error>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Error.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'code',
    'message',
    'details',
    'request_id',
  };
}

