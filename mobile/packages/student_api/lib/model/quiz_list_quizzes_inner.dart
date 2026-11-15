//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class QuizListQuizzesInner {
  /// Returns a new [QuizListQuizzesInner] instance.
  QuizListQuizzesInner({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    required this.questions,
  });

  String id;

  QuizListQuizzesInnerKindEnum kind;

  String title;

  String? description;

  /// Minimum value: 0
  int questions;

  @override
  bool operator ==(Object other) => identical(this, other) || other is QuizListQuizzesInner &&
    other.id == id &&
    other.kind == kind &&
    other.title == title &&
    other.description == description &&
    other.questions == questions;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (kind.hashCode) +
    (title.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (questions.hashCode);

  @override
  String toString() => 'QuizListQuizzesInner[id=$id, kind=$kind, title=$title, description=$description, questions=$questions]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'kind'] = this.kind;
      json[r'title'] = this.title;
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
      json[r'questions'] = this.questions;
    return json;
  }

  /// Returns a new [QuizListQuizzesInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static QuizListQuizzesInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "QuizListQuizzesInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "QuizListQuizzesInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'kind'), 'Required key "QuizListQuizzesInner[kind]" is missing from JSON.');
        assert(json[r'kind'] != null, 'Required key "QuizListQuizzesInner[kind]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "QuizListQuizzesInner[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "QuizListQuizzesInner[title]" has a null value in JSON.');
        assert(json.containsKey(r'description'), 'Required key "QuizListQuizzesInner[description]" is missing from JSON.');
        assert(json.containsKey(r'questions'), 'Required key "QuizListQuizzesInner[questions]" is missing from JSON.');
        assert(json[r'questions'] != null, 'Required key "QuizListQuizzesInner[questions]" has a null value in JSON.');
        return true;
      }());

      return QuizListQuizzesInner(
        id: mapValueOfType<String>(json, r'id')!,
        kind: QuizListQuizzesInnerKindEnum.fromJson(json[r'kind'])!,
        title: mapValueOfType<String>(json, r'title')!,
        description: mapValueOfType<String>(json, r'description'),
        questions: mapValueOfType<int>(json, r'questions')!,
      );
    }
    return null;
  }

  static List<QuizListQuizzesInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <QuizListQuizzesInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QuizListQuizzesInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QuizListQuizzesInner> mapFromJson(dynamic json) {
    final map = <String, QuizListQuizzesInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = QuizListQuizzesInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QuizListQuizzesInner-objects as value to a dart map
  static Map<String, List<QuizListQuizzesInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<QuizListQuizzesInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QuizListQuizzesInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'kind',
    'title',
    'description',
    'questions',
  };
}


enum QuizListQuizzesInnerKindEnum {
  practice._(r'practice'),
  courseSuggestion._(r'course_suggestion'),
  ;

  /// Instantiate a new enum with the provided value.
  const QuizListQuizzesInnerKindEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [QuizListQuizzesInnerKindEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static QuizListQuizzesInnerKindEnum? fromJson(dynamic value) => QuizListQuizzesInnerKindEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [QuizListQuizzesInnerKindEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<QuizListQuizzesInnerKindEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <QuizListQuizzesInnerKindEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QuizListQuizzesInnerKindEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [QuizListQuizzesInnerKindEnum] to String,
/// and [decode] dynamic data back to [QuizListQuizzesInnerKindEnum].
class QuizListQuizzesInnerKindEnumTypeTransformer {
  factory QuizListQuizzesInnerKindEnumTypeTransformer() => _instance ??= const QuizListQuizzesInnerKindEnumTypeTransformer._();

  const QuizListQuizzesInnerKindEnumTypeTransformer._();

  String encode(QuizListQuizzesInnerKindEnum data) => data._value;

  /// Returns the instance of [QuizListQuizzesInnerKindEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  QuizListQuizzesInnerKindEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is QuizListQuizzesInnerKindEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'practice': return QuizListQuizzesInnerKindEnum.practice;
        case r'course_suggestion': return QuizListQuizzesInnerKindEnum.courseSuggestion;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static QuizListQuizzesInnerKindEnumTypeTransformer? _instance;
}


