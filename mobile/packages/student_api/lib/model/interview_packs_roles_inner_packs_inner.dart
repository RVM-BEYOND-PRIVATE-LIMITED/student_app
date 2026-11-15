//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class InterviewPacksRolesInnerPacksInner {
  /// Returns a new [InterviewPacksRolesInnerPacksInner] instance.
  InterviewPacksRolesInnerPacksInner({
    required this.id,
    required this.title,
    required this.sizeBytes,
  });

  String id;

  String title;

  int sizeBytes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is InterviewPacksRolesInnerPacksInner &&
    other.id == id &&
    other.title == title &&
    other.sizeBytes == sizeBytes;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (sizeBytes.hashCode);

  @override
  String toString() => 'InterviewPacksRolesInnerPacksInner[id=$id, title=$title, sizeBytes=$sizeBytes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'size_bytes'] = this.sizeBytes;
    return json;
  }

  /// Returns a new [InterviewPacksRolesInnerPacksInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static InterviewPacksRolesInnerPacksInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "InterviewPacksRolesInnerPacksInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "InterviewPacksRolesInnerPacksInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "InterviewPacksRolesInnerPacksInner[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "InterviewPacksRolesInnerPacksInner[title]" has a null value in JSON.');
        assert(json.containsKey(r'size_bytes'), 'Required key "InterviewPacksRolesInnerPacksInner[size_bytes]" is missing from JSON.');
        assert(json[r'size_bytes'] != null, 'Required key "InterviewPacksRolesInnerPacksInner[size_bytes]" has a null value in JSON.');
        return true;
      }());

      return InterviewPacksRolesInnerPacksInner(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        sizeBytes: mapValueOfType<int>(json, r'size_bytes')!,
      );
    }
    return null;
  }

  static List<InterviewPacksRolesInnerPacksInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <InterviewPacksRolesInnerPacksInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = InterviewPacksRolesInnerPacksInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, InterviewPacksRolesInnerPacksInner> mapFromJson(dynamic json) {
    final map = <String, InterviewPacksRolesInnerPacksInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = InterviewPacksRolesInnerPacksInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of InterviewPacksRolesInnerPacksInner-objects as value to a dart map
  static Map<String, List<InterviewPacksRolesInnerPacksInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<InterviewPacksRolesInnerPacksInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = InterviewPacksRolesInnerPacksInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'size_bytes',
  };
}

