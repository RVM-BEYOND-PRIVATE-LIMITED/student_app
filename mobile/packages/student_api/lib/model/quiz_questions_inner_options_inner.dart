//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class QuizQuestionsInnerOptionsInner {
  /// Returns a new [QuizQuestionsInnerOptionsInner] instance.
  QuizQuestionsInnerOptionsInner({
    required this.key,
    required this.label,
  });

  String key;

  String label;

  @override
  bool operator ==(Object other) => identical(this, other) || other is QuizQuestionsInnerOptionsInner &&
    other.key == key &&
    other.label == label;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (key.hashCode) +
    (label.hashCode);

  @override
  String toString() => 'QuizQuestionsInnerOptionsInner[key=$key, label=$label]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'key'] = this.key;
      json[r'label'] = this.label;
    return json;
  }

  /// Returns a new [QuizQuestionsInnerOptionsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static QuizQuestionsInnerOptionsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'key'), 'Required key "QuizQuestionsInnerOptionsInner[key]" is missing from JSON.');
        assert(json[r'key'] != null, 'Required key "QuizQuestionsInnerOptionsInner[key]" has a null value in JSON.');
        assert(json.containsKey(r'label'), 'Required key "QuizQuestionsInnerOptionsInner[label]" is missing from JSON.');
        assert(json[r'label'] != null, 'Required key "QuizQuestionsInnerOptionsInner[label]" has a null value in JSON.');
        return true;
      }());

      return QuizQuestionsInnerOptionsInner(
        key: mapValueOfType<String>(json, r'key')!,
        label: mapValueOfType<String>(json, r'label')!,
      );
    }
    return null;
  }

  static List<QuizQuestionsInnerOptionsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <QuizQuestionsInnerOptionsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QuizQuestionsInnerOptionsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QuizQuestionsInnerOptionsInner> mapFromJson(dynamic json) {
    final map = <String, QuizQuestionsInnerOptionsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = QuizQuestionsInnerOptionsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QuizQuestionsInnerOptionsInner-objects as value to a dart map
  static Map<String, List<QuizQuestionsInnerOptionsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<QuizQuestionsInnerOptionsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QuizQuestionsInnerOptionsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'key',
    'label',
  };
}

