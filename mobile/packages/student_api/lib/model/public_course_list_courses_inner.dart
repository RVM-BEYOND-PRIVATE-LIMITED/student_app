//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicCourseListCoursesInner {
  /// Returns a new [PublicCourseListCoursesInner] instance.
  PublicCourseListCoursesInner({
    required this.id,
    required this.name,
    required this.pricePaise,
    required this.summary,
    required this.duration,
    this.nextBatches = const [],
  });

  String id;

  String name;

  /// Minimum value: 0
  int pricePaise;

  String? summary;

  String? duration;

  List<PublicCourseListCoursesInnerNextBatchesInner> nextBatches;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicCourseListCoursesInner &&
    other.id == id &&
    other.name == name &&
    other.pricePaise == pricePaise &&
    other.summary == summary &&
    other.duration == duration &&
    _deepEquality.equals(other.nextBatches, nextBatches);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (pricePaise.hashCode) +
    (summary == null ? 0 : summary!.hashCode) +
    (duration == null ? 0 : duration!.hashCode) +
    (nextBatches.hashCode);

  @override
  String toString() => 'PublicCourseListCoursesInner[id=$id, name=$name, pricePaise=$pricePaise, summary=$summary, duration=$duration, nextBatches=$nextBatches]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'price_paise'] = this.pricePaise;
    if (this.summary != null) {
      json[r'summary'] = this.summary;
    } else {
      json[r'summary'] = null;
    }
    if (this.duration != null) {
      json[r'duration'] = this.duration;
    } else {
      json[r'duration'] = null;
    }
      json[r'next_batches'] = this.nextBatches;
    return json;
  }

  /// Returns a new [PublicCourseListCoursesInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicCourseListCoursesInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "PublicCourseListCoursesInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "PublicCourseListCoursesInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "PublicCourseListCoursesInner[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "PublicCourseListCoursesInner[name]" has a null value in JSON.');
        assert(json.containsKey(r'price_paise'), 'Required key "PublicCourseListCoursesInner[price_paise]" is missing from JSON.');
        assert(json[r'price_paise'] != null, 'Required key "PublicCourseListCoursesInner[price_paise]" has a null value in JSON.');
        assert(json.containsKey(r'summary'), 'Required key "PublicCourseListCoursesInner[summary]" is missing from JSON.');
        assert(json.containsKey(r'duration'), 'Required key "PublicCourseListCoursesInner[duration]" is missing from JSON.');
        assert(json.containsKey(r'next_batches'), 'Required key "PublicCourseListCoursesInner[next_batches]" is missing from JSON.');
        assert(json[r'next_batches'] != null, 'Required key "PublicCourseListCoursesInner[next_batches]" has a null value in JSON.');
        return true;
      }());

      return PublicCourseListCoursesInner(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        pricePaise: mapValueOfType<int>(json, r'price_paise')!,
        summary: mapValueOfType<String>(json, r'summary'),
        duration: mapValueOfType<String>(json, r'duration'),
        nextBatches: PublicCourseListCoursesInnerNextBatchesInner.listFromJson(json[r'next_batches']),
      );
    }
    return null;
  }

  static List<PublicCourseListCoursesInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicCourseListCoursesInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicCourseListCoursesInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicCourseListCoursesInner> mapFromJson(dynamic json) {
    final map = <String, PublicCourseListCoursesInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicCourseListCoursesInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicCourseListCoursesInner-objects as value to a dart map
  static Map<String, List<PublicCourseListCoursesInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicCourseListCoursesInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicCourseListCoursesInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'price_paise',
    'summary',
    'duration',
    'next_batches',
  };
}

