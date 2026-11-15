//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Profile {
  /// Returns a new [Profile] instance.
  Profile({
    required this.id,
    required this.phoneMasked,
    required this.language,
    required this.contactPreferences,
  });

  String id;

  String phoneMasked;

  ProfileLanguageEnum language;

  ProfileContactPreferences contactPreferences;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Profile &&
    other.id == id &&
    other.phoneMasked == phoneMasked &&
    other.language == language &&
    other.contactPreferences == contactPreferences;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (phoneMasked.hashCode) +
    (language.hashCode) +
    (contactPreferences.hashCode);

  @override
  String toString() => 'Profile[id=$id, phoneMasked=$phoneMasked, language=$language, contactPreferences=$contactPreferences]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'phone_masked'] = this.phoneMasked;
      json[r'language'] = this.language;
      json[r'contact_preferences'] = this.contactPreferences;
    return json;
  }

  /// Returns a new [Profile] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Profile? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "Profile[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "Profile[id]" has a null value in JSON.');
        assert(json.containsKey(r'phone_masked'), 'Required key "Profile[phone_masked]" is missing from JSON.');
        assert(json[r'phone_masked'] != null, 'Required key "Profile[phone_masked]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "Profile[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "Profile[language]" has a null value in JSON.');
        assert(json.containsKey(r'contact_preferences'), 'Required key "Profile[contact_preferences]" is missing from JSON.');
        assert(json[r'contact_preferences'] != null, 'Required key "Profile[contact_preferences]" has a null value in JSON.');
        return true;
      }());

      return Profile(
        id: mapValueOfType<String>(json, r'id')!,
        phoneMasked: mapValueOfType<String>(json, r'phone_masked')!,
        language: ProfileLanguageEnum.fromJson(json[r'language'])!,
        contactPreferences: ProfileContactPreferences.fromJson(json[r'contact_preferences'])!,
      );
    }
    return null;
  }

  static List<Profile> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Profile>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Profile.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Profile> mapFromJson(dynamic json) {
    final map = <String, Profile>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Profile.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Profile-objects as value to a dart map
  static Map<String, List<Profile>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Profile>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Profile.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'phone_masked',
    'language',
    'contact_preferences',
  };
}


enum ProfileLanguageEnum {
  en._(r'en'),
  hi._(r'hi'),
  ;

  /// Instantiate a new enum with the provided value.
  const ProfileLanguageEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ProfileLanguageEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ProfileLanguageEnum? fromJson(dynamic value) => ProfileLanguageEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ProfileLanguageEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ProfileLanguageEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProfileLanguageEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileLanguageEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ProfileLanguageEnum] to String,
/// and [decode] dynamic data back to [ProfileLanguageEnum].
class ProfileLanguageEnumTypeTransformer {
  factory ProfileLanguageEnumTypeTransformer() => _instance ??= const ProfileLanguageEnumTypeTransformer._();

  const ProfileLanguageEnumTypeTransformer._();

  String encode(ProfileLanguageEnum data) => data._value;

  /// Returns the instance of [ProfileLanguageEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ProfileLanguageEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ProfileLanguageEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'en': return ProfileLanguageEnum.en;
        case r'hi': return ProfileLanguageEnum.hi;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ProfileLanguageEnumTypeTransformer? _instance;
}


