//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReceiptListReceiptsInner {
  /// Returns a new [ReceiptListReceiptsInner] instance.
  ReceiptListReceiptsInner({
    required this.id,
    required this.receiptNumber,
    required this.paymentDate,
    required this.amountPaise,
    required this.method,
    required this.fromApp,
  });

  String id;

  String? receiptNumber;

  DateTime paymentDate;

  int amountPaise;

  String? method;

  bool fromApp;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReceiptListReceiptsInner &&
    other.id == id &&
    other.receiptNumber == receiptNumber &&
    other.paymentDate == paymentDate &&
    other.amountPaise == amountPaise &&
    other.method == method &&
    other.fromApp == fromApp;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (receiptNumber == null ? 0 : receiptNumber!.hashCode) +
    (paymentDate.hashCode) +
    (amountPaise.hashCode) +
    (method == null ? 0 : method!.hashCode) +
    (fromApp.hashCode);

  @override
  String toString() => 'ReceiptListReceiptsInner[id=$id, receiptNumber=$receiptNumber, paymentDate=$paymentDate, amountPaise=$amountPaise, method=$method, fromApp=$fromApp]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
    if (this.receiptNumber != null) {
      json[r'receipt_number'] = this.receiptNumber;
    } else {
      json[r'receipt_number'] = null;
    }
      json[r'payment_date'] = _dateFormatter.format(this.paymentDate);
      json[r'amount_paise'] = this.amountPaise;
    if (this.method != null) {
      json[r'method'] = this.method;
    } else {
      json[r'method'] = null;
    }
      json[r'from_app'] = this.fromApp;
    return json;
  }

  /// Returns a new [ReceiptListReceiptsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReceiptListReceiptsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ReceiptListReceiptsInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ReceiptListReceiptsInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'receipt_number'), 'Required key "ReceiptListReceiptsInner[receipt_number]" is missing from JSON.');
        assert(json.containsKey(r'payment_date'), 'Required key "ReceiptListReceiptsInner[payment_date]" is missing from JSON.');
        assert(json[r'payment_date'] != null, 'Required key "ReceiptListReceiptsInner[payment_date]" has a null value in JSON.');
        assert(json.containsKey(r'amount_paise'), 'Required key "ReceiptListReceiptsInner[amount_paise]" is missing from JSON.');
        assert(json[r'amount_paise'] != null, 'Required key "ReceiptListReceiptsInner[amount_paise]" has a null value in JSON.');
        assert(json.containsKey(r'method'), 'Required key "ReceiptListReceiptsInner[method]" is missing from JSON.');
        assert(json.containsKey(r'from_app'), 'Required key "ReceiptListReceiptsInner[from_app]" is missing from JSON.');
        assert(json[r'from_app'] != null, 'Required key "ReceiptListReceiptsInner[from_app]" has a null value in JSON.');
        return true;
      }());

      return ReceiptListReceiptsInner(
        id: mapValueOfType<String>(json, r'id')!,
        receiptNumber: mapValueOfType<String>(json, r'receipt_number'),
        paymentDate: mapDateTime(json, r'payment_date', r'')!,
        amountPaise: mapValueOfType<int>(json, r'amount_paise')!,
        method: mapValueOfType<String>(json, r'method'),
        fromApp: mapValueOfType<bool>(json, r'from_app')!,
      );
    }
    return null;
  }

  static List<ReceiptListReceiptsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReceiptListReceiptsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReceiptListReceiptsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReceiptListReceiptsInner> mapFromJson(dynamic json) {
    final map = <String, ReceiptListReceiptsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReceiptListReceiptsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReceiptListReceiptsInner-objects as value to a dart map
  static Map<String, List<ReceiptListReceiptsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReceiptListReceiptsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReceiptListReceiptsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'receipt_number',
    'payment_date',
    'amount_paise',
    'method',
    'from_app',
  };
}

