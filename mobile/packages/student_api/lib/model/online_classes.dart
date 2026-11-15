//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OnlineClasses {
  /// Returns a new [OnlineClasses] instance.
  OnlineClasses({
    this.classes = const [],
  });

  List<OnlineClassesClassesInner> classes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OnlineClasses &&
    _deepEquality.equals(other.classes, classes);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (classes.hashCode);

  @override
  String toString() => 'OnlineClasses[classes=$classes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'classes'] = this.classes;
    return json;
  }

  /// Returns a new [OnlineClasses] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OnlineClasses? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'classes'), 'Required key "OnlineClasses[classes]" is missing from JSON.');
        assert(json[r'classes'] != null, 'Required key "OnlineClasses[classes]" has a null value in JSON.');
        return true;
      }());

      return OnlineClasses(
        classes: OnlineClassesClassesInner.listFromJson(json[r'classes']),
      );
    }
    return null;
  }

  static List<OnlineClasses> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnlineClasses>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnlineClasses.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OnlineClasses> mapFromJson(dynamic json) {
    final map = <String, OnlineClasses>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OnlineClasses.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OnlineClasses-objects as value to a dart map
  static Map<String, List<OnlineClasses>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OnlineClasses>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OnlineClasses.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'classes',
  };
}

