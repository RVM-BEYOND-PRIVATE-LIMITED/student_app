//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EnquiryReceived {
  /// Returns a new [EnquiryReceived] instance.
  EnquiryReceived({
    required this.id,
    required this.status,
  });

  String id;

  EnquiryReceivedStatusEnum status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EnquiryReceived &&
    other.id == id &&
    other.status == status;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (status.hashCode);

  @override
  String toString() => 'EnquiryReceived[id=$id, status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'status'] = this.status;
    return json;
  }

  /// Returns a new [EnquiryReceived] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EnquiryReceived? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "EnquiryReceived[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "EnquiryReceived[id]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "EnquiryReceived[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "EnquiryReceived[status]" has a null value in JSON.');
        return true;
      }());

      return EnquiryReceived(
        id: mapValueOfType<String>(json, r'id')!,
        status: EnquiryReceivedStatusEnum.fromJson(json[r'status'])!,
      );
    }
    return null;
  }

  static List<EnquiryReceived> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EnquiryReceived>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EnquiryReceived.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EnquiryReceived> mapFromJson(dynamic json) {
    final map = <String, EnquiryReceived>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EnquiryReceived.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EnquiryReceived-objects as value to a dart map
  static Map<String, List<EnquiryReceived>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EnquiryReceived>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EnquiryReceived.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'status',
  };
}


enum EnquiryReceivedStatusEnum {
  received._(r'received'),
  ;

  /// Instantiate a new enum with the provided value.
  const EnquiryReceivedStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [EnquiryReceivedStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static EnquiryReceivedStatusEnum? fromJson(dynamic value) => EnquiryReceivedStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [EnquiryReceivedStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<EnquiryReceivedStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EnquiryReceivedStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EnquiryReceivedStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [EnquiryReceivedStatusEnum] to String,
/// and [decode] dynamic data back to [EnquiryReceivedStatusEnum].
class EnquiryReceivedStatusEnumTypeTransformer {
  factory EnquiryReceivedStatusEnumTypeTransformer() => _instance ??= const EnquiryReceivedStatusEnumTypeTransformer._();

  const EnquiryReceivedStatusEnumTypeTransformer._();

  String encode(EnquiryReceivedStatusEnum data) => data._value;

  /// Returns the instance of [EnquiryReceivedStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  EnquiryReceivedStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is EnquiryReceivedStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'received': return EnquiryReceivedStatusEnum.received;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static EnquiryReceivedStatusEnumTypeTransformer? _instance;
}


