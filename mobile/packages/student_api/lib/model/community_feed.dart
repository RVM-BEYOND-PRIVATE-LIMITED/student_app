//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CommunityFeed {
  /// Returns a new [CommunityFeed] instance.
  CommunityFeed({
    this.posts = const [],
    required this.next,
  });

  List<CommunityPost> posts;

  String? next;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CommunityFeed &&
    _deepEquality.equals(other.posts, posts) &&
    other.next == next;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (posts.hashCode) +
    (next == null ? 0 : next!.hashCode);

  @override
  String toString() => 'CommunityFeed[posts=$posts, next=$next]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'posts'] = this.posts;
    if (this.next != null) {
      json[r'next'] = this.next;
    } else {
      json[r'next'] = null;
    }
    return json;
  }

  /// Returns a new [CommunityFeed] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CommunityFeed? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'posts'), 'Required key "CommunityFeed[posts]" is missing from JSON.');
        assert(json[r'posts'] != null, 'Required key "CommunityFeed[posts]" has a null value in JSON.');
        assert(json.containsKey(r'next'), 'Required key "CommunityFeed[next]" is missing from JSON.');
        return true;
      }());

      return CommunityFeed(
        posts: CommunityPost.listFromJson(json[r'posts']),
        next: mapValueOfType<String>(json, r'next'),
      );
    }
    return null;
  }

  static List<CommunityFeed> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CommunityFeed>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CommunityFeed.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CommunityFeed> mapFromJson(dynamic json) {
    final map = <String, CommunityFeed>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CommunityFeed.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CommunityFeed-objects as value to a dart map
  static Map<String, List<CommunityFeed>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CommunityFeed>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CommunityFeed.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'posts',
    'next',
  };
}

