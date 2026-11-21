//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RegistrationJoiningPayment {
  /// Returns a new [RegistrationJoiningPayment] instance.
  RegistrationJoiningPayment({
    required this.referralDiscountPaise,
    required this.payablePaise,
    required this.minPaise,
  });

  /// Minimum value: 0
  int referralDiscountPaise;

  /// Minimum value: 0
  int payablePaise;

  /// Minimum value: 1
  int minPaise;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RegistrationJoiningPayment &&
    other.referralDiscountPaise == referralDiscountPaise &&
    other.payablePaise == payablePaise &&
    other.minPaise == minPaise;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (referralDiscountPaise.hashCode) +
    (payablePaise.hashCode) +
    (minPaise.hashCode);

  @override
  String toString() => 'RegistrationJoiningPayment[referralDiscountPaise=$referralDiscountPaise, payablePaise=$payablePaise, minPaise=$minPaise]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'referral_discount_paise'] = this.referralDiscountPaise;
      json[r'payable_paise'] = this.payablePaise;
      json[r'min_paise'] = this.minPaise;
    return json;
  }

  /// Returns a new [RegistrationJoiningPayment] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RegistrationJoiningPayment? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'referral_discount_paise'), 'Required key "RegistrationJoiningPayment[referral_discount_paise]" is missing from JSON.');
        assert(json[r'referral_discount_paise'] != null, 'Required key "RegistrationJoiningPayment[referral_discount_paise]" has a null value in JSON.');
        assert(json.containsKey(r'payable_paise'), 'Required key "RegistrationJoiningPayment[payable_paise]" is missing from JSON.');
        assert(json[r'payable_paise'] != null, 'Required key "RegistrationJoiningPayment[payable_paise]" has a null value in JSON.');
        assert(json.containsKey(r'min_paise'), 'Required key "RegistrationJoiningPayment[min_paise]" is missing from JSON.');
        assert(json[r'min_paise'] != null, 'Required key "RegistrationJoiningPayment[min_paise]" has a null value in JSON.');
        return true;
      }());

      return RegistrationJoiningPayment(
        referralDiscountPaise: mapValueOfType<int>(json, r'referral_discount_paise')!,
        payablePaise: mapValueOfType<int>(json, r'payable_paise')!,
        minPaise: mapValueOfType<int>(json, r'min_paise')!,
      );
    }
    return null;
  }

  static List<RegistrationJoiningPayment> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RegistrationJoiningPayment>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RegistrationJoiningPayment.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RegistrationJoiningPayment> mapFromJson(dynamic json) {
    final map = <String, RegistrationJoiningPayment>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RegistrationJoiningPayment.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RegistrationJoiningPayment-objects as value to a dart map
  static Map<String, List<RegistrationJoiningPayment>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RegistrationJoiningPayment>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RegistrationJoiningPayment.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'referral_discount_paise',
    'payable_paise',
    'min_paise',
  };
}

