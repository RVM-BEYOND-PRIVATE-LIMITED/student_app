//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PlaybackBeatReply {
  /// Returns a new [PlaybackBeatReply] instance.
  PlaybackBeatReply({
    required this.stop,
    required this.reason,
    required this.counted,
  });

  bool stop;

  PlaybackBeatReplyReasonEnum? reason;

  bool counted;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PlaybackBeatReply &&
    other.stop == stop &&
    other.reason == reason &&
    other.counted == counted;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (stop.hashCode) +
    (reason == null ? 0 : reason!.hashCode) +
    (counted.hashCode);

  @override
  String toString() => 'PlaybackBeatReply[stop=$stop, reason=$reason, counted=$counted]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'stop'] = this.stop;
    if (this.reason != null) {
      json[r'reason'] = this.reason;
    } else {
      json[r'reason'] = null;
    }
      json[r'counted'] = this.counted;
    return json;
  }

  /// Returns a new [PlaybackBeatReply] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PlaybackBeatReply? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'stop'), 'Required key "PlaybackBeatReply[stop]" is missing from JSON.');
        assert(json[r'stop'] != null, 'Required key "PlaybackBeatReply[stop]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "PlaybackBeatReply[reason]" is missing from JSON.');
        assert(json.containsKey(r'counted'), 'Required key "PlaybackBeatReply[counted]" is missing from JSON.');
        assert(json[r'counted'] != null, 'Required key "PlaybackBeatReply[counted]" has a null value in JSON.');
        return true;
      }());

      return PlaybackBeatReply(
        stop: mapValueOfType<bool>(json, r'stop')!,
        reason: PlaybackBeatReplyReasonEnum.fromJson(json[r'reason']),
        counted: mapValueOfType<bool>(json, r'counted')!,
      );
    }
    return null;
  }

  static List<PlaybackBeatReply> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PlaybackBeatReply>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PlaybackBeatReply.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PlaybackBeatReply> mapFromJson(dynamic json) {
    final map = <String, PlaybackBeatReply>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PlaybackBeatReply.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PlaybackBeatReply-objects as value to a dart map
  static Map<String, List<PlaybackBeatReply>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PlaybackBeatReply>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PlaybackBeatReply.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'stop',
    'reason',
    'counted',
  };
}


enum PlaybackBeatReplyReasonEnum {
  closed._(r'closed'),
  replaced._(r'replaced'),
  revoked._(r'revoked'),
  ;

  /// Instantiate a new enum with the provided value.
  const PlaybackBeatReplyReasonEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PlaybackBeatReplyReasonEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PlaybackBeatReplyReasonEnum? fromJson(dynamic value) => PlaybackBeatReplyReasonEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PlaybackBeatReplyReasonEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PlaybackBeatReplyReasonEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PlaybackBeatReplyReasonEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PlaybackBeatReplyReasonEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PlaybackBeatReplyReasonEnum] to String,
/// and [decode] dynamic data back to [PlaybackBeatReplyReasonEnum].
class PlaybackBeatReplyReasonEnumTypeTransformer {
  factory PlaybackBeatReplyReasonEnumTypeTransformer() => _instance ??= const PlaybackBeatReplyReasonEnumTypeTransformer._();

  const PlaybackBeatReplyReasonEnumTypeTransformer._();

  String encode(PlaybackBeatReplyReasonEnum data) => data._value;

  /// Returns the instance of [PlaybackBeatReplyReasonEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PlaybackBeatReplyReasonEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PlaybackBeatReplyReasonEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'closed': return PlaybackBeatReplyReasonEnum.closed;
        case r'replaced': return PlaybackBeatReplyReasonEnum.replaced;
        case r'revoked': return PlaybackBeatReplyReasonEnum.revoked;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PlaybackBeatReplyReasonEnumTypeTransformer? _instance;
}


