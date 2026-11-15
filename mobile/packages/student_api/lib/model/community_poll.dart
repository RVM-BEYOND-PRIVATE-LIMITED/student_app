//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CommunityPoll {
  /// Returns a new [CommunityPoll] instance.
  CommunityPoll({
    required this.voteCount,
    required this.myVote,
    this.options = const [],
  });

  /// Minimum value: 0
  int voteCount;

  String? myVote;

  List<CommunityPollOption> options;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CommunityPoll &&
    other.voteCount == voteCount &&
    other.myVote == myVote &&
    _deepEquality.equals(other.options, options);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (voteCount.hashCode) +
    (myVote == null ? 0 : myVote!.hashCode) +
    (options.hashCode);

  @override
  String toString() => 'CommunityPoll[voteCount=$voteCount, myVote=$myVote, options=$options]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'vote_count'] = this.voteCount;
    if (this.myVote != null) {
      json[r'my_vote'] = this.myVote;
    } else {
      json[r'my_vote'] = null;
    }
      json[r'options'] = this.options;
    return json;
  }

  /// Returns a new [CommunityPoll] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CommunityPoll? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'vote_count'), 'Required key "CommunityPoll[vote_count]" is missing from JSON.');
        assert(json[r'vote_count'] != null, 'Required key "CommunityPoll[vote_count]" has a null value in JSON.');
        assert(json.containsKey(r'my_vote'), 'Required key "CommunityPoll[my_vote]" is missing from JSON.');
        assert(json.containsKey(r'options'), 'Required key "CommunityPoll[options]" is missing from JSON.');
        assert(json[r'options'] != null, 'Required key "CommunityPoll[options]" has a null value in JSON.');
        return true;
      }());

      return CommunityPoll(
        voteCount: mapValueOfType<int>(json, r'vote_count')!,
        myVote: mapValueOfType<String>(json, r'my_vote'),
        options: CommunityPollOption.listFromJson(json[r'options']),
      );
    }
    return null;
  }

  static List<CommunityPoll> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CommunityPoll>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CommunityPoll.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CommunityPoll> mapFromJson(dynamic json) {
    final map = <String, CommunityPoll>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CommunityPoll.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CommunityPoll-objects as value to a dart map
  static Map<String, List<CommunityPoll>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CommunityPoll>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CommunityPoll.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'vote_count',
    'my_vote',
    'options',
  };
}

