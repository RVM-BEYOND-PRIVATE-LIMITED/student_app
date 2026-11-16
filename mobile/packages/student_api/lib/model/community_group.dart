//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CommunityGroup {
  /// Returns a new [CommunityGroup] instance.
  CommunityGroup({
    required this.id,
    required this.kind,
    required this.name,
  });

  String id;

  CommunityGroupKindEnum kind;

  String name;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CommunityGroup &&
    other.id == id &&
    other.kind == kind &&
    other.name == name;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (kind.hashCode) +
    (name.hashCode);

  @override
  String toString() => 'CommunityGroup[id=$id, kind=$kind, name=$name]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'kind'] = this.kind;
      json[r'name'] = this.name;
    return json;
  }

  /// Returns a new [CommunityGroup] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CommunityGroup? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "CommunityGroup[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "CommunityGroup[id]" has a null value in JSON.');
        assert(json.containsKey(r'kind'), 'Required key "CommunityGroup[kind]" is missing from JSON.');
        assert(json[r'kind'] != null, 'Required key "CommunityGroup[kind]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "CommunityGroup[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "CommunityGroup[name]" has a null value in JSON.');
        return true;
      }());

      return CommunityGroup(
        id: mapValueOfType<String>(json, r'id')!,
        kind: CommunityGroupKindEnum.fromJson(json[r'kind'])!,
        name: mapValueOfType<String>(json, r'name')!,
      );
    }
    return null;
  }

  static List<CommunityGroup> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CommunityGroup>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CommunityGroup.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CommunityGroup> mapFromJson(dynamic json) {
    final map = <String, CommunityGroup>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CommunityGroup.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CommunityGroup-objects as value to a dart map
  static Map<String, List<CommunityGroup>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CommunityGroup>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CommunityGroup.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'kind',
    'name',
  };
}


enum CommunityGroupKindEnum {
  general._(r'general'),
  course._(r'course'),
  branch._(r'branch'),
  ;

  /// Instantiate a new enum with the provided value.
  const CommunityGroupKindEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CommunityGroupKindEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CommunityGroupKindEnum? fromJson(dynamic value) => CommunityGroupKindEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CommunityGroupKindEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CommunityGroupKindEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CommunityGroupKindEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CommunityGroupKindEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CommunityGroupKindEnum] to String,
/// and [decode] dynamic data back to [CommunityGroupKindEnum].
class CommunityGroupKindEnumTypeTransformer {
  factory CommunityGroupKindEnumTypeTransformer() => _instance ??= const CommunityGroupKindEnumTypeTransformer._();

  const CommunityGroupKindEnumTypeTransformer._();

  String encode(CommunityGroupKindEnum data) => data._value;

  /// Returns the instance of [CommunityGroupKindEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CommunityGroupKindEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CommunityGroupKindEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'general': return CommunityGroupKindEnum.general;
        case r'course': return CommunityGroupKindEnum.course;
        case r'branch': return CommunityGroupKindEnum.branch;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CommunityGroupKindEnumTypeTransformer? _instance;
}


