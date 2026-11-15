//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReferralReferrals {
  /// Returns a new [ReferralReferrals] instance.
  ReferralReferrals({
    required this.applied,
    required this.joined,
    required this.rewarded,
  });

  /// Minimum value: 0
  int applied;

  /// Minimum value: 0
  int joined;

  /// Minimum value: 0
  int rewarded;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReferralReferrals &&
    other.applied == applied &&
    other.joined == joined &&
    other.rewarded == rewarded;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (applied.hashCode) +
    (joined.hashCode) +
    (rewarded.hashCode);

  @override
  String toString() => 'ReferralReferrals[applied=$applied, joined=$joined, rewarded=$rewarded]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'applied'] = this.applied;
      json[r'joined'] = this.joined;
      json[r'rewarded'] = this.rewarded;
    return json;
  }

  /// Returns a new [ReferralReferrals] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReferralReferrals? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'applied'), 'Required key "ReferralReferrals[applied]" is missing from JSON.');
        assert(json[r'applied'] != null, 'Required key "ReferralReferrals[applied]" has a null value in JSON.');
        assert(json.containsKey(r'joined'), 'Required key "ReferralReferrals[joined]" is missing from JSON.');
        assert(json[r'joined'] != null, 'Required key "ReferralReferrals[joined]" has a null value in JSON.');
        assert(json.containsKey(r'rewarded'), 'Required key "ReferralReferrals[rewarded]" is missing from JSON.');
        assert(json[r'rewarded'] != null, 'Required key "ReferralReferrals[rewarded]" has a null value in JSON.');
        return true;
      }());

      return ReferralReferrals(
        applied: mapValueOfType<int>(json, r'applied')!,
        joined: mapValueOfType<int>(json, r'joined')!,
        rewarded: mapValueOfType<int>(json, r'rewarded')!,
      );
    }
    return null;
  }

  static List<ReferralReferrals> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReferralReferrals>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReferralReferrals.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReferralReferrals> mapFromJson(dynamic json) {
    final map = <String, ReferralReferrals>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReferralReferrals.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReferralReferrals-objects as value to a dart map
  static Map<String, List<ReferralReferrals>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReferralReferrals>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReferralReferrals.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'applied',
    'joined',
    'rewarded',
  };
}

