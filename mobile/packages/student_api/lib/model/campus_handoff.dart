//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CampusHandoff {
  /// Returns a new [CampusHandoff] instance.
  CampusHandoff({
    required this.url,
    required this.expiresAt,
  });

  String url;

  DateTime expiresAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CampusHandoff &&
    other.url == url &&
    other.expiresAt == expiresAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (url.hashCode) +
    (expiresAt.hashCode);

  @override
  String toString() => 'CampusHandoff[url=$url, expiresAt=$expiresAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'url'] = this.url;
      json[r'expires_at'] = this.expiresAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [CampusHandoff] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CampusHandoff? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'url'), 'Required key "CampusHandoff[url]" is missing from JSON.');
        assert(json[r'url'] != null, 'Required key "CampusHandoff[url]" has a null value in JSON.');
        assert(json.containsKey(r'expires_at'), 'Required key "CampusHandoff[expires_at]" is missing from JSON.');
        assert(json[r'expires_at'] != null, 'Required key "CampusHandoff[expires_at]" has a null value in JSON.');
        return true;
      }());

      return CampusHandoff(
        url: mapValueOfType<String>(json, r'url')!,
        expiresAt: mapDateTime(json, r'expires_at', r'')!,
      );
    }
    return null;
  }

  static List<CampusHandoff> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CampusHandoff>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CampusHandoff.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CampusHandoff> mapFromJson(dynamic json) {
    final map = <String, CampusHandoff>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CampusHandoff.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CampusHandoff-objects as value to a dart map
  static Map<String, List<CampusHandoff>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CampusHandoff>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CampusHandoff.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'url',
    'expires_at',
  };
}

