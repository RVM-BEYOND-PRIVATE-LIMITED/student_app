//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PaymentOrderCreated {
  /// Returns a new [PaymentOrderCreated] instance.
  PaymentOrderCreated({
    required this.id,
    required this.purpose,
    required this.amountPaise,
    required this.mode,
    required this.status,
    required this.checkout,
  });

  String id;

  PaymentOrderCreatedPurposeEnum purpose;

  /// Minimum value: 1
  int amountPaise;

  PaymentOrderCreatedModeEnum mode;

  PaymentOrderCreatedStatusEnum status;

  PaymentOrderCreatedCheckout? checkout;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PaymentOrderCreated &&
    other.id == id &&
    other.purpose == purpose &&
    other.amountPaise == amountPaise &&
    other.mode == mode &&
    other.status == status &&
    other.checkout == checkout;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (purpose.hashCode) +
    (amountPaise.hashCode) +
    (mode.hashCode) +
    (status.hashCode) +
    (checkout == null ? 0 : checkout!.hashCode);

  @override
  String toString() => 'PaymentOrderCreated[id=$id, purpose=$purpose, amountPaise=$amountPaise, mode=$mode, status=$status, checkout=$checkout]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'purpose'] = this.purpose;
      json[r'amount_paise'] = this.amountPaise;
      json[r'mode'] = this.mode;
      json[r'status'] = this.status;
    if (this.checkout != null) {
      json[r'checkout'] = this.checkout;
    } else {
      json[r'checkout'] = null;
    }
    return json;
  }

  /// Returns a new [PaymentOrderCreated] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PaymentOrderCreated? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "PaymentOrderCreated[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "PaymentOrderCreated[id]" has a null value in JSON.');
        assert(json.containsKey(r'purpose'), 'Required key "PaymentOrderCreated[purpose]" is missing from JSON.');
        assert(json[r'purpose'] != null, 'Required key "PaymentOrderCreated[purpose]" has a null value in JSON.');
        assert(json.containsKey(r'amount_paise'), 'Required key "PaymentOrderCreated[amount_paise]" is missing from JSON.');
        assert(json[r'amount_paise'] != null, 'Required key "PaymentOrderCreated[amount_paise]" has a null value in JSON.');
        assert(json.containsKey(r'mode'), 'Required key "PaymentOrderCreated[mode]" is missing from JSON.');
        assert(json[r'mode'] != null, 'Required key "PaymentOrderCreated[mode]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "PaymentOrderCreated[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "PaymentOrderCreated[status]" has a null value in JSON.');
        assert(json.containsKey(r'checkout'), 'Required key "PaymentOrderCreated[checkout]" is missing from JSON.');
        return true;
      }());

      return PaymentOrderCreated(
        id: mapValueOfType<String>(json, r'id')!,
        purpose: PaymentOrderCreatedPurposeEnum.fromJson(json[r'purpose'])!,
        amountPaise: mapValueOfType<int>(json, r'amount_paise')!,
        mode: PaymentOrderCreatedModeEnum.fromJson(json[r'mode'])!,
        status: PaymentOrderCreatedStatusEnum.fromJson(json[r'status'])!,
        checkout: PaymentOrderCreatedCheckout.fromJson(json[r'checkout']),
      );
    }
    return null;
  }

  static List<PaymentOrderCreated> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentOrderCreated>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentOrderCreated.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PaymentOrderCreated> mapFromJson(dynamic json) {
    final map = <String, PaymentOrderCreated>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PaymentOrderCreated.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PaymentOrderCreated-objects as value to a dart map
  static Map<String, List<PaymentOrderCreated>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PaymentOrderCreated>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PaymentOrderCreated.listFromJson(entry.value, growable: growable,);
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
    'checkout',
  };
}


enum PaymentOrderCreatedPurposeEnum {
  joining._(r'joining'),
  instalment._(r'instalment'),
  balance._(r'balance'),
  ;

  /// Instantiate a new enum with the provided value.
  const PaymentOrderCreatedPurposeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PaymentOrderCreatedPurposeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PaymentOrderCreatedPurposeEnum? fromJson(dynamic value) => PaymentOrderCreatedPurposeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PaymentOrderCreatedPurposeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PaymentOrderCreatedPurposeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentOrderCreatedPurposeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentOrderCreatedPurposeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PaymentOrderCreatedPurposeEnum] to String,
/// and [decode] dynamic data back to [PaymentOrderCreatedPurposeEnum].
class PaymentOrderCreatedPurposeEnumTypeTransformer {
  factory PaymentOrderCreatedPurposeEnumTypeTransformer() => _instance ??= const PaymentOrderCreatedPurposeEnumTypeTransformer._();

  const PaymentOrderCreatedPurposeEnumTypeTransformer._();

  String encode(PaymentOrderCreatedPurposeEnum data) => data._value;

  /// Returns the instance of [PaymentOrderCreatedPurposeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PaymentOrderCreatedPurposeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PaymentOrderCreatedPurposeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'joining': return PaymentOrderCreatedPurposeEnum.joining;
        case r'instalment': return PaymentOrderCreatedPurposeEnum.instalment;
        case r'balance': return PaymentOrderCreatedPurposeEnum.balance;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PaymentOrderCreatedPurposeEnumTypeTransformer? _instance;
}



enum PaymentOrderCreatedModeEnum {
  dryRun._(r'dry_run'),
  live._(r'live'),
  ;

  /// Instantiate a new enum with the provided value.
  const PaymentOrderCreatedModeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PaymentOrderCreatedModeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PaymentOrderCreatedModeEnum? fromJson(dynamic value) => PaymentOrderCreatedModeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PaymentOrderCreatedModeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PaymentOrderCreatedModeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentOrderCreatedModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentOrderCreatedModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PaymentOrderCreatedModeEnum] to String,
/// and [decode] dynamic data back to [PaymentOrderCreatedModeEnum].
class PaymentOrderCreatedModeEnumTypeTransformer {
  factory PaymentOrderCreatedModeEnumTypeTransformer() => _instance ??= const PaymentOrderCreatedModeEnumTypeTransformer._();

  const PaymentOrderCreatedModeEnumTypeTransformer._();

  String encode(PaymentOrderCreatedModeEnum data) => data._value;

  /// Returns the instance of [PaymentOrderCreatedModeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PaymentOrderCreatedModeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PaymentOrderCreatedModeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'dry_run': return PaymentOrderCreatedModeEnum.dryRun;
        case r'live': return PaymentOrderCreatedModeEnum.live;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PaymentOrderCreatedModeEnumTypeTransformer? _instance;
}



enum PaymentOrderCreatedStatusEnum {
  created._(r'created'),
  ;

  /// Instantiate a new enum with the provided value.
  const PaymentOrderCreatedStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PaymentOrderCreatedStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PaymentOrderCreatedStatusEnum? fromJson(dynamic value) => PaymentOrderCreatedStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PaymentOrderCreatedStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PaymentOrderCreatedStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentOrderCreatedStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentOrderCreatedStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PaymentOrderCreatedStatusEnum] to String,
/// and [decode] dynamic data back to [PaymentOrderCreatedStatusEnum].
class PaymentOrderCreatedStatusEnumTypeTransformer {
  factory PaymentOrderCreatedStatusEnumTypeTransformer() => _instance ??= const PaymentOrderCreatedStatusEnumTypeTransformer._();

  const PaymentOrderCreatedStatusEnumTypeTransformer._();

  String encode(PaymentOrderCreatedStatusEnum data) => data._value;

  /// Returns the instance of [PaymentOrderCreatedStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PaymentOrderCreatedStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PaymentOrderCreatedStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'created': return PaymentOrderCreatedStatusEnum.created;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PaymentOrderCreatedStatusEnumTypeTransformer? _instance;
}


