//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CommunityCommentReportQueue {
  /// Returns a new [CommunityCommentReportQueue] instance.
  CommunityCommentReportQueue({
    this.reports = const [],
  });

  List<CommunityCommentReportQueueReportsInner> reports;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CommunityCommentReportQueue &&
    _deepEquality.equals(other.reports, reports);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (reports.hashCode);

  @override
  String toString() => 'CommunityCommentReportQueue[reports=$reports]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'reports'] = this.reports;
    return json;
  }

  /// Returns a new [CommunityCommentReportQueue] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CommunityCommentReportQueue? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'reports'), 'Required key "CommunityCommentReportQueue[reports]" is missing from JSON.');
        assert(json[r'reports'] != null, 'Required key "CommunityCommentReportQueue[reports]" has a null value in JSON.');
        return true;
      }());

      return CommunityCommentReportQueue(
        reports: CommunityCommentReportQueueReportsInner.listFromJson(json[r'reports']),
      );
    }
    return null;
  }

  static List<CommunityCommentReportQueue> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CommunityCommentReportQueue>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CommunityCommentReportQueue.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CommunityCommentReportQueue> mapFromJson(dynamic json) {
    final map = <String, CommunityCommentReportQueue>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CommunityCommentReportQueue.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CommunityCommentReportQueue-objects as value to a dart map
  static Map<String, List<CommunityCommentReportQueue>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CommunityCommentReportQueue>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CommunityCommentReportQueue.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'reports',
  };
}

