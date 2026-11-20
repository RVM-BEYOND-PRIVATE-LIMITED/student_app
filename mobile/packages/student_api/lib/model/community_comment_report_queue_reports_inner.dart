//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CommunityCommentReportQueueReportsInner {
  /// Returns a new [CommunityCommentReportQueueReportsInner] instance.
  CommunityCommentReportQueueReportsInner({
    required this.commentId,
    required this.postId,
    required this.groupId,
    required this.groupName,
    required this.author,
    required this.authorAccountId,
    required this.body,
    required this.createdAt,
    required this.hidden,
    required this.reportCount,
    this.reasons = const [],
    required this.firstReportedAt,
  });

  String commentId;

  String postId;

  String groupId;

  String groupName;

  String author;

  String? authorAccountId;

  String body;

  DateTime createdAt;

  bool hidden;

  /// Minimum value: 1
  int reportCount;

  List<String> reasons;

  DateTime firstReportedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CommunityCommentReportQueueReportsInner &&
    other.commentId == commentId &&
    other.postId == postId &&
    other.groupId == groupId &&
    other.groupName == groupName &&
    other.author == author &&
    other.authorAccountId == authorAccountId &&
    other.body == body &&
    other.createdAt == createdAt &&
    other.hidden == hidden &&
    other.reportCount == reportCount &&
    _deepEquality.equals(other.reasons, reasons) &&
    other.firstReportedAt == firstReportedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (commentId.hashCode) +
    (postId.hashCode) +
    (groupId.hashCode) +
    (groupName.hashCode) +
    (author.hashCode) +
    (authorAccountId == null ? 0 : authorAccountId!.hashCode) +
    (body.hashCode) +
    (createdAt.hashCode) +
    (hidden.hashCode) +
    (reportCount.hashCode) +
    (reasons.hashCode) +
    (firstReportedAt.hashCode);

  @override
  String toString() => 'CommunityCommentReportQueueReportsInner[commentId=$commentId, postId=$postId, groupId=$groupId, groupName=$groupName, author=$author, authorAccountId=$authorAccountId, body=$body, createdAt=$createdAt, hidden=$hidden, reportCount=$reportCount, reasons=$reasons, firstReportedAt=$firstReportedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'comment_id'] = this.commentId;
      json[r'post_id'] = this.postId;
      json[r'group_id'] = this.groupId;
      json[r'group_name'] = this.groupName;
      json[r'author'] = this.author;
    if (this.authorAccountId != null) {
      json[r'author_account_id'] = this.authorAccountId;
    } else {
      json[r'author_account_id'] = null;
    }
      json[r'body'] = this.body;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'hidden'] = this.hidden;
      json[r'report_count'] = this.reportCount;
      json[r'reasons'] = this.reasons;
      json[r'first_reported_at'] = this.firstReportedAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [CommunityCommentReportQueueReportsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CommunityCommentReportQueueReportsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'comment_id'), 'Required key "CommunityCommentReportQueueReportsInner[comment_id]" is missing from JSON.');
        assert(json[r'comment_id'] != null, 'Required key "CommunityCommentReportQueueReportsInner[comment_id]" has a null value in JSON.');
        assert(json.containsKey(r'post_id'), 'Required key "CommunityCommentReportQueueReportsInner[post_id]" is missing from JSON.');
        assert(json[r'post_id'] != null, 'Required key "CommunityCommentReportQueueReportsInner[post_id]" has a null value in JSON.');
        assert(json.containsKey(r'group_id'), 'Required key "CommunityCommentReportQueueReportsInner[group_id]" is missing from JSON.');
        assert(json[r'group_id'] != null, 'Required key "CommunityCommentReportQueueReportsInner[group_id]" has a null value in JSON.');
        assert(json.containsKey(r'group_name'), 'Required key "CommunityCommentReportQueueReportsInner[group_name]" is missing from JSON.');
        assert(json[r'group_name'] != null, 'Required key "CommunityCommentReportQueueReportsInner[group_name]" has a null value in JSON.');
        assert(json.containsKey(r'author'), 'Required key "CommunityCommentReportQueueReportsInner[author]" is missing from JSON.');
        assert(json[r'author'] != null, 'Required key "CommunityCommentReportQueueReportsInner[author]" has a null value in JSON.');
        assert(json.containsKey(r'author_account_id'), 'Required key "CommunityCommentReportQueueReportsInner[author_account_id]" is missing from JSON.');
        assert(json.containsKey(r'body'), 'Required key "CommunityCommentReportQueueReportsInner[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "CommunityCommentReportQueueReportsInner[body]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'), 'Required key "CommunityCommentReportQueueReportsInner[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null, 'Required key "CommunityCommentReportQueueReportsInner[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'hidden'), 'Required key "CommunityCommentReportQueueReportsInner[hidden]" is missing from JSON.');
        assert(json[r'hidden'] != null, 'Required key "CommunityCommentReportQueueReportsInner[hidden]" has a null value in JSON.');
        assert(json.containsKey(r'report_count'), 'Required key "CommunityCommentReportQueueReportsInner[report_count]" is missing from JSON.');
        assert(json[r'report_count'] != null, 'Required key "CommunityCommentReportQueueReportsInner[report_count]" has a null value in JSON.');
        assert(json.containsKey(r'reasons'), 'Required key "CommunityCommentReportQueueReportsInner[reasons]" is missing from JSON.');
        assert(json[r'reasons'] != null, 'Required key "CommunityCommentReportQueueReportsInner[reasons]" has a null value in JSON.');
        assert(json.containsKey(r'first_reported_at'), 'Required key "CommunityCommentReportQueueReportsInner[first_reported_at]" is missing from JSON.');
        assert(json[r'first_reported_at'] != null, 'Required key "CommunityCommentReportQueueReportsInner[first_reported_at]" has a null value in JSON.');
        return true;
      }());

      return CommunityCommentReportQueueReportsInner(
        commentId: mapValueOfType<String>(json, r'comment_id')!,
        postId: mapValueOfType<String>(json, r'post_id')!,
        groupId: mapValueOfType<String>(json, r'group_id')!,
        groupName: mapValueOfType<String>(json, r'group_name')!,
        author: mapValueOfType<String>(json, r'author')!,
        authorAccountId: mapValueOfType<String>(json, r'author_account_id'),
        body: mapValueOfType<String>(json, r'body')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        hidden: mapValueOfType<bool>(json, r'hidden')!,
        reportCount: mapValueOfType<int>(json, r'report_count')!,
        reasons: json[r'reasons'] is Iterable
            ? (json[r'reasons'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        firstReportedAt: mapDateTime(json, r'first_reported_at', r'')!,
      );
    }
    return null;
  }

  static List<CommunityCommentReportQueueReportsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CommunityCommentReportQueueReportsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CommunityCommentReportQueueReportsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CommunityCommentReportQueueReportsInner> mapFromJson(dynamic json) {
    final map = <String, CommunityCommentReportQueueReportsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CommunityCommentReportQueueReportsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CommunityCommentReportQueueReportsInner-objects as value to a dart map
  static Map<String, List<CommunityCommentReportQueueReportsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CommunityCommentReportQueueReportsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CommunityCommentReportQueueReportsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'comment_id',
    'post_id',
    'group_id',
    'group_name',
    'author',
    'author_account_id',
    'body',
    'created_at',
    'hidden',
    'report_count',
    'reasons',
    'first_reported_at',
  };
}

