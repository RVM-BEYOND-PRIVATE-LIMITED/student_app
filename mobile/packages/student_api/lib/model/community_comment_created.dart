//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CommunityCommentCreated {
  /// Returns a new [CommunityCommentCreated] instance.
  CommunityCommentCreated({
    required this.id,
    required this.mine,
    required this.body,
    required this.createdAt,
  });

  String id;

  bool mine;

  String body;

  DateTime createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CommunityCommentCreated &&
    other.id == id &&
    other.mine == mine &&
    other.body == body &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (mine.hashCode) +
    (body.hashCode) +
    (createdAt.hashCode);

  @override
  String toString() => 'CommunityCommentCreated[id=$id, mine=$mine, body=$body, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'mine'] = this.mine;
      json[r'body'] = this.body;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [CommunityCommentCreated] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CommunityCommentCreated? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "CommunityCommentCreated[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "CommunityCommentCreated[id]" has a null value in JSON.');
        assert(json.containsKey(r'mine'), 'Required key "CommunityCommentCreated[mine]" is missing from JSON.');
        assert(json[r'mine'] != null, 'Required key "CommunityCommentCreated[mine]" has a null value in JSON.');
        assert(json.containsKey(r'body'), 'Required key "CommunityCommentCreated[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "CommunityCommentCreated[body]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'), 'Required key "CommunityCommentCreated[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null, 'Required key "CommunityCommentCreated[created_at]" has a null value in JSON.');
        return true;
      }());

      return CommunityCommentCreated(
        id: mapValueOfType<String>(json, r'id')!,
        mine: mapValueOfType<bool>(json, r'mine')!,
        body: mapValueOfType<String>(json, r'body')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
      );
    }
    return null;
  }

  static List<CommunityCommentCreated> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CommunityCommentCreated>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CommunityCommentCreated.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CommunityCommentCreated> mapFromJson(dynamic json) {
    final map = <String, CommunityCommentCreated>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CommunityCommentCreated.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CommunityCommentCreated-objects as value to a dart map
  static Map<String, List<CommunityCommentCreated>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CommunityCommentCreated>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CommunityCommentCreated.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'mine',
    'body',
    'created_at',
  };
}

