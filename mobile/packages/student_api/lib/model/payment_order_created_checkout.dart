//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PaymentOrderCreatedCheckout {
  /// Returns a new [PaymentOrderCreatedCheckout] instance.
  PaymentOrderCreatedCheckout({
    required this.keyId,
    required this.razorpayOrderId,
    required this.amountPaise,
    required this.currency,
  });

  String keyId;

  String razorpayOrderId;

  int amountPaise;

  PaymentOrderCreatedCheckoutCurrencyEnum currency;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PaymentOrderCreatedCheckout &&
    other.keyId == keyId &&
    other.razorpayOrderId == razorpayOrderId &&
    other.amountPaise == amountPaise &&
    other.currency == currency;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (keyId.hashCode) +
    (razorpayOrderId.hashCode) +
    (amountPaise.hashCode) +
    (currency.hashCode);

  @override
  String toString() => 'PaymentOrderCreatedCheckout[keyId=$keyId, razorpayOrderId=$razorpayOrderId, amountPaise=$amountPaise, currency=$currency]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'key_id'] = this.keyId;
      json[r'razorpay_order_id'] = this.razorpayOrderId;
      json[r'amount_paise'] = this.amountPaise;
      json[r'currency'] = this.currency;
    return json;
  }

  /// Returns a new [PaymentOrderCreatedCheckout] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PaymentOrderCreatedCheckout? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'key_id'), 'Required key "PaymentOrderCreatedCheckout[key_id]" is missing from JSON.');
        assert(json[r'key_id'] != null, 'Required key "PaymentOrderCreatedCheckout[key_id]" has a null value in JSON.');
        assert(json.containsKey(r'razorpay_order_id'), 'Required key "PaymentOrderCreatedCheckout[razorpay_order_id]" is missing from JSON.');
        assert(json[r'razorpay_order_id'] != null, 'Required key "PaymentOrderCreatedCheckout[razorpay_order_id]" has a null value in JSON.');
        assert(json.containsKey(r'amount_paise'), 'Required key "PaymentOrderCreatedCheckout[amount_paise]" is missing from JSON.');
        assert(json[r'amount_paise'] != null, 'Required key "PaymentOrderCreatedCheckout[amount_paise]" has a null value in JSON.');
        assert(json.containsKey(r'currency'), 'Required key "PaymentOrderCreatedCheckout[currency]" is missing from JSON.');
        assert(json[r'currency'] != null, 'Required key "PaymentOrderCreatedCheckout[currency]" has a null value in JSON.');
        return true;
      }());

      return PaymentOrderCreatedCheckout(
        keyId: mapValueOfType<String>(json, r'key_id')!,
        razorpayOrderId: mapValueOfType<String>(json, r'razorpay_order_id')!,
        amountPaise: mapValueOfType<int>(json, r'amount_paise')!,
        currency: PaymentOrderCreatedCheckoutCurrencyEnum.fromJson(json[r'currency'])!,
      );
    }
    return null;
  }

  static List<PaymentOrderCreatedCheckout> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentOrderCreatedCheckout>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentOrderCreatedCheckout.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PaymentOrderCreatedCheckout> mapFromJson(dynamic json) {
    final map = <String, PaymentOrderCreatedCheckout>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PaymentOrderCreatedCheckout.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PaymentOrderCreatedCheckout-objects as value to a dart map
  static Map<String, List<PaymentOrderCreatedCheckout>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PaymentOrderCreatedCheckout>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PaymentOrderCreatedCheckout.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'key_id',
    'razorpay_order_id',
    'amount_paise',
    'currency',
  };
}


enum PaymentOrderCreatedCheckoutCurrencyEnum {
  INR._(r'INR'),
  ;

  /// Instantiate a new enum with the provided value.
  const PaymentOrderCreatedCheckoutCurrencyEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PaymentOrderCreatedCheckoutCurrencyEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PaymentOrderCreatedCheckoutCurrencyEnum? fromJson(dynamic value) => PaymentOrderCreatedCheckoutCurrencyEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PaymentOrderCreatedCheckoutCurrencyEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PaymentOrderCreatedCheckoutCurrencyEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentOrderCreatedCheckoutCurrencyEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentOrderCreatedCheckoutCurrencyEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PaymentOrderCreatedCheckoutCurrencyEnum] to String,
/// and [decode] dynamic data back to [PaymentOrderCreatedCheckoutCurrencyEnum].
class PaymentOrderCreatedCheckoutCurrencyEnumTypeTransformer {
  factory PaymentOrderCreatedCheckoutCurrencyEnumTypeTransformer() => _instance ??= const PaymentOrderCreatedCheckoutCurrencyEnumTypeTransformer._();

  const PaymentOrderCreatedCheckoutCurrencyEnumTypeTransformer._();

  String encode(PaymentOrderCreatedCheckoutCurrencyEnum data) => data._value;

  /// Returns the instance of [PaymentOrderCreatedCheckoutCurrencyEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PaymentOrderCreatedCheckoutCurrencyEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PaymentOrderCreatedCheckoutCurrencyEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'INR': return PaymentOrderCreatedCheckoutCurrencyEnum.INR;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PaymentOrderCreatedCheckoutCurrencyEnumTypeTransformer? _instance;
}


