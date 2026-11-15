//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UndertakingVideo {
  /// Returns a new [UndertakingVideo] instance.
  UndertakingVideo({
    required this.youtubeId,
    required this.seconds,
  });

  String youtubeId;

  int? seconds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UndertakingVideo &&
    other.youtubeId == youtubeId &&
    other.seconds == seconds;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (youtubeId.hashCode) +
    (seconds == null ? 0 : seconds!.hashCode);

  @override
  String toString() => 'UndertakingVideo[youtubeId=$youtubeId, seconds=$seconds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'youtube_id'] = this.youtubeId;
    if (this.seconds != null) {
      json[r'seconds'] = this.seconds;
    } else {
      json[r'seconds'] = null;
    }
    return json;
  }

  /// Returns a new [UndertakingVideo] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UndertakingVideo? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'youtube_id'), 'Required key "UndertakingVideo[youtube_id]" is missing from JSON.');
        assert(json[r'youtube_id'] != null, 'Required key "UndertakingVideo[youtube_id]" has a null value in JSON.');
        assert(json.containsKey(r'seconds'), 'Required key "UndertakingVideo[seconds]" is missing from JSON.');
        return true;
      }());

      return UndertakingVideo(
        youtubeId: mapValueOfType<String>(json, r'youtube_id')!,
        seconds: mapValueOfType<int>(json, r'seconds'),
      );
    }
    return null;
  }

  static List<UndertakingVideo> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UndertakingVideo>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UndertakingVideo.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UndertakingVideo> mapFromJson(dynamic json) {
    final map = <String, UndertakingVideo>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UndertakingVideo.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UndertakingVideo-objects as value to a dart map
  static Map<String, List<UndertakingVideo>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UndertakingVideo>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UndertakingVideo.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'youtube_id',
    'seconds',
  };
}

