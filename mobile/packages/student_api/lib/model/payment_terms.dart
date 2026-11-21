//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PaymentTerms {
  /// Returns a new [PaymentTerms] instance.
  PaymentTerms({
    required this.version,
    required this.language,
    required this.text,
  });

  /// Minimum value: 1
  int version;

  PaymentTermsLanguageEnum language;

  String text;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PaymentTerms &&
    other.version == version &&
    other.language == language &&
    other.text == text;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (version.hashCode) +
    (language.hashCode) +
    (text.hashCode);

  @override
  String toString() => 'PaymentTerms[version=$version, language=$language, text=$text]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'version'] = this.version;
      json[r'language'] = this.language;
      json[r'text'] = this.text;
    return json;
  }

  /// Returns a new [PaymentTerms] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PaymentTerms? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'version'), 'Required key "PaymentTerms[version]" is missing from JSON.');
        assert(json[r'version'] != null, 'Required key "PaymentTerms[version]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "PaymentTerms[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "PaymentTerms[language]" has a null value in JSON.');
        assert(json.containsKey(r'text'), 'Required key "PaymentTerms[text]" is missing from JSON.');
        assert(json[r'text'] != null, 'Required key "PaymentTerms[text]" has a null value in JSON.');
        return true;
      }());

      return PaymentTerms(
        version: mapValueOfType<int>(json, r'version')!,
        language: PaymentTermsLanguageEnum.fromJson(json[r'language'])!,
        text: mapValueOfType<String>(json, r'text')!,
      );
    }
    return null;
  }

  static List<PaymentTerms> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentTerms>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentTerms.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PaymentTerms> mapFromJson(dynamic json) {
    final map = <String, PaymentTerms>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PaymentTerms.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PaymentTerms-objects as value to a dart map
  static Map<String, List<PaymentTerms>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PaymentTerms>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PaymentTerms.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'version',
    'language',
    'text',
  };
}


enum PaymentTermsLanguageEnum {
  en._(r'en'),
  hi._(r'hi'),
  ;

  /// Instantiate a new enum with the provided value.
  const PaymentTermsLanguageEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PaymentTermsLanguageEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PaymentTermsLanguageEnum? fromJson(dynamic value) => PaymentTermsLanguageEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PaymentTermsLanguageEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PaymentTermsLanguageEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentTermsLanguageEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentTermsLanguageEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PaymentTermsLanguageEnum] to String,
/// and [decode] dynamic data back to [PaymentTermsLanguageEnum].
class PaymentTermsLanguageEnumTypeTransformer {
  factory PaymentTermsLanguageEnumTypeTransformer() => _instance ??= const PaymentTermsLanguageEnumTypeTransformer._();

  const PaymentTermsLanguageEnumTypeTransformer._();

  String encode(PaymentTermsLanguageEnum data) => data._value;

  /// Returns the instance of [PaymentTermsLanguageEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PaymentTermsLanguageEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PaymentTermsLanguageEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'en': return PaymentTermsLanguageEnum.en;
        case r'hi': return PaymentTermsLanguageEnum.hi;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PaymentTermsLanguageEnumTypeTransformer? _instance;
}


