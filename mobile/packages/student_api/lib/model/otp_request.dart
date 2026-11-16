//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OtpRequest {
  /// Returns a new [OtpRequest] instance.
  OtpRequest({
    required this.phone,
  });

  /// An Indian mobile number. Spaces, dashes and a leading +91 or 0 are removed; what is left must be 10 digits starting with 6 to 9.
  String phone;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OtpRequest &&
    other.phone == phone;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (phone.hashCode);

  @override
  String toString() => 'OtpRequest[phone=$phone]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'phone'] = this.phone;
    return json;
  }

  /// Returns a new [OtpRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OtpRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'phone'), 'Required key "OtpRequest[phone]" is missing from JSON.');
        assert(json[r'phone'] != null, 'Required key "OtpRequest[phone]" has a null value in JSON.');
        return true;
      }());

      return OtpRequest(
        phone: mapValueOfType<String>(json, r'phone')!,
      );
    }
    return null;
  }

  static List<OtpRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OtpRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OtpRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OtpRequest> mapFromJson(dynamic json) {
    final map = <String, OtpRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OtpRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OtpRequest-objects as value to a dart map
  static Map<String, List<OtpRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OtpRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OtpRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'phone',
  };
}

