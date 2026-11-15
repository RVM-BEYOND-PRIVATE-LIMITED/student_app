//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ThemePreference {
  /// Returns a new [ThemePreference] instance.
  ThemePreference({
    this.theme = const ThemePreferenceThemeEnum._('light'),
    required this.themeOpen,
  });

  ThemePreferenceThemeEnum theme;

  bool themeOpen;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ThemePreference &&
    other.theme == theme &&
    other.themeOpen == themeOpen;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (theme.hashCode) +
    (themeOpen.hashCode);

  @override
  String toString() => 'ThemePreference[theme=$theme, themeOpen=$themeOpen]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'theme'] = this.theme;
      json[r'theme_open'] = this.themeOpen;
    return json;
  }

  /// Returns a new [ThemePreference] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ThemePreference? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'theme'), 'Required key "ThemePreference[theme]" is missing from JSON.');
        assert(json[r'theme'] != null, 'Required key "ThemePreference[theme]" has a null value in JSON.');
        assert(json.containsKey(r'theme_open'), 'Required key "ThemePreference[theme_open]" is missing from JSON.');
        assert(json[r'theme_open'] != null, 'Required key "ThemePreference[theme_open]" has a null value in JSON.');
        return true;
      }());

      return ThemePreference(
        theme: ThemePreferenceThemeEnum.fromJson(json[r'theme'])!,
        themeOpen: mapValueOfType<bool>(json, r'theme_open')!,
      );
    }
    return null;
  }

  static List<ThemePreference> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ThemePreference>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ThemePreference.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ThemePreference> mapFromJson(dynamic json) {
    final map = <String, ThemePreference>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ThemePreference.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ThemePreference-objects as value to a dart map
  static Map<String, List<ThemePreference>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ThemePreference>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ThemePreference.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'theme',
    'theme_open',
  };
}


enum ThemePreferenceThemeEnum {
  light._(r'light'),
  dark._(r'dark'),
  system._(r'system'),
  ;

  /// Instantiate a new enum with the provided value.
  const ThemePreferenceThemeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ThemePreferenceThemeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ThemePreferenceThemeEnum? fromJson(dynamic value) => ThemePreferenceThemeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ThemePreferenceThemeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ThemePreferenceThemeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ThemePreferenceThemeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ThemePreferenceThemeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ThemePreferenceThemeEnum] to String,
/// and [decode] dynamic data back to [ThemePreferenceThemeEnum].
class ThemePreferenceThemeEnumTypeTransformer {
  factory ThemePreferenceThemeEnumTypeTransformer() => _instance ??= const ThemePreferenceThemeEnumTypeTransformer._();

  const ThemePreferenceThemeEnumTypeTransformer._();

  String encode(ThemePreferenceThemeEnum data) => data._value;

  /// Returns the instance of [ThemePreferenceThemeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ThemePreferenceThemeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ThemePreferenceThemeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'light': return ThemePreferenceThemeEnum.light;
        case r'dark': return ThemePreferenceThemeEnum.dark;
        case r'system': return ThemePreferenceThemeEnum.system;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ThemePreferenceThemeEnumTypeTransformer? _instance;
}


