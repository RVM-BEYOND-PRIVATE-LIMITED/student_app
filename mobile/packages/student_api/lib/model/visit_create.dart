//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class VisitCreate {
  /// Returns a new [VisitCreate] instance.
  VisitCreate({
    required this.kind,
    required this.locationId,
    required this.preferredAt,
  });

  VisitCreateKindEnum kind;

  /// Minimum value: 1
  int locationId;

  DateTime preferredAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VisitCreate &&
    other.kind == kind &&
    other.locationId == locationId &&
    other.preferredAt == preferredAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (kind.hashCode) +
    (locationId.hashCode) +
    (preferredAt.hashCode);

  @override
  String toString() => 'VisitCreate[kind=$kind, locationId=$locationId, preferredAt=$preferredAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'kind'] = this.kind;
      json[r'location_id'] = this.locationId;
      json[r'preferred_at'] = this.preferredAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [VisitCreate] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static VisitCreate? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'kind'), 'Required key "VisitCreate[kind]" is missing from JSON.');
        assert(json[r'kind'] != null, 'Required key "VisitCreate[kind]" has a null value in JSON.');
        assert(json.containsKey(r'location_id'), 'Required key "VisitCreate[location_id]" is missing from JSON.');
        assert(json[r'location_id'] != null, 'Required key "VisitCreate[location_id]" has a null value in JSON.');
        assert(json.containsKey(r'preferred_at'), 'Required key "VisitCreate[preferred_at]" is missing from JSON.');
        assert(json[r'preferred_at'] != null, 'Required key "VisitCreate[preferred_at]" has a null value in JSON.');
        return true;
      }());

      return VisitCreate(
        kind: VisitCreateKindEnum.fromJson(json[r'kind'])!,
        locationId: mapValueOfType<int>(json, r'location_id')!,
        preferredAt: mapDateTime(json, r'preferred_at', r'')!,
      );
    }
    return null;
  }

  static List<VisitCreate> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VisitCreate>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VisitCreate.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VisitCreate> mapFromJson(dynamic json) {
    final map = <String, VisitCreate>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = VisitCreate.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VisitCreate-objects as value to a dart map
  static Map<String, List<VisitCreate>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VisitCreate>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VisitCreate.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'kind',
    'location_id',
    'preferred_at',
  };
}


enum VisitCreateKindEnum {
  demoClass._(r'demo_class'),
  centreVisit._(r'centre_visit'),
  counsellorCall._(r'counsellor_call'),
  ;

  /// Instantiate a new enum with the provided value.
  const VisitCreateKindEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [VisitCreateKindEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static VisitCreateKindEnum? fromJson(dynamic value) => VisitCreateKindEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [VisitCreateKindEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<VisitCreateKindEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VisitCreateKindEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VisitCreateKindEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [VisitCreateKindEnum] to String,
/// and [decode] dynamic data back to [VisitCreateKindEnum].
class VisitCreateKindEnumTypeTransformer {
  factory VisitCreateKindEnumTypeTransformer() => _instance ??= const VisitCreateKindEnumTypeTransformer._();

  const VisitCreateKindEnumTypeTransformer._();

  String encode(VisitCreateKindEnum data) => data._value;

  /// Returns the instance of [VisitCreateKindEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  VisitCreateKindEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is VisitCreateKindEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'demo_class': return VisitCreateKindEnum.demoClass;
        case r'centre_visit': return VisitCreateKindEnum.centreVisit;
        case r'counsellor_call': return VisitCreateKindEnum.counsellorCall;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static VisitCreateKindEnumTypeTransformer? _instance;
}


