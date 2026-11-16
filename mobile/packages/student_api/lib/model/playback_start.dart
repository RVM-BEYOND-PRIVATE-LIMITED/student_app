//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PlaybackStart {
  /// Returns a new [PlaybackStart] instance.
  PlaybackStart({
    required this.videoId,
  });

  String videoId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PlaybackStart &&
    other.videoId == videoId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (videoId.hashCode);

  @override
  String toString() => 'PlaybackStart[videoId=$videoId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'video_id'] = this.videoId;
    return json;
  }

  /// Returns a new [PlaybackStart] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PlaybackStart? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'video_id'), 'Required key "PlaybackStart[video_id]" is missing from JSON.');
        assert(json[r'video_id'] != null, 'Required key "PlaybackStart[video_id]" has a null value in JSON.');
        return true;
      }());

      return PlaybackStart(
        videoId: mapValueOfType<String>(json, r'video_id')!,
      );
    }
    return null;
  }

  static List<PlaybackStart> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PlaybackStart>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PlaybackStart.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PlaybackStart> mapFromJson(dynamic json) {
    final map = <String, PlaybackStart>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PlaybackStart.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PlaybackStart-objects as value to a dart map
  static Map<String, List<PlaybackStart>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PlaybackStart>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PlaybackStart.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'video_id',
  };
}

