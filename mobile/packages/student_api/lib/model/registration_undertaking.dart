//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RegistrationUndertaking {
  /// Returns a new [RegistrationUndertaking] instance.
  RegistrationUndertaking({
    required this.version,
    required this.videoStartedAt,
    required this.videoCompletedAt,
    this.termsAccepted = const [],
  });

  int? version;

  DateTime? videoStartedAt;

  DateTime? videoCompletedAt;

  List<String> termsAccepted;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RegistrationUndertaking &&
    other.version == version &&
    other.videoStartedAt == videoStartedAt &&
    other.videoCompletedAt == videoCompletedAt &&
    _deepEquality.equals(other.termsAccepted, termsAccepted);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (version == null ? 0 : version!.hashCode) +
    (videoStartedAt == null ? 0 : videoStartedAt!.hashCode) +
    (videoCompletedAt == null ? 0 : videoCompletedAt!.hashCode) +
    (termsAccepted.hashCode);

  @override
  String toString() => 'RegistrationUndertaking[version=$version, videoStartedAt=$videoStartedAt, videoCompletedAt=$videoCompletedAt, termsAccepted=$termsAccepted]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.version != null) {
      json[r'version'] = this.version;
    } else {
      json[r'version'] = null;
    }
    if (this.videoStartedAt != null) {
      json[r'video_started_at'] = this.videoStartedAt!.toUtc().toIso8601String();
    } else {
      json[r'video_started_at'] = null;
    }
    if (this.videoCompletedAt != null) {
      json[r'video_completed_at'] = this.videoCompletedAt!.toUtc().toIso8601String();
    } else {
      json[r'video_completed_at'] = null;
    }
      json[r'terms_accepted'] = this.termsAccepted;
    return json;
  }

  /// Returns a new [RegistrationUndertaking] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RegistrationUndertaking? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'version'), 'Required key "RegistrationUndertaking[version]" is missing from JSON.');
        assert(json.containsKey(r'video_started_at'), 'Required key "RegistrationUndertaking[video_started_at]" is missing from JSON.');
        assert(json.containsKey(r'video_completed_at'), 'Required key "RegistrationUndertaking[video_completed_at]" is missing from JSON.');
        assert(json.containsKey(r'terms_accepted'), 'Required key "RegistrationUndertaking[terms_accepted]" is missing from JSON.');
        assert(json[r'terms_accepted'] != null, 'Required key "RegistrationUndertaking[terms_accepted]" has a null value in JSON.');
        return true;
      }());

      return RegistrationUndertaking(
        version: mapValueOfType<int>(json, r'version'),
        videoStartedAt: mapDateTime(json, r'video_started_at', r''),
        videoCompletedAt: mapDateTime(json, r'video_completed_at', r''),
        termsAccepted: json[r'terms_accepted'] is Iterable
            ? (json[r'terms_accepted'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<RegistrationUndertaking> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RegistrationUndertaking>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RegistrationUndertaking.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RegistrationUndertaking> mapFromJson(dynamic json) {
    final map = <String, RegistrationUndertaking>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RegistrationUndertaking.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RegistrationUndertaking-objects as value to a dart map
  static Map<String, List<RegistrationUndertaking>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RegistrationUndertaking>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RegistrationUndertaking.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'version',
    'video_started_at',
    'video_completed_at',
    'terms_accepted',
  };
}

