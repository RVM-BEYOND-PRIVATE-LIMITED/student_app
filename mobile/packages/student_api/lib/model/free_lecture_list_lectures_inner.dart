//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FreeLectureListLecturesInner {
  /// Returns a new [FreeLectureListLecturesInner] instance.
  FreeLectureListLecturesInner({
    required this.id,
    required this.topic,
    required this.title,
    required this.description,
    required this.videoYoutubeId,
    required this.durationMinutes,
    required this.watched,
  });

  String id;

  String topic;

  String title;

  String? description;

  String videoYoutubeId;

  int? durationMinutes;

  bool watched;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FreeLectureListLecturesInner &&
    other.id == id &&
    other.topic == topic &&
    other.title == title &&
    other.description == description &&
    other.videoYoutubeId == videoYoutubeId &&
    other.durationMinutes == durationMinutes &&
    other.watched == watched;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (topic.hashCode) +
    (title.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (videoYoutubeId.hashCode) +
    (durationMinutes == null ? 0 : durationMinutes!.hashCode) +
    (watched.hashCode);

  @override
  String toString() => 'FreeLectureListLecturesInner[id=$id, topic=$topic, title=$title, description=$description, videoYoutubeId=$videoYoutubeId, durationMinutes=$durationMinutes, watched=$watched]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'topic'] = this.topic;
      json[r'title'] = this.title;
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
      json[r'video_youtube_id'] = this.videoYoutubeId;
    if (this.durationMinutes != null) {
      json[r'duration_minutes'] = this.durationMinutes;
    } else {
      json[r'duration_minutes'] = null;
    }
      json[r'watched'] = this.watched;
    return json;
  }

  /// Returns a new [FreeLectureListLecturesInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FreeLectureListLecturesInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "FreeLectureListLecturesInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "FreeLectureListLecturesInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'topic'), 'Required key "FreeLectureListLecturesInner[topic]" is missing from JSON.');
        assert(json[r'topic'] != null, 'Required key "FreeLectureListLecturesInner[topic]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "FreeLectureListLecturesInner[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "FreeLectureListLecturesInner[title]" has a null value in JSON.');
        assert(json.containsKey(r'description'), 'Required key "FreeLectureListLecturesInner[description]" is missing from JSON.');
        assert(json.containsKey(r'video_youtube_id'), 'Required key "FreeLectureListLecturesInner[video_youtube_id]" is missing from JSON.');
        assert(json[r'video_youtube_id'] != null, 'Required key "FreeLectureListLecturesInner[video_youtube_id]" has a null value in JSON.');
        assert(json.containsKey(r'duration_minutes'), 'Required key "FreeLectureListLecturesInner[duration_minutes]" is missing from JSON.');
        assert(json.containsKey(r'watched'), 'Required key "FreeLectureListLecturesInner[watched]" is missing from JSON.');
        assert(json[r'watched'] != null, 'Required key "FreeLectureListLecturesInner[watched]" has a null value in JSON.');
        return true;
      }());

      return FreeLectureListLecturesInner(
        id: mapValueOfType<String>(json, r'id')!,
        topic: mapValueOfType<String>(json, r'topic')!,
        title: mapValueOfType<String>(json, r'title')!,
        description: mapValueOfType<String>(json, r'description'),
        videoYoutubeId: mapValueOfType<String>(json, r'video_youtube_id')!,
        durationMinutes: mapValueOfType<int>(json, r'duration_minutes'),
        watched: mapValueOfType<bool>(json, r'watched')!,
      );
    }
    return null;
  }

  static List<FreeLectureListLecturesInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FreeLectureListLecturesInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FreeLectureListLecturesInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FreeLectureListLecturesInner> mapFromJson(dynamic json) {
    final map = <String, FreeLectureListLecturesInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FreeLectureListLecturesInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FreeLectureListLecturesInner-objects as value to a dart map
  static Map<String, List<FreeLectureListLecturesInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FreeLectureListLecturesInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FreeLectureListLecturesInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'topic',
    'title',
    'description',
    'video_youtube_id',
    'duration_minutes',
    'watched',
  };
}

