//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PlacementPrompt {
  /// Returns a new [PlacementPrompt] instance.
  PlacementPrompt({
    required this.id,
    required this.companyName,
    required this.jobTitle,
    required this.status,
    required this.receivedAt,
  });

  String id;

  String companyName;

  String jobTitle;

  PlacementPromptStatusEnum status;

  DateTime receivedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PlacementPrompt &&
    other.id == id &&
    other.companyName == companyName &&
    other.jobTitle == jobTitle &&
    other.status == status &&
    other.receivedAt == receivedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (companyName.hashCode) +
    (jobTitle.hashCode) +
    (status.hashCode) +
    (receivedAt.hashCode);

  @override
  String toString() => 'PlacementPrompt[id=$id, companyName=$companyName, jobTitle=$jobTitle, status=$status, receivedAt=$receivedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'company_name'] = this.companyName;
      json[r'job_title'] = this.jobTitle;
      json[r'status'] = this.status;
      json[r'received_at'] = this.receivedAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [PlacementPrompt] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PlacementPrompt? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "PlacementPrompt[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "PlacementPrompt[id]" has a null value in JSON.');
        assert(json.containsKey(r'company_name'), 'Required key "PlacementPrompt[company_name]" is missing from JSON.');
        assert(json[r'company_name'] != null, 'Required key "PlacementPrompt[company_name]" has a null value in JSON.');
        assert(json.containsKey(r'job_title'), 'Required key "PlacementPrompt[job_title]" is missing from JSON.');
        assert(json[r'job_title'] != null, 'Required key "PlacementPrompt[job_title]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "PlacementPrompt[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "PlacementPrompt[status]" has a null value in JSON.');
        assert(json.containsKey(r'received_at'), 'Required key "PlacementPrompt[received_at]" is missing from JSON.');
        assert(json[r'received_at'] != null, 'Required key "PlacementPrompt[received_at]" has a null value in JSON.');
        return true;
      }());

      return PlacementPrompt(
        id: mapValueOfType<String>(json, r'id')!,
        companyName: mapValueOfType<String>(json, r'company_name')!,
        jobTitle: mapValueOfType<String>(json, r'job_title')!,
        status: PlacementPromptStatusEnum.fromJson(json[r'status'])!,
        receivedAt: mapDateTime(json, r'received_at', r'')!,
      );
    }
    return null;
  }

  static List<PlacementPrompt> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PlacementPrompt>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PlacementPrompt.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PlacementPrompt> mapFromJson(dynamic json) {
    final map = <String, PlacementPrompt>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PlacementPrompt.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PlacementPrompt-objects as value to a dart map
  static Map<String, List<PlacementPrompt>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PlacementPrompt>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PlacementPrompt.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'company_name',
    'job_title',
    'status',
    'received_at',
  };
}


enum PlacementPromptStatusEnum {
  open._(r'open'),
  dismissed._(r'dismissed'),
  done._(r'done'),
  ;

  /// Instantiate a new enum with the provided value.
  const PlacementPromptStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PlacementPromptStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PlacementPromptStatusEnum? fromJson(dynamic value) => PlacementPromptStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PlacementPromptStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PlacementPromptStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PlacementPromptStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PlacementPromptStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PlacementPromptStatusEnum] to String,
/// and [decode] dynamic data back to [PlacementPromptStatusEnum].
class PlacementPromptStatusEnumTypeTransformer {
  factory PlacementPromptStatusEnumTypeTransformer() => _instance ??= const PlacementPromptStatusEnumTypeTransformer._();

  const PlacementPromptStatusEnumTypeTransformer._();

  String encode(PlacementPromptStatusEnum data) => data._value;

  /// Returns the instance of [PlacementPromptStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PlacementPromptStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PlacementPromptStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'open': return PlacementPromptStatusEnum.open;
        case r'dismissed': return PlacementPromptStatusEnum.dismissed;
        case r'done': return PlacementPromptStatusEnum.done;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PlacementPromptStatusEnumTypeTransformer? _instance;
}


