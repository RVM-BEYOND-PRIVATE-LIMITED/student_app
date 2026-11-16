//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class VideoLibraryVideosInner {
  /// Returns a new [VideoLibraryVideosInner] instance.
  VideoLibraryVideosInner({
    required this.id,
    required this.kind,
    required this.title,
    required this.course,
    required this.moduleName,
    required this.batchId,
    required this.durationS,
    required this.viewsLeft,
    required this.lockedReason,
  });

  String id;

  VideoLibraryVideosInnerKindEnum kind;

  String title;

  VideoLibraryVideosInnerCourse? course;

  String? moduleName;

  String? batchId;

  int? durationS;

  /// Minimum value: 0
  int viewsLeft;

  VideoLibraryVideosInnerLockedReasonEnum? lockedReason;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VideoLibraryVideosInner &&
    other.id == id &&
    other.kind == kind &&
    other.title == title &&
    other.course == course &&
    other.moduleName == moduleName &&
    other.batchId == batchId &&
    other.durationS == durationS &&
    other.viewsLeft == viewsLeft &&
    other.lockedReason == lockedReason;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (kind.hashCode) +
    (title.hashCode) +
    (course == null ? 0 : course!.hashCode) +
    (moduleName == null ? 0 : moduleName!.hashCode) +
    (batchId == null ? 0 : batchId!.hashCode) +
    (durationS == null ? 0 : durationS!.hashCode) +
    (viewsLeft.hashCode) +
    (lockedReason == null ? 0 : lockedReason!.hashCode);

  @override
  String toString() => 'VideoLibraryVideosInner[id=$id, kind=$kind, title=$title, course=$course, moduleName=$moduleName, batchId=$batchId, durationS=$durationS, viewsLeft=$viewsLeft, lockedReason=$lockedReason]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'kind'] = this.kind;
      json[r'title'] = this.title;
    if (this.course != null) {
      json[r'course'] = this.course;
    } else {
      json[r'course'] = null;
    }
    if (this.moduleName != null) {
      json[r'module_name'] = this.moduleName;
    } else {
      json[r'module_name'] = null;
    }
    if (this.batchId != null) {
      json[r'batch_id'] = this.batchId;
    } else {
      json[r'batch_id'] = null;
    }
    if (this.durationS != null) {
      json[r'duration_s'] = this.durationS;
    } else {
      json[r'duration_s'] = null;
    }
      json[r'views_left'] = this.viewsLeft;
    if (this.lockedReason != null) {
      json[r'locked_reason'] = this.lockedReason;
    } else {
      json[r'locked_reason'] = null;
    }
    return json;
  }

  /// Returns a new [VideoLibraryVideosInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static VideoLibraryVideosInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "VideoLibraryVideosInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "VideoLibraryVideosInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'kind'), 'Required key "VideoLibraryVideosInner[kind]" is missing from JSON.');
        assert(json[r'kind'] != null, 'Required key "VideoLibraryVideosInner[kind]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "VideoLibraryVideosInner[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "VideoLibraryVideosInner[title]" has a null value in JSON.');
        assert(json.containsKey(r'course'), 'Required key "VideoLibraryVideosInner[course]" is missing from JSON.');
        assert(json.containsKey(r'module_name'), 'Required key "VideoLibraryVideosInner[module_name]" is missing from JSON.');
        assert(json.containsKey(r'batch_id'), 'Required key "VideoLibraryVideosInner[batch_id]" is missing from JSON.');
        assert(json.containsKey(r'duration_s'), 'Required key "VideoLibraryVideosInner[duration_s]" is missing from JSON.');
        assert(json.containsKey(r'views_left'), 'Required key "VideoLibraryVideosInner[views_left]" is missing from JSON.');
        assert(json[r'views_left'] != null, 'Required key "VideoLibraryVideosInner[views_left]" has a null value in JSON.');
        assert(json.containsKey(r'locked_reason'), 'Required key "VideoLibraryVideosInner[locked_reason]" is missing from JSON.');
        return true;
      }());

      return VideoLibraryVideosInner(
        id: mapValueOfType<String>(json, r'id')!,
        kind: VideoLibraryVideosInnerKindEnum.fromJson(json[r'kind'])!,
        title: mapValueOfType<String>(json, r'title')!,
        course: VideoLibraryVideosInnerCourse.fromJson(json[r'course']),
        moduleName: mapValueOfType<String>(json, r'module_name'),
        batchId: mapValueOfType<String>(json, r'batch_id'),
        durationS: mapValueOfType<int>(json, r'duration_s'),
        viewsLeft: mapValueOfType<int>(json, r'views_left')!,
        lockedReason: VideoLibraryVideosInnerLockedReasonEnum.fromJson(json[r'locked_reason']),
      );
    }
    return null;
  }

  static List<VideoLibraryVideosInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VideoLibraryVideosInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VideoLibraryVideosInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VideoLibraryVideosInner> mapFromJson(dynamic json) {
    final map = <String, VideoLibraryVideosInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = VideoLibraryVideosInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VideoLibraryVideosInner-objects as value to a dart map
  static Map<String, List<VideoLibraryVideosInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VideoLibraryVideosInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VideoLibraryVideosInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'kind',
    'title',
    'course',
    'module_name',
    'batch_id',
    'duration_s',
    'views_left',
    'locked_reason',
  };
}


enum VideoLibraryVideosInnerKindEnum {
  course._(r'course'),
  classRecording._(r'class_recording'),
  ;

  /// Instantiate a new enum with the provided value.
  const VideoLibraryVideosInnerKindEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [VideoLibraryVideosInnerKindEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static VideoLibraryVideosInnerKindEnum? fromJson(dynamic value) => VideoLibraryVideosInnerKindEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [VideoLibraryVideosInnerKindEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<VideoLibraryVideosInnerKindEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VideoLibraryVideosInnerKindEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VideoLibraryVideosInnerKindEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [VideoLibraryVideosInnerKindEnum] to String,
/// and [decode] dynamic data back to [VideoLibraryVideosInnerKindEnum].
class VideoLibraryVideosInnerKindEnumTypeTransformer {
  factory VideoLibraryVideosInnerKindEnumTypeTransformer() => _instance ??= const VideoLibraryVideosInnerKindEnumTypeTransformer._();

  const VideoLibraryVideosInnerKindEnumTypeTransformer._();

  String encode(VideoLibraryVideosInnerKindEnum data) => data._value;

  /// Returns the instance of [VideoLibraryVideosInnerKindEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  VideoLibraryVideosInnerKindEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is VideoLibraryVideosInnerKindEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'course': return VideoLibraryVideosInnerKindEnum.course;
        case r'class_recording': return VideoLibraryVideosInnerKindEnum.classRecording;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static VideoLibraryVideosInnerKindEnumTypeTransformer? _instance;
}



enum VideoLibraryVideosInnerLockedReasonEnum {
  FEE_PENDING._(r'FEE_PENDING'),
  NOT_YOUR_COURSE._(r'NOT_YOUR_COURSE'),
  ACCESS_ENDED._(r'ACCESS_ENDED'),
  NO_VIEWS_LEFT._(r'NO_VIEWS_LEFT'),
  NOT_LINKED._(r'NOT_LINKED'),
  ;

  /// Instantiate a new enum with the provided value.
  const VideoLibraryVideosInnerLockedReasonEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [VideoLibraryVideosInnerLockedReasonEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static VideoLibraryVideosInnerLockedReasonEnum? fromJson(dynamic value) => VideoLibraryVideosInnerLockedReasonEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [VideoLibraryVideosInnerLockedReasonEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<VideoLibraryVideosInnerLockedReasonEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VideoLibraryVideosInnerLockedReasonEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VideoLibraryVideosInnerLockedReasonEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [VideoLibraryVideosInnerLockedReasonEnum] to String,
/// and [decode] dynamic data back to [VideoLibraryVideosInnerLockedReasonEnum].
class VideoLibraryVideosInnerLockedReasonEnumTypeTransformer {
  factory VideoLibraryVideosInnerLockedReasonEnumTypeTransformer() => _instance ??= const VideoLibraryVideosInnerLockedReasonEnumTypeTransformer._();

  const VideoLibraryVideosInnerLockedReasonEnumTypeTransformer._();

  String encode(VideoLibraryVideosInnerLockedReasonEnum data) => data._value;

  /// Returns the instance of [VideoLibraryVideosInnerLockedReasonEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  VideoLibraryVideosInnerLockedReasonEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is VideoLibraryVideosInnerLockedReasonEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'FEE_PENDING': return VideoLibraryVideosInnerLockedReasonEnum.FEE_PENDING;
        case r'NOT_YOUR_COURSE': return VideoLibraryVideosInnerLockedReasonEnum.NOT_YOUR_COURSE;
        case r'ACCESS_ENDED': return VideoLibraryVideosInnerLockedReasonEnum.ACCESS_ENDED;
        case r'NO_VIEWS_LEFT': return VideoLibraryVideosInnerLockedReasonEnum.NO_VIEWS_LEFT;
        case r'NOT_LINKED': return VideoLibraryVideosInnerLockedReasonEnum.NOT_LINKED;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static VideoLibraryVideosInnerLockedReasonEnumTypeTransformer? _instance;
}


