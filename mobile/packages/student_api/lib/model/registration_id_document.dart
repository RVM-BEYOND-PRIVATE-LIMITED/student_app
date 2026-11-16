//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RegistrationIdDocument {
  /// Returns a new [RegistrationIdDocument] instance.
  RegistrationIdDocument({
    required this.idType,
    required this.last4,
    required this.uploadedAt,
  });

  String idType;

  String last4;

  DateTime uploadedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RegistrationIdDocument &&
    other.idType == idType &&
    other.last4 == last4 &&
    other.uploadedAt == uploadedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (idType.hashCode) +
    (last4.hashCode) +
    (uploadedAt.hashCode);

  @override
  String toString() => 'RegistrationIdDocument[idType=$idType, last4=$last4, uploadedAt=$uploadedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id_type'] = this.idType;
      json[r'last4'] = this.last4;
      json[r'uploaded_at'] = this.uploadedAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [RegistrationIdDocument] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RegistrationIdDocument? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id_type'), 'Required key "RegistrationIdDocument[id_type]" is missing from JSON.');
        assert(json[r'id_type'] != null, 'Required key "RegistrationIdDocument[id_type]" has a null value in JSON.');
        assert(json.containsKey(r'last4'), 'Required key "RegistrationIdDocument[last4]" is missing from JSON.');
        assert(json[r'last4'] != null, 'Required key "RegistrationIdDocument[last4]" has a null value in JSON.');
        assert(json.containsKey(r'uploaded_at'), 'Required key "RegistrationIdDocument[uploaded_at]" is missing from JSON.');
        assert(json[r'uploaded_at'] != null, 'Required key "RegistrationIdDocument[uploaded_at]" has a null value in JSON.');
        return true;
      }());

      return RegistrationIdDocument(
        idType: mapValueOfType<String>(json, r'id_type')!,
        last4: mapValueOfType<String>(json, r'last4')!,
        uploadedAt: mapDateTime(json, r'uploaded_at', r'')!,
      );
    }
    return null;
  }

  static List<RegistrationIdDocument> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RegistrationIdDocument>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RegistrationIdDocument.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RegistrationIdDocument> mapFromJson(dynamic json) {
    final map = <String, RegistrationIdDocument>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RegistrationIdDocument.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RegistrationIdDocument-objects as value to a dart map
  static Map<String, List<RegistrationIdDocument>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RegistrationIdDocument>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RegistrationIdDocument.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id_type',
    'last4',
    'uploaded_at',
  };
}

