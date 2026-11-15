//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReferralApplied {
  /// Returns a new [ReferralApplied] instance.
  ReferralApplied({
    required this.applied,
    required this.discountPaise,
  });

  bool applied;

  /// Minimum value: 0
  int discountPaise;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReferralApplied &&
    other.applied == applied &&
    other.discountPaise == discountPaise;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (applied.hashCode) +
    (discountPaise.hashCode);

  @override
  String toString() => 'ReferralApplied[applied=$applied, discountPaise=$discountPaise]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'applied'] = this.applied;
      json[r'discount_paise'] = this.discountPaise;
    return json;
  }

  /// Returns a new [ReferralApplied] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReferralApplied? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'applied'), 'Required key "ReferralApplied[applied]" is missing from JSON.');
        assert(json[r'applied'] != null, 'Required key "ReferralApplied[applied]" has a null value in JSON.');
        assert(json.containsKey(r'discount_paise'), 'Required key "ReferralApplied[discount_paise]" is missing from JSON.');
        assert(json[r'discount_paise'] != null, 'Required key "ReferralApplied[discount_paise]" has a null value in JSON.');
        return true;
      }());

      return ReferralApplied(
        applied: mapValueOfType<bool>(json, r'applied')!,
        discountPaise: mapValueOfType<int>(json, r'discount_paise')!,
      );
    }
    return null;
  }

  static List<ReferralApplied> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReferralApplied>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReferralApplied.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReferralApplied> mapFromJson(dynamic json) {
    final map = <String, ReferralApplied>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReferralApplied.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReferralApplied-objects as value to a dart map
  static Map<String, List<ReferralApplied>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReferralApplied>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReferralApplied.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'applied',
    'discount_paise',
  };
}

