//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Course {
  /// Returns a new [Course] instance.
  Course({
    required this.id,
    required this.name,
    required this.pricePaise,
  });

  String id;

  String name;

  /// Minimum value: 0
  int pricePaise;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Course &&
    other.id == id &&
    other.name == name &&
    other.pricePaise == pricePaise;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (pricePaise.hashCode);

  @override
  String toString() => 'Course[id=$id, name=$name, pricePaise=$pricePaise]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'price_paise'] = this.pricePaise;
    return json;
  }

  /// Returns a new [Course] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Course? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "Course[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "Course[id]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "Course[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "Course[name]" has a null value in JSON.');
        assert(json.containsKey(r'price_paise'), 'Required key "Course[price_paise]" is missing from JSON.');
        assert(json[r'price_paise'] != null, 'Required key "Course[price_paise]" has a null value in JSON.');
        return true;
      }());

      return Course(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        pricePaise: mapValueOfType<int>(json, r'price_paise')!,
      );
    }
    return null;
  }

  static List<Course> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Course>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Course.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Course> mapFromJson(dynamic json) {
    final map = <String, Course>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Course.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Course-objects as value to a dart map
  static Map<String, List<Course>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Course>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Course.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'price_paise',
  };
}

