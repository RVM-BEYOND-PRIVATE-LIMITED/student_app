//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SetPushTokenRequest {
  /// Returns a new [SetPushTokenRequest] instance.
  SetPushTokenRequest({
    required this.installId,
    required this.token,
  });

  String installId;

  String token;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SetPushTokenRequest &&
    other.installId == installId &&
    other.token == token;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (installId.hashCode) +
    (token.hashCode);

  @override
  String toString() => 'SetPushTokenRequest[installId=$installId, token=$token]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'install_id'] = this.installId;
      json[r'token'] = this.token;
    return json;
  }

  /// Returns a new [SetPushTokenRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SetPushTokenRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'install_id'), 'Required key "SetPushTokenRequest[install_id]" is missing from JSON.');
        assert(json[r'install_id'] != null, 'Required key "SetPushTokenRequest[install_id]" has a null value in JSON.');
        assert(json.containsKey(r'token'), 'Required key "SetPushTokenRequest[token]" is missing from JSON.');
        assert(json[r'token'] != null, 'Required key "SetPushTokenRequest[token]" has a null value in JSON.');
        return true;
      }());

      return SetPushTokenRequest(
        installId: mapValueOfType<String>(json, r'install_id')!,
        token: mapValueOfType<String>(json, r'token')!,
      );
    }
    return null;
  }

  static List<SetPushTokenRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SetPushTokenRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SetPushTokenRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SetPushTokenRequest> mapFromJson(dynamic json) {
    final map = <String, SetPushTokenRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SetPushTokenRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SetPushTokenRequest-objects as value to a dart map
  static Map<String, List<SetPushTokenRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SetPushTokenRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SetPushTokenRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'install_id',
    'token',
  };
}

