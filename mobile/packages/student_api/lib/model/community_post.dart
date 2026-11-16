//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CommunityPost {
  /// Returns a new [CommunityPost] instance.
  CommunityPost({
    required this.id,
    required this.groupId,
    required this.author,
    required this.mine,
    required this.body,
    required this.createdAt,
    required this.commentCount,
    required this.reactionCount,
    required this.reacted,
    required this.hidden,
    required this.poll,
  });

  String id;

  String groupId;

  /// First name, course and branch; never a phone number.
  String author;

  bool mine;

  String body;

  DateTime createdAt;

  /// Minimum value: 0
  int commentCount;

  /// Minimum value: 0
  int reactionCount;

  bool reacted;

  /// Only moderators ever see a hidden post.
  bool hidden;

  CommunityPoll? poll;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CommunityPost &&
    other.id == id &&
    other.groupId == groupId &&
    other.author == author &&
    other.mine == mine &&
    other.body == body &&
    other.createdAt == createdAt &&
    other.commentCount == commentCount &&
    other.reactionCount == reactionCount &&
    other.reacted == reacted &&
    other.hidden == hidden &&
    other.poll == poll;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (groupId.hashCode) +
    (author.hashCode) +
    (mine.hashCode) +
    (body.hashCode) +
    (createdAt.hashCode) +
    (commentCount.hashCode) +
    (reactionCount.hashCode) +
    (reacted.hashCode) +
    (hidden.hashCode) +
    (poll == null ? 0 : poll!.hashCode);

  @override
  String toString() => 'CommunityPost[id=$id, groupId=$groupId, author=$author, mine=$mine, body=$body, createdAt=$createdAt, commentCount=$commentCount, reactionCount=$reactionCount, reacted=$reacted, hidden=$hidden, poll=$poll]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'group_id'] = this.groupId;
      json[r'author'] = this.author;
      json[r'mine'] = this.mine;
      json[r'body'] = this.body;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'comment_count'] = this.commentCount;
      json[r'reaction_count'] = this.reactionCount;
      json[r'reacted'] = this.reacted;
      json[r'hidden'] = this.hidden;
    if (this.poll != null) {
      json[r'poll'] = this.poll;
    } else {
      json[r'poll'] = null;
    }
    return json;
  }

  /// Returns a new [CommunityPost] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CommunityPost? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "CommunityPost[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "CommunityPost[id]" has a null value in JSON.');
        assert(json.containsKey(r'group_id'), 'Required key "CommunityPost[group_id]" is missing from JSON.');
        assert(json[r'group_id'] != null, 'Required key "CommunityPost[group_id]" has a null value in JSON.');
        assert(json.containsKey(r'author'), 'Required key "CommunityPost[author]" is missing from JSON.');
        assert(json[r'author'] != null, 'Required key "CommunityPost[author]" has a null value in JSON.');
        assert(json.containsKey(r'mine'), 'Required key "CommunityPost[mine]" is missing from JSON.');
        assert(json[r'mine'] != null, 'Required key "CommunityPost[mine]" has a null value in JSON.');
        assert(json.containsKey(r'body'), 'Required key "CommunityPost[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "CommunityPost[body]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'), 'Required key "CommunityPost[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null, 'Required key "CommunityPost[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'comment_count'), 'Required key "CommunityPost[comment_count]" is missing from JSON.');
        assert(json[r'comment_count'] != null, 'Required key "CommunityPost[comment_count]" has a null value in JSON.');
        assert(json.containsKey(r'reaction_count'), 'Required key "CommunityPost[reaction_count]" is missing from JSON.');
        assert(json[r'reaction_count'] != null, 'Required key "CommunityPost[reaction_count]" has a null value in JSON.');
        assert(json.containsKey(r'reacted'), 'Required key "CommunityPost[reacted]" is missing from JSON.');
        assert(json[r'reacted'] != null, 'Required key "CommunityPost[reacted]" has a null value in JSON.');
        assert(json.containsKey(r'hidden'), 'Required key "CommunityPost[hidden]" is missing from JSON.');
        assert(json[r'hidden'] != null, 'Required key "CommunityPost[hidden]" has a null value in JSON.');
        assert(json.containsKey(r'poll'), 'Required key "CommunityPost[poll]" is missing from JSON.');
        return true;
      }());

      return CommunityPost(
        id: mapValueOfType<String>(json, r'id')!,
        groupId: mapValueOfType<String>(json, r'group_id')!,
        author: mapValueOfType<String>(json, r'author')!,
        mine: mapValueOfType<bool>(json, r'mine')!,
        body: mapValueOfType<String>(json, r'body')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        commentCount: mapValueOfType<int>(json, r'comment_count')!,
        reactionCount: mapValueOfType<int>(json, r'reaction_count')!,
        reacted: mapValueOfType<bool>(json, r'reacted')!,
        hidden: mapValueOfType<bool>(json, r'hidden')!,
        poll: CommunityPoll.fromJson(json[r'poll']),
      );
    }
    return null;
  }

  static List<CommunityPost> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CommunityPost>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CommunityPost.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CommunityPost> mapFromJson(dynamic json) {
    final map = <String, CommunityPost>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CommunityPost.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CommunityPost-objects as value to a dart map
  static Map<String, List<CommunityPost>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CommunityPost>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CommunityPost.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'group_id',
    'author',
    'mine',
    'body',
    'created_at',
    'comment_count',
    'reaction_count',
    'reacted',
    'hidden',
    'poll',
  };
}

