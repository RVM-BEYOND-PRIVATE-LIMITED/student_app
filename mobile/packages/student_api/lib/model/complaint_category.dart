//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ComplaintCategory {
  /// Returns a new [ComplaintCategory] instance.
  ComplaintCategory({
    required this.slug,
    required this.name,
    required this.goesTo,
    required this.confidential,
  });

  String slug;

  String name;

  ComplaintCategoryGoesToEnum goesTo;

  bool confidential;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ComplaintCategory &&
    other.slug == slug &&
    other.name == name &&
    other.goesTo == goesTo &&
    other.confidential == confidential;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (slug.hashCode) +
    (name.hashCode) +
    (goesTo.hashCode) +
    (confidential.hashCode);

  @override
  String toString() => 'ComplaintCategory[slug=$slug, name=$name, goesTo=$goesTo, confidential=$confidential]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'slug'] = this.slug;
      json[r'name'] = this.name;
      json[r'goes_to'] = this.goesTo;
      json[r'confidential'] = this.confidential;
    return json;
  }

  /// Returns a new [ComplaintCategory] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ComplaintCategory? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'slug'), 'Required key "ComplaintCategory[slug]" is missing from JSON.');
        assert(json[r'slug'] != null, 'Required key "ComplaintCategory[slug]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "ComplaintCategory[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "ComplaintCategory[name]" has a null value in JSON.');
        assert(json.containsKey(r'goes_to'), 'Required key "ComplaintCategory[goes_to]" is missing from JSON.');
        assert(json[r'goes_to'] != null, 'Required key "ComplaintCategory[goes_to]" has a null value in JSON.');
        assert(json.containsKey(r'confidential'), 'Required key "ComplaintCategory[confidential]" is missing from JSON.');
        assert(json[r'confidential'] != null, 'Required key "ComplaintCategory[confidential]" has a null value in JSON.');
        return true;
      }());

      return ComplaintCategory(
        slug: mapValueOfType<String>(json, r'slug')!,
        name: mapValueOfType<String>(json, r'name')!,
        goesTo: ComplaintCategoryGoesToEnum.fromJson(json[r'goes_to'])!,
        confidential: mapValueOfType<bool>(json, r'confidential')!,
      );
    }
    return null;
  }

  static List<ComplaintCategory> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ComplaintCategory>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ComplaintCategory.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ComplaintCategory> mapFromJson(dynamic json) {
    final map = <String, ComplaintCategory>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ComplaintCategory.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ComplaintCategory-objects as value to a dart map
  static Map<String, List<ComplaintCategory>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ComplaintCategory>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ComplaintCategory.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'slug',
    'name',
    'goes_to',
    'confidential',
  };
}


enum ComplaintCategoryGoesToEnum {
  centre._(r'centre'),
  headOfOperations._(r'head_of_operations'),
  hr._(r'hr'),
  ;

  /// Instantiate a new enum with the provided value.
  const ComplaintCategoryGoesToEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ComplaintCategoryGoesToEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ComplaintCategoryGoesToEnum? fromJson(dynamic value) => ComplaintCategoryGoesToEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ComplaintCategoryGoesToEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ComplaintCategoryGoesToEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ComplaintCategoryGoesToEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ComplaintCategoryGoesToEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ComplaintCategoryGoesToEnum] to String,
/// and [decode] dynamic data back to [ComplaintCategoryGoesToEnum].
class ComplaintCategoryGoesToEnumTypeTransformer {
  factory ComplaintCategoryGoesToEnumTypeTransformer() => _instance ??= const ComplaintCategoryGoesToEnumTypeTransformer._();

  const ComplaintCategoryGoesToEnumTypeTransformer._();

  String encode(ComplaintCategoryGoesToEnum data) => data._value;

  /// Returns the instance of [ComplaintCategoryGoesToEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ComplaintCategoryGoesToEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ComplaintCategoryGoesToEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'centre': return ComplaintCategoryGoesToEnum.centre;
        case r'head_of_operations': return ComplaintCategoryGoesToEnum.headOfOperations;
        case r'hr': return ComplaintCategoryGoesToEnum.hr;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ComplaintCategoryGoesToEnumTypeTransformer? _instance;
}


