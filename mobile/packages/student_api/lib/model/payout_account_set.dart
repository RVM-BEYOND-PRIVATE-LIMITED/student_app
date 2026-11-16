//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PayoutAccountSet {
  /// Returns a new [PayoutAccountSet] instance.
  PayoutAccountSet({
    required this.kind,
    this.upiId,
    this.accountNumber,
    this.ifsc,
    required this.holderName,
  });

  PayoutAccountSetKindEnum kind;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? upiId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? accountNumber;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? ifsc;

  String holderName;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PayoutAccountSet &&
    other.kind == kind &&
    other.upiId == upiId &&
    other.accountNumber == accountNumber &&
    other.ifsc == ifsc &&
    other.holderName == holderName;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (kind.hashCode) +
    (upiId == null ? 0 : upiId!.hashCode) +
    (accountNumber == null ? 0 : accountNumber!.hashCode) +
    (ifsc == null ? 0 : ifsc!.hashCode) +
    (holderName.hashCode);

  @override
  String toString() => 'PayoutAccountSet[kind=$kind, upiId=$upiId, accountNumber=$accountNumber, ifsc=$ifsc, holderName=$holderName]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'kind'] = this.kind;
    if (this.upiId != null) {
      json[r'upi_id'] = this.upiId;
    } else {
      json[r'upi_id'] = null;
    }
    if (this.accountNumber != null) {
      json[r'account_number'] = this.accountNumber;
    } else {
      json[r'account_number'] = null;
    }
    if (this.ifsc != null) {
      json[r'ifsc'] = this.ifsc;
    } else {
      json[r'ifsc'] = null;
    }
      json[r'holder_name'] = this.holderName;
    return json;
  }

  /// Returns a new [PayoutAccountSet] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PayoutAccountSet? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'kind'), 'Required key "PayoutAccountSet[kind]" is missing from JSON.');
        assert(json[r'kind'] != null, 'Required key "PayoutAccountSet[kind]" has a null value in JSON.');
        assert(json.containsKey(r'holder_name'), 'Required key "PayoutAccountSet[holder_name]" is missing from JSON.');
        assert(json[r'holder_name'] != null, 'Required key "PayoutAccountSet[holder_name]" has a null value in JSON.');
        return true;
      }());

      return PayoutAccountSet(
        kind: PayoutAccountSetKindEnum.fromJson(json[r'kind'])!,
        upiId: mapValueOfType<String>(json, r'upi_id'),
        accountNumber: mapValueOfType<String>(json, r'account_number'),
        ifsc: mapValueOfType<String>(json, r'ifsc'),
        holderName: mapValueOfType<String>(json, r'holder_name')!,
      );
    }
    return null;
  }

  static List<PayoutAccountSet> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PayoutAccountSet>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PayoutAccountSet.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PayoutAccountSet> mapFromJson(dynamic json) {
    final map = <String, PayoutAccountSet>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PayoutAccountSet.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PayoutAccountSet-objects as value to a dart map
  static Map<String, List<PayoutAccountSet>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PayoutAccountSet>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PayoutAccountSet.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'kind',
    'holder_name',
  };
}


enum PayoutAccountSetKindEnum {
  upi._(r'upi'),
  bank._(r'bank'),
  ;

  /// Instantiate a new enum with the provided value.
  const PayoutAccountSetKindEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PayoutAccountSetKindEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PayoutAccountSetKindEnum? fromJson(dynamic value) => PayoutAccountSetKindEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PayoutAccountSetKindEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PayoutAccountSetKindEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PayoutAccountSetKindEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PayoutAccountSetKindEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PayoutAccountSetKindEnum] to String,
/// and [decode] dynamic data back to [PayoutAccountSetKindEnum].
class PayoutAccountSetKindEnumTypeTransformer {
  factory PayoutAccountSetKindEnumTypeTransformer() => _instance ??= const PayoutAccountSetKindEnumTypeTransformer._();

  const PayoutAccountSetKindEnumTypeTransformer._();

  String encode(PayoutAccountSetKindEnum data) => data._value;

  /// Returns the instance of [PayoutAccountSetKindEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PayoutAccountSetKindEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PayoutAccountSetKindEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'upi': return PayoutAccountSetKindEnum.upi;
        case r'bank': return PayoutAccountSetKindEnum.bank;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PayoutAccountSetKindEnumTypeTransformer? _instance;
}


