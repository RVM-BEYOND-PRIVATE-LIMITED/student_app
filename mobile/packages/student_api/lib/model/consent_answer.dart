//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ConsentAnswer {
  /// Returns a new [ConsentAnswer] instance.
  ConsentAnswer({
    required this.answer,
  });

  ConsentAnswerAnswerEnum answer;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConsentAnswer &&
    other.answer == answer;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (answer.hashCode);

  @override
  String toString() => 'ConsentAnswer[answer=$answer]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'answer'] = this.answer;
    return json;
  }

  /// Returns a new [ConsentAnswer] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConsentAnswer? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'answer'), 'Required key "ConsentAnswer[answer]" is missing from JSON.');
        assert(json[r'answer'] != null, 'Required key "ConsentAnswer[answer]" has a null value in JSON.');
        return true;
      }());

      return ConsentAnswer(
        answer: ConsentAnswerAnswerEnum.fromJson(json[r'answer'])!,
      );
    }
    return null;
  }

  static List<ConsentAnswer> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConsentAnswer>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConsentAnswer.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConsentAnswer> mapFromJson(dynamic json) {
    final map = <String, ConsentAnswer>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConsentAnswer.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConsentAnswer-objects as value to a dart map
  static Map<String, List<ConsentAnswer>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConsentAnswer>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConsentAnswer.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'answer',
  };
}


enum ConsentAnswerAnswerEnum {
  yes._(r'yes'),
  no._(r'no'),
  ;

  /// Instantiate a new enum with the provided value.
  const ConsentAnswerAnswerEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ConsentAnswerAnswerEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ConsentAnswerAnswerEnum? fromJson(dynamic value) => ConsentAnswerAnswerEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ConsentAnswerAnswerEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ConsentAnswerAnswerEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConsentAnswerAnswerEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConsentAnswerAnswerEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ConsentAnswerAnswerEnum] to String,
/// and [decode] dynamic data back to [ConsentAnswerAnswerEnum].
class ConsentAnswerAnswerEnumTypeTransformer {
  factory ConsentAnswerAnswerEnumTypeTransformer() => _instance ??= const ConsentAnswerAnswerEnumTypeTransformer._();

  const ConsentAnswerAnswerEnumTypeTransformer._();

  String encode(ConsentAnswerAnswerEnum data) => data._value;

  /// Returns the instance of [ConsentAnswerAnswerEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ConsentAnswerAnswerEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ConsentAnswerAnswerEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'yes': return ConsentAnswerAnswerEnum.yes;
        case r'no': return ConsentAnswerAnswerEnum.no;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ConsentAnswerAnswerEnumTypeTransformer? _instance;
}


