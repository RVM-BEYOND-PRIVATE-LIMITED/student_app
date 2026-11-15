//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Config {
  /// Returns a new [Config] instance.
  Config({
    required this.minSupportedVersion,
    required this.latestVersion,
    required this.storeUrl,
    required this.maintenance,
    required this.jobsHeader,
  });

  String minSupportedVersion;

  String latestVersion;

  /// Where the update button goes. Null until the app is in a store.
  String? storeUrl;

  ConfigMaintenance maintenance;

  JobsHeader jobsHeader;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Config &&
    other.minSupportedVersion == minSupportedVersion &&
    other.latestVersion == latestVersion &&
    other.storeUrl == storeUrl &&
    other.maintenance == maintenance &&
    other.jobsHeader == jobsHeader;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (minSupportedVersion.hashCode) +
    (latestVersion.hashCode) +
    (storeUrl == null ? 0 : storeUrl!.hashCode) +
    (maintenance.hashCode) +
    (jobsHeader.hashCode);

  @override
  String toString() => 'Config[minSupportedVersion=$minSupportedVersion, latestVersion=$latestVersion, storeUrl=$storeUrl, maintenance=$maintenance, jobsHeader=$jobsHeader]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'min_supported_version'] = this.minSupportedVersion;
      json[r'latest_version'] = this.latestVersion;
    if (this.storeUrl != null) {
      json[r'store_url'] = this.storeUrl;
    } else {
      json[r'store_url'] = null;
    }
      json[r'maintenance'] = this.maintenance;
      json[r'jobs_header'] = this.jobsHeader;
    return json;
  }

  /// Returns a new [Config] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Config? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'min_supported_version'), 'Required key "Config[min_supported_version]" is missing from JSON.');
        assert(json[r'min_supported_version'] != null, 'Required key "Config[min_supported_version]" has a null value in JSON.');
        assert(json.containsKey(r'latest_version'), 'Required key "Config[latest_version]" is missing from JSON.');
        assert(json[r'latest_version'] != null, 'Required key "Config[latest_version]" has a null value in JSON.');
        assert(json.containsKey(r'store_url'), 'Required key "Config[store_url]" is missing from JSON.');
        assert(json.containsKey(r'maintenance'), 'Required key "Config[maintenance]" is missing from JSON.');
        assert(json[r'maintenance'] != null, 'Required key "Config[maintenance]" has a null value in JSON.');
        assert(json.containsKey(r'jobs_header'), 'Required key "Config[jobs_header]" is missing from JSON.');
        assert(json[r'jobs_header'] != null, 'Required key "Config[jobs_header]" has a null value in JSON.');
        return true;
      }());

      return Config(
        minSupportedVersion: mapValueOfType<String>(json, r'min_supported_version')!,
        latestVersion: mapValueOfType<String>(json, r'latest_version')!,
        storeUrl: mapValueOfType<String>(json, r'store_url'),
        maintenance: ConfigMaintenance.fromJson(json[r'maintenance'])!,
        jobsHeader: JobsHeader.fromJson(json[r'jobs_header'])!,
      );
    }
    return null;
  }

  static List<Config> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Config>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Config.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Config> mapFromJson(dynamic json) {
    final map = <String, Config>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Config.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Config-objects as value to a dart map
  static Map<String, List<Config>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Config>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Config.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'min_supported_version',
    'latest_version',
    'store_url',
    'maintenance',
    'jobs_header',
  };
}

