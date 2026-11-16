//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CommunityReaction {
  /// Returns a new [CommunityReaction] instance.
  CommunityReaction({
    required this.reacted,
    required this.reactionCount,
  });

  bool reacted;

  /// Minimum value: 0
  int reactionCount;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CommunityReaction &&
    other.reacted == reacted &&
    other.reactionCount == reactionCount;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (reacted.hashCode) +
    (reactionCount.hashCode);

  @override
  String toString() => 'CommunityReaction[reacted=$reacted, reactionCount=$reactionCount]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'reacted'] = this.reacted;
      json[r'reaction_count'] = this.reactionCount;
    return json;
  }

  /// Returns a new [CommunityReaction] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CommunityReaction? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'reacted'), 'Required key "CommunityReaction[reacted]" is missing from JSON.');
        assert(json[r'reacted'] != null, 'Required key "CommunityReaction[reacted]" has a null value in JSON.');
        assert(json.containsKey(r'reaction_count'), 'Required key "CommunityReaction[reaction_count]" is missing from JSON.');
        assert(json[r'reaction_count'] != null, 'Required key "CommunityReaction[reaction_count]" has a null value in JSON.');
        return true;
      }());

      return CommunityReaction(
        reacted: mapValueOfType<bool>(json, r'reacted')!,
        reactionCount: mapValueOfType<int>(json, r'reaction_count')!,
      );
    }
    return null;
  }

  static List<CommunityReaction> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CommunityReaction>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CommunityReaction.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CommunityReaction> mapFromJson(dynamic json) {
    final map = <String, CommunityReaction>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CommunityReaction.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CommunityReaction-objects as value to a dart map
  static Map<String, List<CommunityReaction>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CommunityReaction>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CommunityReaction.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'reacted',
    'reaction_count',
  };
}

