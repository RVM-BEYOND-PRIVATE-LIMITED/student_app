//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class LanguageChoice {
  /// Returns a new [LanguageChoice] instance.
  LanguageChoice({
    required this.language,
  });

  LanguageChoiceLanguageEnum language;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LanguageChoice &&
    other.language == language;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (language.hashCode);

  @override
  String toString() => 'LanguageChoice[language=$language]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'language'] = this.language;
    return json;
  }

  /// Returns a new [LanguageChoice] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LanguageChoice? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'language'), 'Required key "LanguageChoice[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "LanguageChoice[language]" has a null value in JSON.');
        return true;
      }());

      return LanguageChoice(
        language: LanguageChoiceLanguageEnum.fromJson(json[r'language'])!,
      );
    }
    return null;
  }

  static List<LanguageChoice> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LanguageChoice>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LanguageChoice.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LanguageChoice> mapFromJson(dynamic json) {
    final map = <String, LanguageChoice>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LanguageChoice.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LanguageChoice-objects as value to a dart map
  static Map<String, List<LanguageChoice>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LanguageChoice>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LanguageChoice.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'language',
  };
}


enum LanguageChoiceLanguageEnum {
  en._(r'en'),
  hi._(r'hi'),
  ;

  /// Instantiate a new enum with the provided value.
  const LanguageChoiceLanguageEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [LanguageChoiceLanguageEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static LanguageChoiceLanguageEnum? fromJson(dynamic value) => LanguageChoiceLanguageEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [LanguageChoiceLanguageEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<LanguageChoiceLanguageEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LanguageChoiceLanguageEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LanguageChoiceLanguageEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [LanguageChoiceLanguageEnum] to String,
/// and [decode] dynamic data back to [LanguageChoiceLanguageEnum].
class LanguageChoiceLanguageEnumTypeTransformer {
  factory LanguageChoiceLanguageEnumTypeTransformer() => _instance ??= const LanguageChoiceLanguageEnumTypeTransformer._();

  const LanguageChoiceLanguageEnumTypeTransformer._();

  String encode(LanguageChoiceLanguageEnum data) => data._value;

  /// Returns the instance of [LanguageChoiceLanguageEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  LanguageChoiceLanguageEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is LanguageChoiceLanguageEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'en': return LanguageChoiceLanguageEnum.en;
        case r'hi': return LanguageChoiceLanguageEnum.hi;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static LanguageChoiceLanguageEnumTypeTransformer? _instance;
}


