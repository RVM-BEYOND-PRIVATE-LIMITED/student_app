//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PlacementProofCreated {
  /// Returns a new [PlacementProofCreated] instance.
  PlacementProofCreated({
    required this.id,
    required this.status,
    required this.joinedSelection,
  });

  String id;

  PlacementProofCreatedStatusEnum status;

  bool joinedSelection;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PlacementProofCreated &&
    other.id == id &&
    other.status == status &&
    other.joinedSelection == joinedSelection;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (status.hashCode) +
    (joinedSelection.hashCode);

  @override
  String toString() => 'PlacementProofCreated[id=$id, status=$status, joinedSelection=$joinedSelection]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'status'] = this.status;
      json[r'joined_selection'] = this.joinedSelection;
    return json;
  }

  /// Returns a new [PlacementProofCreated] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PlacementProofCreated? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "PlacementProofCreated[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "PlacementProofCreated[id]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "PlacementProofCreated[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "PlacementProofCreated[status]" has a null value in JSON.');
        assert(json.containsKey(r'joined_selection'), 'Required key "PlacementProofCreated[joined_selection]" is missing from JSON.');
        assert(json[r'joined_selection'] != null, 'Required key "PlacementProofCreated[joined_selection]" has a null value in JSON.');
        return true;
      }());

      return PlacementProofCreated(
        id: mapValueOfType<String>(json, r'id')!,
        status: PlacementProofCreatedStatusEnum.fromJson(json[r'status'])!,
        joinedSelection: mapValueOfType<bool>(json, r'joined_selection')!,
      );
    }
    return null;
  }

  static List<PlacementProofCreated> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PlacementProofCreated>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PlacementProofCreated.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PlacementProofCreated> mapFromJson(dynamic json) {
    final map = <String, PlacementProofCreated>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PlacementProofCreated.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PlacementProofCreated-objects as value to a dart map
  static Map<String, List<PlacementProofCreated>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PlacementProofCreated>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PlacementProofCreated.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'status',
    'joined_selection',
  };
}


enum PlacementProofCreatedStatusEnum {
  submitted._(r'submitted'),
  ;

  /// Instantiate a new enum with the provided value.
  const PlacementProofCreatedStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PlacementProofCreatedStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PlacementProofCreatedStatusEnum? fromJson(dynamic value) => PlacementProofCreatedStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PlacementProofCreatedStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PlacementProofCreatedStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PlacementProofCreatedStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PlacementProofCreatedStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PlacementProofCreatedStatusEnum] to String,
/// and [decode] dynamic data back to [PlacementProofCreatedStatusEnum].
class PlacementProofCreatedStatusEnumTypeTransformer {
  factory PlacementProofCreatedStatusEnumTypeTransformer() => _instance ??= const PlacementProofCreatedStatusEnumTypeTransformer._();

  const PlacementProofCreatedStatusEnumTypeTransformer._();

  String encode(PlacementProofCreatedStatusEnum data) => data._value;

  /// Returns the instance of [PlacementProofCreatedStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PlacementProofCreatedStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PlacementProofCreatedStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'submitted': return PlacementProofCreatedStatusEnum.submitted;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PlacementProofCreatedStatusEnumTypeTransformer? _instance;
}


