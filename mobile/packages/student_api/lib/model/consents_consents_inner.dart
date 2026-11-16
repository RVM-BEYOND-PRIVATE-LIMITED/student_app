//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ConsentsConsentsInner {
  /// Returns a new [ConsentsConsentsInner] instance.
  ConsentsConsentsInner({
    required this.purpose,
    required this.granted,
    required this.textVersion,
    required this.grantedAt,
    required this.withdrawnAt,
  });

  ConsentPurpose purpose;

  bool granted;

  int? textVersion;

  DateTime? grantedAt;

  DateTime? withdrawnAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConsentsConsentsInner &&
    other.purpose == purpose &&
    other.granted == granted &&
    other.textVersion == textVersion &&
    other.grantedAt == grantedAt &&
    other.withdrawnAt == withdrawnAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (purpose.hashCode) +
    (granted.hashCode) +
    (textVersion == null ? 0 : textVersion!.hashCode) +
    (grantedAt == null ? 0 : grantedAt!.hashCode) +
    (withdrawnAt == null ? 0 : withdrawnAt!.hashCode);

  @override
  String toString() => 'ConsentsConsentsInner[purpose=$purpose, granted=$granted, textVersion=$textVersion, grantedAt=$grantedAt, withdrawnAt=$withdrawnAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'purpose'] = this.purpose;
      json[r'granted'] = this.granted;
    if (this.textVersion != null) {
      json[r'text_version'] = this.textVersion;
    } else {
      json[r'text_version'] = null;
    }
    if (this.grantedAt != null) {
      json[r'granted_at'] = this.grantedAt!.toUtc().toIso8601String();
    } else {
      json[r'granted_at'] = null;
    }
    if (this.withdrawnAt != null) {
      json[r'withdrawn_at'] = this.withdrawnAt!.toUtc().toIso8601String();
    } else {
      json[r'withdrawn_at'] = null;
    }
    return json;
  }

  /// Returns a new [ConsentsConsentsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConsentsConsentsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'purpose'), 'Required key "ConsentsConsentsInner[purpose]" is missing from JSON.');
        assert(json[r'purpose'] != null, 'Required key "ConsentsConsentsInner[purpose]" has a null value in JSON.');
        assert(json.containsKey(r'granted'), 'Required key "ConsentsConsentsInner[granted]" is missing from JSON.');
        assert(json[r'granted'] != null, 'Required key "ConsentsConsentsInner[granted]" has a null value in JSON.');
        assert(json.containsKey(r'text_version'), 'Required key "ConsentsConsentsInner[text_version]" is missing from JSON.');
        assert(json.containsKey(r'granted_at'), 'Required key "ConsentsConsentsInner[granted_at]" is missing from JSON.');
        assert(json.containsKey(r'withdrawn_at'), 'Required key "ConsentsConsentsInner[withdrawn_at]" is missing from JSON.');
        return true;
      }());

      return ConsentsConsentsInner(
        purpose: ConsentPurpose.fromJson(json[r'purpose'])!,
        granted: mapValueOfType<bool>(json, r'granted')!,
        textVersion: mapValueOfType<int>(json, r'text_version'),
        grantedAt: mapDateTime(json, r'granted_at', r''),
        withdrawnAt: mapDateTime(json, r'withdrawn_at', r''),
      );
    }
    return null;
  }

  static List<ConsentsConsentsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConsentsConsentsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConsentsConsentsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConsentsConsentsInner> mapFromJson(dynamic json) {
    final map = <String, ConsentsConsentsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConsentsConsentsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConsentsConsentsInner-objects as value to a dart map
  static Map<String, List<ConsentsConsentsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConsentsConsentsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConsentsConsentsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'purpose',
    'granted',
    'text_version',
    'granted_at',
    'withdrawn_at',
  };
}

