//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Device {
  /// Returns a new [Device] instance.
  Device({
    required this.installId,
    required this.platform,
    this.appVersion,
    this.integrityToken,
  });

  String installId;

  DevicePlatformEnum platform;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? appVersion;

  /// Android only (0.33.0,
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? integrityToken;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Device &&
    other.installId == installId &&
    other.platform == platform &&
    other.appVersion == appVersion &&
    other.integrityToken == integrityToken;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (installId.hashCode) +
    (platform.hashCode) +
    (appVersion == null ? 0 : appVersion!.hashCode) +
    (integrityToken == null ? 0 : integrityToken!.hashCode);

  @override
  String toString() => 'Device[installId=$installId, platform=$platform, appVersion=$appVersion, integrityToken=$integrityToken]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'install_id'] = this.installId;
      json[r'platform'] = this.platform;
    if (this.appVersion != null) {
      json[r'app_version'] = this.appVersion;
    } else {
      json[r'app_version'] = null;
    }
    if (this.integrityToken != null) {
      json[r'integrity_token'] = this.integrityToken;
    } else {
      json[r'integrity_token'] = null;
    }
    return json;
  }

  /// Returns a new [Device] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Device? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'install_id'), 'Required key "Device[install_id]" is missing from JSON.');
        assert(json[r'install_id'] != null, 'Required key "Device[install_id]" has a null value in JSON.');
        assert(json.containsKey(r'platform'), 'Required key "Device[platform]" is missing from JSON.');
        assert(json[r'platform'] != null, 'Required key "Device[platform]" has a null value in JSON.');
        return true;
      }());

      return Device(
        installId: mapValueOfType<String>(json, r'install_id')!,
        platform: DevicePlatformEnum.fromJson(json[r'platform'])!,
        appVersion: mapValueOfType<String>(json, r'app_version'),
        integrityToken: mapValueOfType<String>(json, r'integrity_token'),
      );
    }
    return null;
  }

  static List<Device> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Device>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Device.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Device> mapFromJson(dynamic json) {
    final map = <String, Device>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Device.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Device-objects as value to a dart map
  static Map<String, List<Device>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Device>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Device.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'install_id',
    'platform',
  };
}


enum DevicePlatformEnum {
  android._(r'android'),
  ios._(r'ios'),
  web._(r'web'),
  ;

  /// Instantiate a new enum with the provided value.
  const DevicePlatformEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [DevicePlatformEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static DevicePlatformEnum? fromJson(dynamic value) => DevicePlatformEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [DevicePlatformEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<DevicePlatformEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DevicePlatformEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DevicePlatformEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [DevicePlatformEnum] to String,
/// and [decode] dynamic data back to [DevicePlatformEnum].
class DevicePlatformEnumTypeTransformer {
  factory DevicePlatformEnumTypeTransformer() => _instance ??= const DevicePlatformEnumTypeTransformer._();

  const DevicePlatformEnumTypeTransformer._();

  String encode(DevicePlatformEnum data) => data._value;

  /// Returns the instance of [DevicePlatformEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  DevicePlatformEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is DevicePlatformEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'android': return DevicePlatformEnum.android;
        case r'ios': return DevicePlatformEnum.ios;
        case r'web': return DevicePlatformEnum.web;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static DevicePlatformEnumTypeTransformer? _instance;
}


