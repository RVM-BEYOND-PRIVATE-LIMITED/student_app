//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CommunityPollOption {
  /// Returns a new [CommunityPollOption] instance.
  CommunityPollOption({
    required this.id,
    required this.label,
    required this.voteCount,
  });

  String id;

  String label;

  /// Minimum value: 0
  int voteCount;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CommunityPollOption &&
    other.id == id &&
    other.label == label &&
    other.voteCount == voteCount;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (label.hashCode) +
    (voteCount.hashCode);

  @override
  String toString() => 'CommunityPollOption[id=$id, label=$label, voteCount=$voteCount]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'label'] = this.label;
      json[r'vote_count'] = this.voteCount;
    return json;
  }

  /// Returns a new [CommunityPollOption] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CommunityPollOption? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "CommunityPollOption[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "CommunityPollOption[id]" has a null value in JSON.');
        assert(json.containsKey(r'label'), 'Required key "CommunityPollOption[label]" is missing from JSON.');
        assert(json[r'label'] != null, 'Required key "CommunityPollOption[label]" has a null value in JSON.');
        assert(json.containsKey(r'vote_count'), 'Required key "CommunityPollOption[vote_count]" is missing from JSON.');
        assert(json[r'vote_count'] != null, 'Required key "CommunityPollOption[vote_count]" has a null value in JSON.');
        return true;
      }());

      return CommunityPollOption(
        id: mapValueOfType<String>(json, r'id')!,
        label: mapValueOfType<String>(json, r'label')!,
        voteCount: mapValueOfType<int>(json, r'vote_count')!,
      );
    }
    return null;
  }

  static List<CommunityPollOption> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CommunityPollOption>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CommunityPollOption.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CommunityPollOption> mapFromJson(dynamic json) {
    final map = <String, CommunityPollOption>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CommunityPollOption.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CommunityPollOption-objects as value to a dart map
  static Map<String, List<CommunityPollOption>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CommunityPollOption>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CommunityPollOption.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'label',
    'vote_count',
  };
}

