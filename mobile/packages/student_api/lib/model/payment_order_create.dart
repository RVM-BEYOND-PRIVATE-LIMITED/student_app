//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PaymentOrderCreate {
  /// Returns a new [PaymentOrderCreate] instance.
  PaymentOrderCreate({
    required this.purpose,
    this.amountPaise,
    this.dueDate,
    required this.acceptNonRefundable,
    required this.textVersion,
  });

  PaymentOrderCreatePurposeEnum purpose;

  /// Joining only; ignored otherwise.
  ///
  /// Minimum value: 1
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? amountPaise;

  /// Instalment only.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? dueDate;

  PaymentOrderCreateAcceptNonRefundableEnum acceptNonRefundable;

  /// Minimum value: 1
  int textVersion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PaymentOrderCreate &&
    other.purpose == purpose &&
    other.amountPaise == amountPaise &&
    other.dueDate == dueDate &&
    other.acceptNonRefundable == acceptNonRefundable &&
    other.textVersion == textVersion;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (purpose.hashCode) +
    (amountPaise == null ? 0 : amountPaise!.hashCode) +
    (dueDate == null ? 0 : dueDate!.hashCode) +
    (acceptNonRefundable.hashCode) +
    (textVersion.hashCode);

  @override
  String toString() => 'PaymentOrderCreate[purpose=$purpose, amountPaise=$amountPaise, dueDate=$dueDate, acceptNonRefundable=$acceptNonRefundable, textVersion=$textVersion]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'purpose'] = this.purpose;
    if (this.amountPaise != null) {
      json[r'amount_paise'] = this.amountPaise;
    } else {
      json[r'amount_paise'] = null;
    }
    if (this.dueDate != null) {
      json[r'due_date'] = _dateFormatter.format(this.dueDate!);
    } else {
      json[r'due_date'] = null;
    }
      json[r'accept_non_refundable'] = this.acceptNonRefundable;
      json[r'text_version'] = this.textVersion;
    return json;
  }

  /// Returns a new [PaymentOrderCreate] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PaymentOrderCreate? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'purpose'), 'Required key "PaymentOrderCreate[purpose]" is missing from JSON.');
        assert(json[r'purpose'] != null, 'Required key "PaymentOrderCreate[purpose]" has a null value in JSON.');
        assert(json.containsKey(r'accept_non_refundable'), 'Required key "PaymentOrderCreate[accept_non_refundable]" is missing from JSON.');
        assert(json[r'accept_non_refundable'] != null, 'Required key "PaymentOrderCreate[accept_non_refundable]" has a null value in JSON.');
        assert(json.containsKey(r'text_version'), 'Required key "PaymentOrderCreate[text_version]" is missing from JSON.');
        assert(json[r'text_version'] != null, 'Required key "PaymentOrderCreate[text_version]" has a null value in JSON.');
        return true;
      }());

      return PaymentOrderCreate(
        purpose: PaymentOrderCreatePurposeEnum.fromJson(json[r'purpose'])!,
        amountPaise: mapValueOfType<int>(json, r'amount_paise'),
        dueDate: mapDateTime(json, r'due_date', r''),
        acceptNonRefundable: PaymentOrderCreateAcceptNonRefundableEnum.fromJson(json[r'accept_non_refundable'])!,
        textVersion: mapValueOfType<int>(json, r'text_version')!,
      );
    }
    return null;
  }

  static List<PaymentOrderCreate> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentOrderCreate>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentOrderCreate.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PaymentOrderCreate> mapFromJson(dynamic json) {
    final map = <String, PaymentOrderCreate>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PaymentOrderCreate.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PaymentOrderCreate-objects as value to a dart map
  static Map<String, List<PaymentOrderCreate>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PaymentOrderCreate>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PaymentOrderCreate.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'purpose',
    'accept_non_refundable',
    'text_version',
  };
}


enum PaymentOrderCreatePurposeEnum {
  joining._(r'joining'),
  instalment._(r'instalment'),
  balance._(r'balance'),
  ;

  /// Instantiate a new enum with the provided value.
  const PaymentOrderCreatePurposeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PaymentOrderCreatePurposeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PaymentOrderCreatePurposeEnum? fromJson(dynamic value) => PaymentOrderCreatePurposeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PaymentOrderCreatePurposeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PaymentOrderCreatePurposeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentOrderCreatePurposeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentOrderCreatePurposeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PaymentOrderCreatePurposeEnum] to String,
/// and [decode] dynamic data back to [PaymentOrderCreatePurposeEnum].
class PaymentOrderCreatePurposeEnumTypeTransformer {
  factory PaymentOrderCreatePurposeEnumTypeTransformer() => _instance ??= const PaymentOrderCreatePurposeEnumTypeTransformer._();

  const PaymentOrderCreatePurposeEnumTypeTransformer._();

  String encode(PaymentOrderCreatePurposeEnum data) => data._value;

  /// Returns the instance of [PaymentOrderCreatePurposeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PaymentOrderCreatePurposeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PaymentOrderCreatePurposeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'joining': return PaymentOrderCreatePurposeEnum.joining;
        case r'instalment': return PaymentOrderCreatePurposeEnum.instalment;
        case r'balance': return PaymentOrderCreatePurposeEnum.balance;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PaymentOrderCreatePurposeEnumTypeTransformer? _instance;
}



enum PaymentOrderCreateAcceptNonRefundableEnum {
  true_._('true'),
  ;

  /// Instantiate a new enum with the provided value.
  const PaymentOrderCreateAcceptNonRefundableEnum._(this._value);

  /// The underlying value of this enum member.
  final bool _value;

  @override
  String toString() => _value.toString();

  /// Encodes this enum as a value suitable for JSON.
  bool toJson() => _value;

  /// Returns the instance of [PaymentOrderCreateAcceptNonRefundableEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PaymentOrderCreateAcceptNonRefundableEnum? fromJson(dynamic value) => PaymentOrderCreateAcceptNonRefundableEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PaymentOrderCreateAcceptNonRefundableEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PaymentOrderCreateAcceptNonRefundableEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentOrderCreateAcceptNonRefundableEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentOrderCreateAcceptNonRefundableEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PaymentOrderCreateAcceptNonRefundableEnum] to bool,
/// and [decode] dynamic data back to [PaymentOrderCreateAcceptNonRefundableEnum].
class PaymentOrderCreateAcceptNonRefundableEnumTypeTransformer {
  factory PaymentOrderCreateAcceptNonRefundableEnumTypeTransformer() => _instance ??= const PaymentOrderCreateAcceptNonRefundableEnumTypeTransformer._();

  const PaymentOrderCreateAcceptNonRefundableEnumTypeTransformer._();

  bool encode(PaymentOrderCreateAcceptNonRefundableEnum data) => data._value;

  /// Returns the instance of [PaymentOrderCreateAcceptNonRefundableEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PaymentOrderCreateAcceptNonRefundableEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PaymentOrderCreateAcceptNonRefundableEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case 'true': return PaymentOrderCreateAcceptNonRefundableEnum.true_;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PaymentOrderCreateAcceptNonRefundableEnumTypeTransformer? _instance;
}


