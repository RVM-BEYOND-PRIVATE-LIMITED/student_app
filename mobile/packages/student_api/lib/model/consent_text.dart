//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ConsentText {
  /// Returns a new [ConsentText] instance.
  ConsentText({
    required this.purpose,
    required this.version,
    required this.language,
    required this.text,
    required this.required_,
  });

  ConsentPurpose purpose;

  /// Minimum value: 1
  int version;

  ConsentTextLanguageEnum language;

  String text;

  bool required_;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConsentText &&
    other.purpose == purpose &&
    other.version == version &&
    other.language == language &&
    other.text == text &&
    other.required_ == required_;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (purpose.hashCode) +
    (version.hashCode) +
    (language.hashCode) +
    (text.hashCode) +
    (required_.hashCode);

  @override
  String toString() => 'ConsentText[purpose=$purpose, version=$version, language=$language, text=$text, required_=$required_]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'purpose'] = this.purpose;
      json[r'version'] = this.version;
      json[r'language'] = this.language;
      json[r'text'] = this.text;
      json[r'required'] = this.required_;
    return json;
  }

  /// Returns a new [ConsentText] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConsentText? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'purpose'), 'Required key "ConsentText[purpose]" is missing from JSON.');
        assert(json[r'purpose'] != null, 'Required key "ConsentText[purpose]" has a null value in JSON.');
        assert(json.containsKey(r'version'), 'Required key "ConsentText[version]" is missing from JSON.');
        assert(json[r'version'] != null, 'Required key "ConsentText[version]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "ConsentText[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "ConsentText[language]" has a null value in JSON.');
        assert(json.containsKey(r'text'), 'Required key "ConsentText[text]" is missing from JSON.');
        assert(json[r'text'] != null, 'Required key "ConsentText[text]" has a null value in JSON.');
        assert(json.containsKey(r'required'), 'Required key "ConsentText[required]" is missing from JSON.');
        assert(json[r'required'] != null, 'Required key "ConsentText[required]" has a null value in JSON.');
        return true;
      }());

      return ConsentText(
        purpose: ConsentPurpose.fromJson(json[r'purpose'])!,
        version: mapValueOfType<int>(json, r'version')!,
        language: ConsentTextLanguageEnum.fromJson(json[r'language'])!,
        text: mapValueOfType<String>(json, r'text')!,
        required_: mapValueOfType<bool>(json, r'required')!,
      );
    }
    return null;
  }

  static List<ConsentText> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConsentText>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConsentText.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConsentText> mapFromJson(dynamic json) {
    final map = <String, ConsentText>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConsentText.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConsentText-objects as value to a dart map
  static Map<String, List<ConsentText>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConsentText>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConsentText.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'purpose',
    'version',
    'language',
    'text',
    'required',
  };
}


enum ConsentTextLanguageEnum {
  en._(r'en'),
  hi._(r'hi'),
  ;

  /// Instantiate a new enum with the provided value.
  const ConsentTextLanguageEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ConsentTextLanguageEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ConsentTextLanguageEnum? fromJson(dynamic value) => ConsentTextLanguageEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ConsentTextLanguageEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ConsentTextLanguageEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConsentTextLanguageEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConsentTextLanguageEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ConsentTextLanguageEnum] to String,
/// and [decode] dynamic data back to [ConsentTextLanguageEnum].
class ConsentTextLanguageEnumTypeTransformer {
  factory ConsentTextLanguageEnumTypeTransformer() => _instance ??= const ConsentTextLanguageEnumTypeTransformer._();

  const ConsentTextLanguageEnumTypeTransformer._();

  String encode(ConsentTextLanguageEnum data) => data._value;

  /// Returns the instance of [ConsentTextLanguageEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ConsentTextLanguageEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ConsentTextLanguageEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'en': return ConsentTextLanguageEnum.en;
        case r'hi': return ConsentTextLanguageEnum.hi;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ConsentTextLanguageEnumTypeTransformer? _instance;
}


