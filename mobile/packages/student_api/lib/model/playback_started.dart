//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PlaybackStarted {
  /// Returns a new [PlaybackStarted] instance.
  PlaybackStarted({
    required this.sessionId,
    required this.otp,
    required this.playbackInfo,
    required this.heartbeatSeconds,
    required this.resumed,
    required this.viewsLeft,
    required this.expiresIn,
  });

  String sessionId;

  String otp;

  String playbackInfo;

  /// Minimum value: 5
  int heartbeatSeconds;

  bool resumed;

  /// Minimum value: 0
  int viewsLeft;

  /// Minimum value: 1
  int expiresIn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PlaybackStarted &&
    other.sessionId == sessionId &&
    other.otp == otp &&
    other.playbackInfo == playbackInfo &&
    other.heartbeatSeconds == heartbeatSeconds &&
    other.resumed == resumed &&
    other.viewsLeft == viewsLeft &&
    other.expiresIn == expiresIn;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (sessionId.hashCode) +
    (otp.hashCode) +
    (playbackInfo.hashCode) +
    (heartbeatSeconds.hashCode) +
    (resumed.hashCode) +
    (viewsLeft.hashCode) +
    (expiresIn.hashCode);

  @override
  String toString() => 'PlaybackStarted[sessionId=$sessionId, otp=$otp, playbackInfo=$playbackInfo, heartbeatSeconds=$heartbeatSeconds, resumed=$resumed, viewsLeft=$viewsLeft, expiresIn=$expiresIn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'session_id'] = this.sessionId;
      json[r'otp'] = this.otp;
      json[r'playback_info'] = this.playbackInfo;
      json[r'heartbeat_seconds'] = this.heartbeatSeconds;
      json[r'resumed'] = this.resumed;
      json[r'views_left'] = this.viewsLeft;
      json[r'expires_in'] = this.expiresIn;
    return json;
  }

  /// Returns a new [PlaybackStarted] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PlaybackStarted? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'session_id'), 'Required key "PlaybackStarted[session_id]" is missing from JSON.');
        assert(json[r'session_id'] != null, 'Required key "PlaybackStarted[session_id]" has a null value in JSON.');
        assert(json.containsKey(r'otp'), 'Required key "PlaybackStarted[otp]" is missing from JSON.');
        assert(json[r'otp'] != null, 'Required key "PlaybackStarted[otp]" has a null value in JSON.');
        assert(json.containsKey(r'playback_info'), 'Required key "PlaybackStarted[playback_info]" is missing from JSON.');
        assert(json[r'playback_info'] != null, 'Required key "PlaybackStarted[playback_info]" has a null value in JSON.');
        assert(json.containsKey(r'heartbeat_seconds'), 'Required key "PlaybackStarted[heartbeat_seconds]" is missing from JSON.');
        assert(json[r'heartbeat_seconds'] != null, 'Required key "PlaybackStarted[heartbeat_seconds]" has a null value in JSON.');
        assert(json.containsKey(r'resumed'), 'Required key "PlaybackStarted[resumed]" is missing from JSON.');
        assert(json[r'resumed'] != null, 'Required key "PlaybackStarted[resumed]" has a null value in JSON.');
        assert(json.containsKey(r'views_left'), 'Required key "PlaybackStarted[views_left]" is missing from JSON.');
        assert(json[r'views_left'] != null, 'Required key "PlaybackStarted[views_left]" has a null value in JSON.');
        assert(json.containsKey(r'expires_in'), 'Required key "PlaybackStarted[expires_in]" is missing from JSON.');
        assert(json[r'expires_in'] != null, 'Required key "PlaybackStarted[expires_in]" has a null value in JSON.');
        return true;
      }());

      return PlaybackStarted(
        sessionId: mapValueOfType<String>(json, r'session_id')!,
        otp: mapValueOfType<String>(json, r'otp')!,
        playbackInfo: mapValueOfType<String>(json, r'playback_info')!,
        heartbeatSeconds: mapValueOfType<int>(json, r'heartbeat_seconds')!,
        resumed: mapValueOfType<bool>(json, r'resumed')!,
        viewsLeft: mapValueOfType<int>(json, r'views_left')!,
        expiresIn: mapValueOfType<int>(json, r'expires_in')!,
      );
    }
    return null;
  }

  static List<PlaybackStarted> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PlaybackStarted>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PlaybackStarted.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PlaybackStarted> mapFromJson(dynamic json) {
    final map = <String, PlaybackStarted>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PlaybackStarted.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PlaybackStarted-objects as value to a dart map
  static Map<String, List<PlaybackStarted>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PlaybackStarted>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PlaybackStarted.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'session_id',
    'otp',
    'playback_info',
    'heartbeat_seconds',
    'resumed',
    'views_left',
    'expires_in',
  };
}

