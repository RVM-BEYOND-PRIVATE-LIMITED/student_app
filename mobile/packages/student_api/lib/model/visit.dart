//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Visit {
  /// Returns a new [Visit] instance.
  Visit({
    required this.id,
    required this.kind,
    required this.locationId,
    required this.preferredAt,
    required this.status,
    this.createdAt,
  });

  String id;

  String kind;

  int locationId;

  DateTime preferredAt;

  VisitStatusEnum status;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Visit &&
    other.id == id &&
    other.kind == kind &&
    other.locationId == locationId &&
    other.preferredAt == preferredAt &&
    other.status == status &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (kind.hashCode) +
    (locationId.hashCode) +
    (preferredAt.hashCode) +
    (status.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode);

  @override
  String toString() => 'Visit[id=$id, kind=$kind, locationId=$locationId, preferredAt=$preferredAt, status=$status, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'kind'] = this.kind;
      json[r'location_id'] = this.locationId;
      json[r'preferred_at'] = this.preferredAt.toUtc().toIso8601String();
      json[r'status'] = this.status;
    if (this.createdAt != null) {
      json[r'created_at'] = this.createdAt!.toUtc().toIso8601String();
    } else {
      json[r'created_at'] = null;
    }
    return json;
  }

  /// Returns a new [Visit] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Visit? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "Visit[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "Visit[id]" has a null value in JSON.');
        assert(json.containsKey(r'kind'), 'Required key "Visit[kind]" is missing from JSON.');
        assert(json[r'kind'] != null, 'Required key "Visit[kind]" has a null value in JSON.');
        assert(json.containsKey(r'location_id'), 'Required key "Visit[location_id]" is missing from JSON.');
        assert(json[r'location_id'] != null, 'Required key "Visit[location_id]" has a null value in JSON.');
        assert(json.containsKey(r'preferred_at'), 'Required key "Visit[preferred_at]" is missing from JSON.');
        assert(json[r'preferred_at'] != null, 'Required key "Visit[preferred_at]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "Visit[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "Visit[status]" has a null value in JSON.');
        return true;
      }());

      return Visit(
        id: mapValueOfType<String>(json, r'id')!,
        kind: mapValueOfType<String>(json, r'kind')!,
        locationId: mapValueOfType<int>(json, r'location_id')!,
        preferredAt: mapDateTime(json, r'preferred_at', r'')!,
        status: VisitStatusEnum.fromJson(json[r'status'])!,
        createdAt: mapDateTime(json, r'created_at', r''),
      );
    }
    return null;
  }

  static List<Visit> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Visit>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Visit.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Visit> mapFromJson(dynamic json) {
    final map = <String, Visit>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Visit.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Visit-objects as value to a dart map
  static Map<String, List<Visit>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Visit>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Visit.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'kind',
    'location_id',
    'preferred_at',
    'status',
  };
}


enum VisitStatusEnum {
  booked._(r'booked'),
  ;

  /// Instantiate a new enum with the provided value.
  const VisitStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [VisitStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static VisitStatusEnum? fromJson(dynamic value) => VisitStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [VisitStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<VisitStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VisitStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VisitStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [VisitStatusEnum] to String,
/// and [decode] dynamic data back to [VisitStatusEnum].
class VisitStatusEnumTypeTransformer {
  factory VisitStatusEnumTypeTransformer() => _instance ??= const VisitStatusEnumTypeTransformer._();

  const VisitStatusEnumTypeTransformer._();

  String encode(VisitStatusEnum data) => data._value;

  /// Returns the instance of [VisitStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  VisitStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is VisitStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'booked': return VisitStatusEnum.booked;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static VisitStatusEnumTypeTransformer? _instance;
}


