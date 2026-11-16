//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ThemeChoice {
  /// Returns a new [ThemeChoice] instance.
  ThemeChoice({
    required this.theme,
  });

  ThemeChoiceThemeEnum theme;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ThemeChoice &&
    other.theme == theme;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (theme.hashCode);

  @override
  String toString() => 'ThemeChoice[theme=$theme]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'theme'] = this.theme;
    return json;
  }

  /// Returns a new [ThemeChoice] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ThemeChoice? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'theme'), 'Required key "ThemeChoice[theme]" is missing from JSON.');
        assert(json[r'theme'] != null, 'Required key "ThemeChoice[theme]" has a null value in JSON.');
        return true;
      }());

      return ThemeChoice(
        theme: ThemeChoiceThemeEnum.fromJson(json[r'theme'])!,
      );
    }
    return null;
  }

  static List<ThemeChoice> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ThemeChoice>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ThemeChoice.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ThemeChoice> mapFromJson(dynamic json) {
    final map = <String, ThemeChoice>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ThemeChoice.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ThemeChoice-objects as value to a dart map
  static Map<String, List<ThemeChoice>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ThemeChoice>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ThemeChoice.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'theme',
  };
}


enum ThemeChoiceThemeEnum {
  light._(r'light'),
  dark._(r'dark'),
  system._(r'system'),
  ;

  /// Instantiate a new enum with the provided value.
  const ThemeChoiceThemeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ThemeChoiceThemeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ThemeChoiceThemeEnum? fromJson(dynamic value) => ThemeChoiceThemeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ThemeChoiceThemeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ThemeChoiceThemeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ThemeChoiceThemeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ThemeChoiceThemeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ThemeChoiceThemeEnum] to String,
/// and [decode] dynamic data back to [ThemeChoiceThemeEnum].
class ThemeChoiceThemeEnumTypeTransformer {
  factory ThemeChoiceThemeEnumTypeTransformer() => _instance ??= const ThemeChoiceThemeEnumTypeTransformer._();

  const ThemeChoiceThemeEnumTypeTransformer._();

  String encode(ThemeChoiceThemeEnum data) => data._value;

  /// Returns the instance of [ThemeChoiceThemeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ThemeChoiceThemeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ThemeChoiceThemeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'light': return ThemeChoiceThemeEnum.light;
        case r'dark': return ThemeChoiceThemeEnum.dark;
        case r'system': return ThemeChoiceThemeEnum.system;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ThemeChoiceThemeEnumTypeTransformer? _instance;
}


