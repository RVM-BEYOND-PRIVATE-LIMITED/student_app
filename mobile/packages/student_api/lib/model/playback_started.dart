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
    this.provider,
    this.streamUrl,
    this.watermarkText,
    required this.otp,
    required this.playbackInfo,
    required this.heartbeatSeconds,
    required this.resumed,
    required this.viewsLeft,
    required this.expiresIn,
    required this.lastPositionS,
  });

  String sessionId;

  PlaybackStartedProviderEnum? provider;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? streamUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? watermarkText;

  String? otp;

  String? playbackInfo;

  /// Minimum value: 5
  int heartbeatSeconds;

  bool resumed;

  /// Minimum value: 0
  int viewsLeft;

  /// Minimum value: 1
  int expiresIn;

  /// Where the student last stopped this video (0.38.0,
  ///
  /// Minimum value: 0
  int? lastPositionS;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PlaybackStarted &&
    other.sessionId == sessionId &&
    other.provider == provider &&
    other.streamUrl == streamUrl &&
    other.watermarkText == watermarkText &&
    other.otp == otp &&
    other.playbackInfo == playbackInfo &&
    other.heartbeatSeconds == heartbeatSeconds &&
    other.resumed == resumed &&
    other.viewsLeft == viewsLeft &&
    other.expiresIn == expiresIn &&
    other.lastPositionS == lastPositionS;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (sessionId.hashCode) +
    (provider == null ? 0 : provider!.hashCode) +
    (streamUrl == null ? 0 : streamUrl!.hashCode) +
    (watermarkText == null ? 0 : watermarkText!.hashCode) +
    (otp == null ? 0 : otp!.hashCode) +
    (playbackInfo == null ? 0 : playbackInfo!.hashCode) +
    (heartbeatSeconds.hashCode) +
    (resumed.hashCode) +
    (viewsLeft.hashCode) +
    (expiresIn.hashCode) +
    (lastPositionS == null ? 0 : lastPositionS!.hashCode);

  @override
  String toString() => 'PlaybackStarted[sessionId=$sessionId, provider=$provider, streamUrl=$streamUrl, watermarkText=$watermarkText, otp=$otp, playbackInfo=$playbackInfo, heartbeatSeconds=$heartbeatSeconds, resumed=$resumed, viewsLeft=$viewsLeft, expiresIn=$expiresIn, lastPositionS=$lastPositionS]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'session_id'] = this.sessionId;
    if (this.provider != null) {
      json[r'provider'] = this.provider;
    } else {
      json[r'provider'] = null;
    }
    if (this.streamUrl != null) {
      json[r'stream_url'] = this.streamUrl;
    } else {
      json[r'stream_url'] = null;
    }
    if (this.watermarkText != null) {
      json[r'watermark_text'] = this.watermarkText;
    } else {
      json[r'watermark_text'] = null;
    }
    if (this.otp != null) {
      json[r'otp'] = this.otp;
    } else {
      json[r'otp'] = null;
    }
    if (this.playbackInfo != null) {
      json[r'playback_info'] = this.playbackInfo;
    } else {
      json[r'playback_info'] = null;
    }
      json[r'heartbeat_seconds'] = this.heartbeatSeconds;
      json[r'resumed'] = this.resumed;
      json[r'views_left'] = this.viewsLeft;
      json[r'expires_in'] = this.expiresIn;
    if (this.lastPositionS != null) {
      json[r'last_position_s'] = this.lastPositionS;
    } else {
      json[r'last_position_s'] = null;
    }
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
        assert(json.containsKey(r'playback_info'), 'Required key "PlaybackStarted[playback_info]" is missing from JSON.');
        assert(json.containsKey(r'heartbeat_seconds'), 'Required key "PlaybackStarted[heartbeat_seconds]" is missing from JSON.');
        assert(json[r'heartbeat_seconds'] != null, 'Required key "PlaybackStarted[heartbeat_seconds]" has a null value in JSON.');
        assert(json.containsKey(r'resumed'), 'Required key "PlaybackStarted[resumed]" is missing from JSON.');
        assert(json[r'resumed'] != null, 'Required key "PlaybackStarted[resumed]" has a null value in JSON.');
        assert(json.containsKey(r'views_left'), 'Required key "PlaybackStarted[views_left]" is missing from JSON.');
        assert(json[r'views_left'] != null, 'Required key "PlaybackStarted[views_left]" has a null value in JSON.');
        assert(json.containsKey(r'expires_in'), 'Required key "PlaybackStarted[expires_in]" is missing from JSON.');
        assert(json[r'expires_in'] != null, 'Required key "PlaybackStarted[expires_in]" has a null value in JSON.');
        assert(json.containsKey(r'last_position_s'), 'Required key "PlaybackStarted[last_position_s]" is missing from JSON.');
        return true;
      }());

      return PlaybackStarted(
        sessionId: mapValueOfType<String>(json, r'session_id')!,
        provider: PlaybackStartedProviderEnum.fromJson(json[r'provider']),
        streamUrl: mapValueOfType<String>(json, r'stream_url'),
        watermarkText: mapValueOfType<String>(json, r'watermark_text'),
        otp: mapValueOfType<String>(json, r'otp'),
        playbackInfo: mapValueOfType<String>(json, r'playback_info'),
        heartbeatSeconds: mapValueOfType<int>(json, r'heartbeat_seconds')!,
        resumed: mapValueOfType<bool>(json, r'resumed')!,
        viewsLeft: mapValueOfType<int>(json, r'views_left')!,
        expiresIn: mapValueOfType<int>(json, r'expires_in')!,
        lastPositionS: mapValueOfType<int>(json, r'last_position_s'),
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
    'last_position_s',
  };
}


enum PlaybackStartedProviderEnum {
  self._(r'self'),
  vdocipher._(r'vdocipher'),
  ;

  /// Instantiate a new enum with the provided value.
  const PlaybackStartedProviderEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PlaybackStartedProviderEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PlaybackStartedProviderEnum? fromJson(dynamic value) => PlaybackStartedProviderEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PlaybackStartedProviderEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PlaybackStartedProviderEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PlaybackStartedProviderEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PlaybackStartedProviderEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PlaybackStartedProviderEnum] to String,
/// and [decode] dynamic data back to [PlaybackStartedProviderEnum].
class PlaybackStartedProviderEnumTypeTransformer {
  factory PlaybackStartedProviderEnumTypeTransformer() => _instance ??= const PlaybackStartedProviderEnumTypeTransformer._();

  const PlaybackStartedProviderEnumTypeTransformer._();

  String encode(PlaybackStartedProviderEnum data) => data._value;

  /// Returns the instance of [PlaybackStartedProviderEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PlaybackStartedProviderEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PlaybackStartedProviderEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'self': return PlaybackStartedProviderEnum.self;
        case r'vdocipher': return PlaybackStartedProviderEnum.vdocipher;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PlaybackStartedProviderEnumTypeTransformer? _instance;
}


