//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PaymentOrder {
  /// Returns a new [PaymentOrder] instance.
  PaymentOrder({
    required this.id,
    required this.purpose,
    required this.amountPaise,
    required this.mode,
    required this.status,
    required this.paid,
    required this.createdAt,
  });

  String id;

  PaymentOrderPurposeEnum purpose;

  /// Minimum value: 1
  int amountPaise;

  PaymentOrderModeEnum mode;

  PaymentOrderStatusEnum status;

  bool paid;

  DateTime createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PaymentOrder &&
    other.id == id &&
    other.purpose == purpose &&
    other.amountPaise == amountPaise &&
    other.mode == mode &&
    other.status == status &&
    other.paid == paid &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (purpose.hashCode) +
    (amountPaise.hashCode) +
    (mode.hashCode) +
    (status.hashCode) +
    (paid.hashCode) +
    (createdAt.hashCode);

  @override
  String toString() => 'PaymentOrder[id=$id, purpose=$purpose, amountPaise=$amountPaise, mode=$mode, status=$status, paid=$paid, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'purpose'] = this.purpose;
      json[r'amount_paise'] = this.amountPaise;
      json[r'mode'] = this.mode;
      json[r'status'] = this.status;
      json[r'paid'] = this.paid;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [PaymentOrder] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PaymentOrder? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "PaymentOrder[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "PaymentOrder[id]" has a null value in JSON.');
        assert(json.containsKey(r'purpose'), 'Required key "PaymentOrder[purpose]" is missing from JSON.');
        assert(json[r'purpose'] != null, 'Required key "PaymentOrder[purpose]" has a null value in JSON.');
        assert(json.containsKey(r'amount_paise'), 'Required key "PaymentOrder[amount_paise]" is missing from JSON.');
        assert(json[r'amount_paise'] != null, 'Required key "PaymentOrder[amount_paise]" has a null value in JSON.');
        assert(json.containsKey(r'mode'), 'Required key "PaymentOrder[mode]" is missing from JSON.');
        assert(json[r'mode'] != null, 'Required key "PaymentOrder[mode]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "PaymentOrder[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "PaymentOrder[status]" has a null value in JSON.');
        assert(json.containsKey(r'paid'), 'Required key "PaymentOrder[paid]" is missing from JSON.');
        assert(json[r'paid'] != null, 'Required key "PaymentOrder[paid]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'), 'Required key "PaymentOrder[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null, 'Required key "PaymentOrder[created_at]" has a null value in JSON.');
        return true;
      }());

      return PaymentOrder(
        id: mapValueOfType<String>(json, r'id')!,
        purpose: PaymentOrderPurposeEnum.fromJson(json[r'purpose'])!,
        amountPaise: mapValueOfType<int>(json, r'amount_paise')!,
        mode: PaymentOrderModeEnum.fromJson(json[r'mode'])!,
        status: PaymentOrderStatusEnum.fromJson(json[r'status'])!,
        paid: mapValueOfType<bool>(json, r'paid')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
      );
    }
    return null;
  }

  static List<PaymentOrder> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentOrder>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentOrder.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PaymentOrder> mapFromJson(dynamic json) {
    final map = <String, PaymentOrder>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PaymentOrder.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PaymentOrder-objects as value to a dart map
  static Map<String, List<PaymentOrder>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PaymentOrder>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PaymentOrder.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'purpose',
    'amount_paise',
    'mode',
    'status',
    'paid',
    'created_at',
  };
}


enum PaymentOrderPurposeEnum {
  joining._(r'joining'),
  instalment._(r'instalment'),
  balance._(r'balance'),
  ;

  /// Instantiate a new enum with the provided value.
  const PaymentOrderPurposeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PaymentOrderPurposeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PaymentOrderPurposeEnum? fromJson(dynamic value) => PaymentOrderPurposeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PaymentOrderPurposeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PaymentOrderPurposeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentOrderPurposeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentOrderPurposeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PaymentOrderPurposeEnum] to String,
/// and [decode] dynamic data back to [PaymentOrderPurposeEnum].
class PaymentOrderPurposeEnumTypeTransformer {
  factory PaymentOrderPurposeEnumTypeTransformer() => _instance ??= const PaymentOrderPurposeEnumTypeTransformer._();

  const PaymentOrderPurposeEnumTypeTransformer._();

  String encode(PaymentOrderPurposeEnum data) => data._value;

  /// Returns the instance of [PaymentOrderPurposeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PaymentOrderPurposeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PaymentOrderPurposeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'joining': return PaymentOrderPurposeEnum.joining;
        case r'instalment': return PaymentOrderPurposeEnum.instalment;
        case r'balance': return PaymentOrderPurposeEnum.balance;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PaymentOrderPurposeEnumTypeTransformer? _instance;
}



enum PaymentOrderModeEnum {
  dryRun._(r'dry_run'),
  live._(r'live'),
  ;

  /// Instantiate a new enum with the provided value.
  const PaymentOrderModeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PaymentOrderModeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PaymentOrderModeEnum? fromJson(dynamic value) => PaymentOrderModeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PaymentOrderModeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PaymentOrderModeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentOrderModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentOrderModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PaymentOrderModeEnum] to String,
/// and [decode] dynamic data back to [PaymentOrderModeEnum].
class PaymentOrderModeEnumTypeTransformer {
  factory PaymentOrderModeEnumTypeTransformer() => _instance ??= const PaymentOrderModeEnumTypeTransformer._();

  const PaymentOrderModeEnumTypeTransformer._();

  String encode(PaymentOrderModeEnum data) => data._value;

  /// Returns the instance of [PaymentOrderModeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PaymentOrderModeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PaymentOrderModeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'dry_run': return PaymentOrderModeEnum.dryRun;
        case r'live': return PaymentOrderModeEnum.live;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PaymentOrderModeEnumTypeTransformer? _instance;
}



enum PaymentOrderStatusEnum {
  created._(r'created'),
  receipted._(r'receipted'),
  failed._(r'failed'),
  capturedUnreceipted._(r'captured_unreceipted'),
  refunded._(r'refunded'),
  ;

  /// Instantiate a new enum with the provided value.
  const PaymentOrderStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PaymentOrderStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PaymentOrderStatusEnum? fromJson(dynamic value) => PaymentOrderStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PaymentOrderStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PaymentOrderStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentOrderStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentOrderStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PaymentOrderStatusEnum] to String,
/// and [decode] dynamic data back to [PaymentOrderStatusEnum].
class PaymentOrderStatusEnumTypeTransformer {
  factory PaymentOrderStatusEnumTypeTransformer() => _instance ??= const PaymentOrderStatusEnumTypeTransformer._();

  const PaymentOrderStatusEnumTypeTransformer._();

  String encode(PaymentOrderStatusEnum data) => data._value;

  /// Returns the instance of [PaymentOrderStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PaymentOrderStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PaymentOrderStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'created': return PaymentOrderStatusEnum.created;
        case r'receipted': return PaymentOrderStatusEnum.receipted;
        case r'failed': return PaymentOrderStatusEnum.failed;
        case r'captured_unreceipted': return PaymentOrderStatusEnum.capturedUnreceipted;
        case r'refunded': return PaymentOrderStatusEnum.refunded;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PaymentOrderStatusEnumTypeTransformer? _instance;
}


