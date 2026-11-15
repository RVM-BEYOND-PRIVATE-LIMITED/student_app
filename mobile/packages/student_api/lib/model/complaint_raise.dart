//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ComplaintRaise {
  /// Returns a new [ComplaintRaise] instance.
  ComplaintRaise({
    required this.category,
    required this.description,
  });

  String category;

  String description;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ComplaintRaise &&
    other.category == category &&
    other.description == description;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (category.hashCode) +
    (description.hashCode);

  @override
  String toString() => 'ComplaintRaise[category=$category, description=$description]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'category'] = this.category;
      json[r'description'] = this.description;
    return json;
  }

  /// Returns a new [ComplaintRaise] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ComplaintRaise? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'category'), 'Required key "ComplaintRaise[category]" is missing from JSON.');
        assert(json[r'category'] != null, 'Required key "ComplaintRaise[category]" has a null value in JSON.');
        assert(json.containsKey(r'description'), 'Required key "ComplaintRaise[description]" is missing from JSON.');
        assert(json[r'description'] != null, 'Required key "ComplaintRaise[description]" has a null value in JSON.');
        return true;
      }());

      return ComplaintRaise(
        category: mapValueOfType<String>(json, r'category')!,
        description: mapValueOfType<String>(json, r'description')!,
      );
    }
    return null;
  }

  static List<ComplaintRaise> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ComplaintRaise>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ComplaintRaise.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ComplaintRaise> mapFromJson(dynamic json) {
    final map = <String, ComplaintRaise>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ComplaintRaise.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ComplaintRaise-objects as value to a dart map
  static Map<String, List<ComplaintRaise>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ComplaintRaise>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ComplaintRaise.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'category',
    'description',
  };
}

