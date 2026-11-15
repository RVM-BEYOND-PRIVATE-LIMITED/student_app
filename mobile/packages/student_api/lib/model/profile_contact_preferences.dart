//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ProfileContactPreferences {
  /// Returns a new [ProfileContactPreferences] instance.
  ProfileContactPreferences({
    this.whatsapp,
    this.sms,
    this.push,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? whatsapp;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? sms;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? push;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProfileContactPreferences &&
    other.whatsapp == whatsapp &&
    other.sms == sms &&
    other.push == push;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (whatsapp == null ? 0 : whatsapp!.hashCode) +
    (sms == null ? 0 : sms!.hashCode) +
    (push == null ? 0 : push!.hashCode);

  @override
  String toString() => 'ProfileContactPreferences[whatsapp=$whatsapp, sms=$sms, push=$push]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.whatsapp != null) {
      json[r'whatsapp'] = this.whatsapp;
    } else {
      json[r'whatsapp'] = null;
    }
    if (this.sms != null) {
      json[r'sms'] = this.sms;
    } else {
      json[r'sms'] = null;
    }
    if (this.push != null) {
      json[r'push'] = this.push;
    } else {
      json[r'push'] = null;
    }
    return json;
  }

  /// Returns a new [ProfileContactPreferences] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProfileContactPreferences? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return ProfileContactPreferences(
        whatsapp: mapValueOfType<bool>(json, r'whatsapp'),
        sms: mapValueOfType<bool>(json, r'sms'),
        push: mapValueOfType<bool>(json, r'push'),
      );
    }
    return null;
  }

  static List<ProfileContactPreferences> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProfileContactPreferences>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileContactPreferences.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProfileContactPreferences> mapFromJson(dynamic json) {
    final map = <String, ProfileContactPreferences>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProfileContactPreferences.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProfileContactPreferences-objects as value to a dart map
  static Map<String, List<ProfileContactPreferences>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProfileContactPreferences>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProfileContactPreferences.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

