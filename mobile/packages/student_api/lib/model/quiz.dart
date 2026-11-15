//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Quiz {
  /// Returns a new [Quiz] instance.
  Quiz({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    this.questions = const [],
  });

  String id;

  QuizKindEnum kind;

  String title;

  String? description;

  List<QuizQuestionsInner> questions;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Quiz &&
    other.id == id &&
    other.kind == kind &&
    other.title == title &&
    other.description == description &&
    _deepEquality.equals(other.questions, questions);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (kind.hashCode) +
    (title.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (questions.hashCode);

  @override
  String toString() => 'Quiz[id=$id, kind=$kind, title=$title, description=$description, questions=$questions]';

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

  /// Returns a new [Quiz] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Quiz? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "Quiz[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "Quiz[id]" has a null value in JSON.');
        assert(json.containsKey(r'kind'), 'Required key "Quiz[kind]" is missing from JSON.');
        assert(json[r'kind'] != null, 'Required key "Quiz[kind]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "Quiz[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "Quiz[title]" has a null value in JSON.');
        assert(json.containsKey(r'description'), 'Required key "Quiz[description]" is missing from JSON.');
        assert(json.containsKey(r'questions'), 'Required key "Quiz[questions]" is missing from JSON.');
        assert(json[r'questions'] != null, 'Required key "Quiz[questions]" has a null value in JSON.');
        return true;
      }());

      return Quiz(
        id: mapValueOfType<String>(json, r'id')!,
        kind: QuizKindEnum.fromJson(json[r'kind'])!,
        title: mapValueOfType<String>(json, r'title')!,
        description: mapValueOfType<String>(json, r'description'),
        questions: QuizQuestionsInner.listFromJson(json[r'questions']),
      );
    }
    return null;
  }

  static List<Quiz> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Quiz>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Quiz.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Quiz> mapFromJson(dynamic json) {
    final map = <String, Quiz>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Quiz.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Quiz-objects as value to a dart map
  static Map<String, List<Quiz>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Quiz>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Quiz.listFromJson(entry.value, growable: growable,);
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


enum QuizKindEnum {
  practice._(r'practice'),
  courseSuggestion._(r'course_suggestion'),
  ;

  /// Instantiate a new enum with the provided value.
  const QuizKindEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [QuizKindEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static QuizKindEnum? fromJson(dynamic value) => QuizKindEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [QuizKindEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<QuizKindEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <QuizKindEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QuizKindEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [QuizKindEnum] to String,
/// and [decode] dynamic data back to [QuizKindEnum].
class QuizKindEnumTypeTransformer {
  factory QuizKindEnumTypeTransformer() => _instance ??= const QuizKindEnumTypeTransformer._();

  const QuizKindEnumTypeTransformer._();

  String encode(QuizKindEnum data) => data._value;

  /// Returns the instance of [QuizKindEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  QuizKindEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is QuizKindEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'practice': return QuizKindEnum.practice;
        case r'course_suggestion': return QuizKindEnum.courseSuggestion;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static QuizKindEnumTypeTransformer? _instance;
}


