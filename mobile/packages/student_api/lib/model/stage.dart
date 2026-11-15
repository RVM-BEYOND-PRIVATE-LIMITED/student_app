//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

/// visitor: not linked to an admission. registered: linked, fees still due. fully_paid: the whole fee is paid. alumni: the course has ended; an alumnus with dues still has `fee_fully_paid: false`. 
enum Stage {
  visitor._(r'visitor'),
  registered._(r'registered'),
  fullyPaid._(r'fully_paid'),
  alumni._(r'alumni'),
  ;

  /// Instantiate a new enum with the provided value.
  const Stage._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [Stage] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static Stage? fromJson(dynamic value) => StageTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [Stage]
  /// that were successfully decoded from the passed [JSON][json].
  static List<Stage> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Stage>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Stage.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [Stage] to String,
/// and [decode] dynamic data back to [Stage].
class StageTypeTransformer {
  factory StageTypeTransformer() => _instance ??= const StageTypeTransformer._();

  const StageTypeTransformer._();

  /// Encodes this enum as a value suitable for JSON.
  String encode(Stage data) => data._value;

  /// Returns the instance of [Stage] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  Stage? decode(dynamic data, {bool allowNull = true}) {
    if (data is Stage) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'visitor': return Stage.visitor;
        case r'registered': return Stage.registered;
        case r'fully_paid': return Stage.fullyPaid;
        case r'alumni': return Stage.alumni;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static StageTypeTransformer? _instance;
}

