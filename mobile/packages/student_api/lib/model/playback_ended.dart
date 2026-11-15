//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PlaybackEnded {
  /// Returns a new [PlaybackEnded] instance.
  PlaybackEnded({
    required this.sessionId,
    required this.ended,
    required this.counted,
  });

  String sessionId;

  bool ended;

  bool counted;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PlaybackEnded &&
    other.sessionId == sessionId &&
    other.ended == ended &&
    other.counted == counted;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (sessionId.hashCode) +
    (ended.hashCode) +
    (counted.hashCode);

  @override
  String toString() => 'PlaybackEnded[sessionId=$sessionId, ended=$ended, counted=$counted]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'session_id'] = this.sessionId;
      json[r'ended'] = this.ended;
      json[r'counted'] = this.counted;
    return json;
  }

  /// Returns a new [PlaybackEnded] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PlaybackEnded? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'session_id'), 'Required key "PlaybackEnded[session_id]" is missing from JSON.');
        assert(json[r'session_id'] != null, 'Required key "PlaybackEnded[session_id]" has a null value in JSON.');
        assert(json.containsKey(r'ended'), 'Required key "PlaybackEnded[ended]" is missing from JSON.');
        assert(json[r'ended'] != null, 'Required key "PlaybackEnded[ended]" has a null value in JSON.');
        assert(json.containsKey(r'counted'), 'Required key "PlaybackEnded[counted]" is missing from JSON.');
        assert(json[r'counted'] != null, 'Required key "PlaybackEnded[counted]" has a null value in JSON.');
        return true;
      }());

      return PlaybackEnded(
        sessionId: mapValueOfType<String>(json, r'session_id')!,
        ended: mapValueOfType<bool>(json, r'ended')!,
        counted: mapValueOfType<bool>(json, r'counted')!,
      );
    }
    return null;
  }

  static List<PlaybackEnded> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PlaybackEnded>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PlaybackEnded.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PlaybackEnded> mapFromJson(dynamic json) {
    final map = <String, PlaybackEnded>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PlaybackEnded.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PlaybackEnded-objects as value to a dart map
  static Map<String, List<PlaybackEnded>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PlaybackEnded>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PlaybackEnded.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'session_id',
    'ended',
    'counted',
  };
}

