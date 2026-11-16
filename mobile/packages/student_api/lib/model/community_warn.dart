//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CommunityWarn {
  /// Returns a new [CommunityWarn] instance.
  CommunityWarn({
    required this.reason,
    this.postId,
  });

  String reason;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? postId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CommunityWarn &&
    other.reason == reason &&
    other.postId == postId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (reason.hashCode) +
    (postId == null ? 0 : postId!.hashCode);

  @override
  String toString() => 'CommunityWarn[reason=$reason, postId=$postId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'reason'] = this.reason;
    if (this.postId != null) {
      json[r'post_id'] = this.postId;
    } else {
      json[r'post_id'] = null;
    }
    return json;
  }

  /// Returns a new [CommunityWarn] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CommunityWarn? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'reason'), 'Required key "CommunityWarn[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "CommunityWarn[reason]" has a null value in JSON.');
        return true;
      }());

      return CommunityWarn(
        reason: mapValueOfType<String>(json, r'reason')!,
        postId: mapValueOfType<String>(json, r'post_id'),
      );
    }
    return null;
  }

  static List<CommunityWarn> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CommunityWarn>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CommunityWarn.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CommunityWarn> mapFromJson(dynamic json) {
    final map = <String, CommunityWarn>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CommunityWarn.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CommunityWarn-objects as value to a dart map
  static Map<String, List<CommunityWarn>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CommunityWarn>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CommunityWarn.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'reason',
  };
}

