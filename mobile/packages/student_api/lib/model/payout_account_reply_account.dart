//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PayoutAccountReplyAccount {
  /// Returns a new [PayoutAccountReplyAccount] instance.
  PayoutAccountReplyAccount({
    required this.kind,
    required this.holderName,
    required this.last4,
    required this.status,
    required this.verifiedAt,
  });

  PayoutAccountReplyAccountKindEnum kind;

  String holderName;

  String last4;

  PayoutAccountReplyAccountStatusEnum status;

  DateTime? verifiedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PayoutAccountReplyAccount &&
    other.kind == kind &&
    other.holderName == holderName &&
    other.last4 == last4 &&
    other.status == status &&
    other.verifiedAt == verifiedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (kind.hashCode) +
    (holderName.hashCode) +
    (last4.hashCode) +
    (status.hashCode) +
    (verifiedAt == null ? 0 : verifiedAt!.hashCode);

  @override
  String toString() => 'PayoutAccountReplyAccount[kind=$kind, holderName=$holderName, last4=$last4, status=$status, verifiedAt=$verifiedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'kind'] = this.kind;
      json[r'holder_name'] = this.holderName;
      json[r'last4'] = this.last4;
      json[r'status'] = this.status;
    if (this.verifiedAt != null) {
      json[r'verified_at'] = this.verifiedAt!.toUtc().toIso8601String();
    } else {
      json[r'verified_at'] = null;
    }
    return json;
  }

  /// Returns a new [PayoutAccountReplyAccount] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PayoutAccountReplyAccount? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'kind'), 'Required key "PayoutAccountReplyAccount[kind]" is missing from JSON.');
        assert(json[r'kind'] != null, 'Required key "PayoutAccountReplyAccount[kind]" has a null value in JSON.');
        assert(json.containsKey(r'holder_name'), 'Required key "PayoutAccountReplyAccount[holder_name]" is missing from JSON.');
        assert(json[r'holder_name'] != null, 'Required key "PayoutAccountReplyAccount[holder_name]" has a null value in JSON.');
        assert(json.containsKey(r'last4'), 'Required key "PayoutAccountReplyAccount[last4]" is missing from JSON.');
        assert(json[r'last4'] != null, 'Required key "PayoutAccountReplyAccount[last4]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "PayoutAccountReplyAccount[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "PayoutAccountReplyAccount[status]" has a null value in JSON.');
        assert(json.containsKey(r'verified_at'), 'Required key "PayoutAccountReplyAccount[verified_at]" is missing from JSON.');
        return true;
      }());

      return PayoutAccountReplyAccount(
        kind: PayoutAccountReplyAccountKindEnum.fromJson(json[r'kind'])!,
        holderName: mapValueOfType<String>(json, r'holder_name')!,
        last4: mapValueOfType<String>(json, r'last4')!,
        status: PayoutAccountReplyAccountStatusEnum.fromJson(json[r'status'])!,
        verifiedAt: mapDateTime(json, r'verified_at', r''),
      );
    }
    return null;
  }

  static List<PayoutAccountReplyAccount> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PayoutAccountReplyAccount>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PayoutAccountReplyAccount.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PayoutAccountReplyAccount> mapFromJson(dynamic json) {
    final map = <String, PayoutAccountReplyAccount>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PayoutAccountReplyAccount.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PayoutAccountReplyAccount-objects as value to a dart map
  static Map<String, List<PayoutAccountReplyAccount>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PayoutAccountReplyAccount>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PayoutAccountReplyAccount.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'kind',
    'holder_name',
    'last4',
    'status',
    'verified_at',
  };
}


enum PayoutAccountReplyAccountKindEnum {
  upi._(r'upi'),
  bank._(r'bank'),
  ;

  /// Instantiate a new enum with the provided value.
  const PayoutAccountReplyAccountKindEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PayoutAccountReplyAccountKindEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PayoutAccountReplyAccountKindEnum? fromJson(dynamic value) => PayoutAccountReplyAccountKindEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PayoutAccountReplyAccountKindEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PayoutAccountReplyAccountKindEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PayoutAccountReplyAccountKindEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PayoutAccountReplyAccountKindEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PayoutAccountReplyAccountKindEnum] to String,
/// and [decode] dynamic data back to [PayoutAccountReplyAccountKindEnum].
class PayoutAccountReplyAccountKindEnumTypeTransformer {
  factory PayoutAccountReplyAccountKindEnumTypeTransformer() => _instance ??= const PayoutAccountReplyAccountKindEnumTypeTransformer._();

  const PayoutAccountReplyAccountKindEnumTypeTransformer._();

  String encode(PayoutAccountReplyAccountKindEnum data) => data._value;

  /// Returns the instance of [PayoutAccountReplyAccountKindEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PayoutAccountReplyAccountKindEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PayoutAccountReplyAccountKindEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'upi': return PayoutAccountReplyAccountKindEnum.upi;
        case r'bank': return PayoutAccountReplyAccountKindEnum.bank;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PayoutAccountReplyAccountKindEnumTypeTransformer? _instance;
}



enum PayoutAccountReplyAccountStatusEnum {
  pending._(r'pending'),
  verified._(r'verified'),
  failed._(r'failed'),
  ;

  /// Instantiate a new enum with the provided value.
  const PayoutAccountReplyAccountStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PayoutAccountReplyAccountStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PayoutAccountReplyAccountStatusEnum? fromJson(dynamic value) => PayoutAccountReplyAccountStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PayoutAccountReplyAccountStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PayoutAccountReplyAccountStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PayoutAccountReplyAccountStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PayoutAccountReplyAccountStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PayoutAccountReplyAccountStatusEnum] to String,
/// and [decode] dynamic data back to [PayoutAccountReplyAccountStatusEnum].
class PayoutAccountReplyAccountStatusEnumTypeTransformer {
  factory PayoutAccountReplyAccountStatusEnumTypeTransformer() => _instance ??= const PayoutAccountReplyAccountStatusEnumTypeTransformer._();

  const PayoutAccountReplyAccountStatusEnumTypeTransformer._();

  String encode(PayoutAccountReplyAccountStatusEnum data) => data._value;

  /// Returns the instance of [PayoutAccountReplyAccountStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PayoutAccountReplyAccountStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PayoutAccountReplyAccountStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'pending': return PayoutAccountReplyAccountStatusEnum.pending;
        case r'verified': return PayoutAccountReplyAccountStatusEnum.verified;
        case r'failed': return PayoutAccountReplyAccountStatusEnum.failed;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PayoutAccountReplyAccountStatusEnumTypeTransformer? _instance;
}


