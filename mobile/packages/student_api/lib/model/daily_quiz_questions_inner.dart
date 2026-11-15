//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DailyQuizQuestionsInner {
  /// Returns a new [DailyQuizQuestionsInner] instance.
  DailyQuizQuestionsInner({
    required this.id,
    required this.prompt,
    this.options = const [],
  });

  String id;

  String prompt;

  List<DailyQuizQuestionsInnerOptionsInner> options;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DailyQuizQuestionsInner &&
    other.id == id &&
    other.prompt == prompt &&
    _deepEquality.equals(other.options, options);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (prompt.hashCode) +
    (options.hashCode);

  @override
  String toString() => 'DailyQuizQuestionsInner[id=$id, prompt=$prompt, options=$options]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'prompt'] = this.prompt;
      json[r'options'] = this.options;
    return json;
  }

  /// Returns a new [DailyQuizQuestionsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DailyQuizQuestionsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "DailyQuizQuestionsInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "DailyQuizQuestionsInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'prompt'), 'Required key "DailyQuizQuestionsInner[prompt]" is missing from JSON.');
        assert(json[r'prompt'] != null, 'Required key "DailyQuizQuestionsInner[prompt]" has a null value in JSON.');
        assert(json.containsKey(r'options'), 'Required key "DailyQuizQuestionsInner[options]" is missing from JSON.');
        assert(json[r'options'] != null, 'Required key "DailyQuizQuestionsInner[options]" has a null value in JSON.');
        return true;
      }());

      return DailyQuizQuestionsInner(
        id: mapValueOfType<String>(json, r'id')!,
        prompt: mapValueOfType<String>(json, r'prompt')!,
        options: DailyQuizQuestionsInnerOptionsInner.listFromJson(json[r'options']),
      );
    }
    return null;
  }

  static List<DailyQuizQuestionsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DailyQuizQuestionsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DailyQuizQuestionsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DailyQuizQuestionsInner> mapFromJson(dynamic json) {
    final map = <String, DailyQuizQuestionsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DailyQuizQuestionsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DailyQuizQuestionsInner-objects as value to a dart map
  static Map<String, List<DailyQuizQuestionsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DailyQuizQuestionsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DailyQuizQuestionsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'prompt',
    'options',
  };
}

