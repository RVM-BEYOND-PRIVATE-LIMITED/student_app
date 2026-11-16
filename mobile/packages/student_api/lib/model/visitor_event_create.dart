//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class VisitorEventCreate {
  /// Returns a new [VisitorEventCreate] instance.
  VisitorEventCreate({
    required this.kind,
    this.courseId,
  });

  VisitorEventCreateKindEnum kind;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? courseId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VisitorEventCreate &&
    other.kind == kind &&
    other.courseId == courseId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (kind.hashCode) +
    (courseId == null ? 0 : courseId!.hashCode);

  @override
  String toString() => 'VisitorEventCreate[kind=$kind, courseId=$courseId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'kind'] = this.kind;
    if (this.courseId != null) {
      json[r'course_id'] = this.courseId;
    } else {
      json[r'course_id'] = null;
    }
    return json;
  }

  /// Returns a new [VisitorEventCreate] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static VisitorEventCreate? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'kind'), 'Required key "VisitorEventCreate[kind]" is missing from JSON.');
        assert(json[r'kind'] != null, 'Required key "VisitorEventCreate[kind]" has a null value in JSON.');
        return true;
      }());

      return VisitorEventCreate(
        kind: VisitorEventCreateKindEnum.fromJson(json[r'kind'])!,
        courseId: mapValueOfType<String>(json, r'course_id'),
      );
    }
    return null;
  }

  static List<VisitorEventCreate> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VisitorEventCreate>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VisitorEventCreate.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VisitorEventCreate> mapFromJson(dynamic json) {
    final map = <String, VisitorEventCreate>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = VisitorEventCreate.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VisitorEventCreate-objects as value to a dart map
  static Map<String, List<VisitorEventCreate>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VisitorEventCreate>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VisitorEventCreate.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'kind',
  };
}


enum VisitorEventCreateKindEnum {
  wantToJoin._(r'want_to_join'),
  coursePurchase._(r'course_purchase'),
  ;

  /// Instantiate a new enum with the provided value.
  const VisitorEventCreateKindEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [VisitorEventCreateKindEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static VisitorEventCreateKindEnum? fromJson(dynamic value) => VisitorEventCreateKindEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [VisitorEventCreateKindEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<VisitorEventCreateKindEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VisitorEventCreateKindEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VisitorEventCreateKindEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [VisitorEventCreateKindEnum] to String,
/// and [decode] dynamic data back to [VisitorEventCreateKindEnum].
class VisitorEventCreateKindEnumTypeTransformer {
  factory VisitorEventCreateKindEnumTypeTransformer() => _instance ??= const VisitorEventCreateKindEnumTypeTransformer._();

  const VisitorEventCreateKindEnumTypeTransformer._();

  String encode(VisitorEventCreateKindEnum data) => data._value;

  /// Returns the instance of [VisitorEventCreateKindEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  VisitorEventCreateKindEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is VisitorEventCreateKindEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'want_to_join': return VisitorEventCreateKindEnum.wantToJoin;
        case r'course_purchase': return VisitorEventCreateKindEnum.coursePurchase;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static VisitorEventCreateKindEnumTypeTransformer? _instance;
}


