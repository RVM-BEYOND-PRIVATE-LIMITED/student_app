//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ProfilePatch {
  /// Returns a new [ProfilePatch] instance.
  ProfilePatch({
    this.language,
    this.contactPreferences,
  });

  ProfilePatchLanguageEnum? language;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ProfileContactPreferences? contactPreferences;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProfilePatch &&
    other.language == language &&
    other.contactPreferences == contactPreferences;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (language == null ? 0 : language!.hashCode) +
    (contactPreferences == null ? 0 : contactPreferences!.hashCode);

  @override
  String toString() => 'ProfilePatch[language=$language, contactPreferences=$contactPreferences]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.language != null) {
      json[r'language'] = this.language;
    } else {
      json[r'language'] = null;
    }
    if (this.contactPreferences != null) {
      json[r'contact_preferences'] = this.contactPreferences;
    } else {
      json[r'contact_preferences'] = null;
    }
    return json;
  }

  /// Returns a new [ProfilePatch] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProfilePatch? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return ProfilePatch(
        language: ProfilePatchLanguageEnum.fromJson(json[r'language']),
        contactPreferences: ProfileContactPreferences.fromJson(json[r'contact_preferences']),
      );
    }
    return null;
  }

  static List<ProfilePatch> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProfilePatch>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfilePatch.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProfilePatch> mapFromJson(dynamic json) {
    final map = <String, ProfilePatch>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProfilePatch.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProfilePatch-objects as value to a dart map
  static Map<String, List<ProfilePatch>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProfilePatch>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProfilePatch.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


enum ProfilePatchLanguageEnum {
  en._(r'en'),
  hi._(r'hi'),
  ;

  /// Instantiate a new enum with the provided value.
  const ProfilePatchLanguageEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ProfilePatchLanguageEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ProfilePatchLanguageEnum? fromJson(dynamic value) => ProfilePatchLanguageEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ProfilePatchLanguageEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ProfilePatchLanguageEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProfilePatchLanguageEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfilePatchLanguageEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ProfilePatchLanguageEnum] to String,
/// and [decode] dynamic data back to [ProfilePatchLanguageEnum].
class ProfilePatchLanguageEnumTypeTransformer {
  factory ProfilePatchLanguageEnumTypeTransformer() => _instance ??= const ProfilePatchLanguageEnumTypeTransformer._();

  const ProfilePatchLanguageEnumTypeTransformer._();

  String encode(ProfilePatchLanguageEnum data) => data._value;

  /// Returns the instance of [ProfilePatchLanguageEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ProfilePatchLanguageEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ProfilePatchLanguageEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'en': return ProfilePatchLanguageEnum.en;
        case r'hi': return ProfilePatchLanguageEnum.hi;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ProfilePatchLanguageEnumTypeTransformer? _instance;
}


