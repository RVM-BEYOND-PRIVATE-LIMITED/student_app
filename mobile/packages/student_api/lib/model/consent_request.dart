//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ConsentRequest {
  /// Returns a new [ConsentRequest] instance.
  ConsentRequest({
    required this.id,
    required this.companyName,
    required this.jobTitle,
    required this.question,
    required this.textVersion,
    required this.status,
    required this.expiresAt,
  });

  String id;

  String companyName;

  String jobTitle;

  String question;

  /// Minimum value: 1
  int textVersion;

  ConsentRequestStatusEnum status;

  DateTime expiresAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConsentRequest &&
    other.id == id &&
    other.companyName == companyName &&
    other.jobTitle == jobTitle &&
    other.question == question &&
    other.textVersion == textVersion &&
    other.status == status &&
    other.expiresAt == expiresAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (companyName.hashCode) +
    (jobTitle.hashCode) +
    (question.hashCode) +
    (textVersion.hashCode) +
    (status.hashCode) +
    (expiresAt.hashCode);

  @override
  String toString() => 'ConsentRequest[id=$id, companyName=$companyName, jobTitle=$jobTitle, question=$question, textVersion=$textVersion, status=$status, expiresAt=$expiresAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'company_name'] = this.companyName;
      json[r'job_title'] = this.jobTitle;
      json[r'question'] = this.question;
      json[r'text_version'] = this.textVersion;
      json[r'status'] = this.status;
      json[r'expires_at'] = this.expiresAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [ConsentRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConsentRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ConsentRequest[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ConsentRequest[id]" has a null value in JSON.');
        assert(json.containsKey(r'company_name'), 'Required key "ConsentRequest[company_name]" is missing from JSON.');
        assert(json[r'company_name'] != null, 'Required key "ConsentRequest[company_name]" has a null value in JSON.');
        assert(json.containsKey(r'job_title'), 'Required key "ConsentRequest[job_title]" is missing from JSON.');
        assert(json[r'job_title'] != null, 'Required key "ConsentRequest[job_title]" has a null value in JSON.');
        assert(json.containsKey(r'question'), 'Required key "ConsentRequest[question]" is missing from JSON.');
        assert(json[r'question'] != null, 'Required key "ConsentRequest[question]" has a null value in JSON.');
        assert(json.containsKey(r'text_version'), 'Required key "ConsentRequest[text_version]" is missing from JSON.');
        assert(json[r'text_version'] != null, 'Required key "ConsentRequest[text_version]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "ConsentRequest[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "ConsentRequest[status]" has a null value in JSON.');
        assert(json.containsKey(r'expires_at'), 'Required key "ConsentRequest[expires_at]" is missing from JSON.');
        assert(json[r'expires_at'] != null, 'Required key "ConsentRequest[expires_at]" has a null value in JSON.');
        return true;
      }());

      return ConsentRequest(
        id: mapValueOfType<String>(json, r'id')!,
        companyName: mapValueOfType<String>(json, r'company_name')!,
        jobTitle: mapValueOfType<String>(json, r'job_title')!,
        question: mapValueOfType<String>(json, r'question')!,
        textVersion: mapValueOfType<int>(json, r'text_version')!,
        status: ConsentRequestStatusEnum.fromJson(json[r'status'])!,
        expiresAt: mapDateTime(json, r'expires_at', r'')!,
      );
    }
    return null;
  }

  static List<ConsentRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConsentRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConsentRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConsentRequest> mapFromJson(dynamic json) {
    final map = <String, ConsentRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConsentRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConsentRequest-objects as value to a dart map
  static Map<String, List<ConsentRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConsentRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConsentRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'company_name',
    'job_title',
    'question',
    'text_version',
    'status',
    'expires_at',
  };
}


enum ConsentRequestStatusEnum {
  pending._(r'pending'),
  yes._(r'yes'),
  no._(r'no'),
  expired._(r'expired'),
  ;

  /// Instantiate a new enum with the provided value.
  const ConsentRequestStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ConsentRequestStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ConsentRequestStatusEnum? fromJson(dynamic value) => ConsentRequestStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ConsentRequestStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ConsentRequestStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConsentRequestStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConsentRequestStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ConsentRequestStatusEnum] to String,
/// and [decode] dynamic data back to [ConsentRequestStatusEnum].
class ConsentRequestStatusEnumTypeTransformer {
  factory ConsentRequestStatusEnumTypeTransformer() => _instance ??= const ConsentRequestStatusEnumTypeTransformer._();

  const ConsentRequestStatusEnumTypeTransformer._();

  String encode(ConsentRequestStatusEnum data) => data._value;

  /// Returns the instance of [ConsentRequestStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ConsentRequestStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ConsentRequestStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'pending': return ConsentRequestStatusEnum.pending;
        case r'yes': return ConsentRequestStatusEnum.yes;
        case r'no': return ConsentRequestStatusEnum.no;
        case r'expired': return ConsentRequestStatusEnum.expired;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ConsentRequestStatusEnumTypeTransformer? _instance;
}


