//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class JobsHeaderLogosInner {
  /// Returns a new [JobsHeaderLogosInner] instance.
  JobsHeaderLogosInner({
    required this.key,
    required this.url,
  });

  JobsHeaderLogosInnerKeyEnum key;

  String url;

  @override
  bool operator ==(Object other) => identical(this, other) || other is JobsHeaderLogosInner &&
    other.key == key &&
    other.url == url;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (key.hashCode) +
    (url.hashCode);

  @override
  String toString() => 'JobsHeaderLogosInner[key=$key, url=$url]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'key'] = this.key;
      json[r'url'] = this.url;
    return json;
  }

  /// Returns a new [JobsHeaderLogosInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static JobsHeaderLogosInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'key'), 'Required key "JobsHeaderLogosInner[key]" is missing from JSON.');
        assert(json[r'key'] != null, 'Required key "JobsHeaderLogosInner[key]" has a null value in JSON.');
        assert(json.containsKey(r'url'), 'Required key "JobsHeaderLogosInner[url]" is missing from JSON.');
        assert(json[r'url'] != null, 'Required key "JobsHeaderLogosInner[url]" has a null value in JSON.');
        return true;
      }());

      return JobsHeaderLogosInner(
        key: JobsHeaderLogosInnerKeyEnum.fromJson(json[r'key'])!,
        url: mapValueOfType<String>(json, r'url')!,
      );
    }
    return null;
  }

  static List<JobsHeaderLogosInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <JobsHeaderLogosInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = JobsHeaderLogosInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, JobsHeaderLogosInner> mapFromJson(dynamic json) {
    final map = <String, JobsHeaderLogosInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = JobsHeaderLogosInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of JobsHeaderLogosInner-objects as value to a dart map
  static Map<String, List<JobsHeaderLogosInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<JobsHeaderLogosInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = JobsHeaderLogosInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'key',
    'url',
  };
}


enum JobsHeaderLogosInnerKeyEnum {
  rvm._(r'rvm'),
  campus._(r'campus'),
  ;

  /// Instantiate a new enum with the provided value.
  const JobsHeaderLogosInnerKeyEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [JobsHeaderLogosInnerKeyEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static JobsHeaderLogosInnerKeyEnum? fromJson(dynamic value) => JobsHeaderLogosInnerKeyEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [JobsHeaderLogosInnerKeyEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<JobsHeaderLogosInnerKeyEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <JobsHeaderLogosInnerKeyEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = JobsHeaderLogosInnerKeyEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [JobsHeaderLogosInnerKeyEnum] to String,
/// and [decode] dynamic data back to [JobsHeaderLogosInnerKeyEnum].
class JobsHeaderLogosInnerKeyEnumTypeTransformer {
  factory JobsHeaderLogosInnerKeyEnumTypeTransformer() => _instance ??= const JobsHeaderLogosInnerKeyEnumTypeTransformer._();

  const JobsHeaderLogosInnerKeyEnumTypeTransformer._();

  String encode(JobsHeaderLogosInnerKeyEnum data) => data._value;

  /// Returns the instance of [JobsHeaderLogosInnerKeyEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  JobsHeaderLogosInnerKeyEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is JobsHeaderLogosInnerKeyEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'rvm': return JobsHeaderLogosInnerKeyEnum.rvm;
        case r'campus': return JobsHeaderLogosInnerKeyEnum.campus;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static JobsHeaderLogosInnerKeyEnumTypeTransformer? _instance;
}


