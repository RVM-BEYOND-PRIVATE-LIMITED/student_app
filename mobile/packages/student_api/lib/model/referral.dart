//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Referral {
  /// Returns a new [Referral] instance.
  Referral({
    required this.code,
    required this.link,
    required this.referrals,
    this.rewardPaise,
    this.friendDiscountPaise,
    this.items = const [],
  });

  String? code;

  String? link;

  ReferralReferrals referrals;

  /// What a referral earns today, once the friend's fee is fully received (0.35.0).
  ///
  /// Minimum value: 0
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? rewardPaise;

  /// What a friend gets off the fee today (0.35.0).
  ///
  /// Minimum value: 0
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? friendDiscountPaise;

  /// One per friend, newest first, at most 100 (0.35.0). `reward` is null until the friend's fee is fully received.
  List<ReferralItemsInner> items;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Referral &&
    other.code == code &&
    other.link == link &&
    other.referrals == referrals &&
    other.rewardPaise == rewardPaise &&
    other.friendDiscountPaise == friendDiscountPaise &&
    _deepEquality.equals(other.items, items);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (code == null ? 0 : code!.hashCode) +
    (link == null ? 0 : link!.hashCode) +
    (referrals.hashCode) +
    (rewardPaise == null ? 0 : rewardPaise!.hashCode) +
    (friendDiscountPaise == null ? 0 : friendDiscountPaise!.hashCode) +
    (items.hashCode);

  @override
  String toString() => 'Referral[code=$code, link=$link, referrals=$referrals, rewardPaise=$rewardPaise, friendDiscountPaise=$friendDiscountPaise, items=$items]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.code != null) {
      json[r'code'] = this.code;
    } else {
      json[r'code'] = null;
    }
    if (this.link != null) {
      json[r'link'] = this.link;
    } else {
      json[r'link'] = null;
    }
      json[r'referrals'] = this.referrals;
    if (this.rewardPaise != null) {
      json[r'reward_paise'] = this.rewardPaise;
    } else {
      json[r'reward_paise'] = null;
    }
    if (this.friendDiscountPaise != null) {
      json[r'friend_discount_paise'] = this.friendDiscountPaise;
    } else {
      json[r'friend_discount_paise'] = null;
    }
      json[r'items'] = this.items;
    return json;
  }

  /// Returns a new [Referral] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Referral? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'code'), 'Required key "Referral[code]" is missing from JSON.');
        assert(json.containsKey(r'link'), 'Required key "Referral[link]" is missing from JSON.');
        assert(json.containsKey(r'referrals'), 'Required key "Referral[referrals]" is missing from JSON.');
        assert(json[r'referrals'] != null, 'Required key "Referral[referrals]" has a null value in JSON.');
        return true;
      }());

      return Referral(
        code: mapValueOfType<String>(json, r'code'),
        link: mapValueOfType<String>(json, r'link'),
        referrals: ReferralReferrals.fromJson(json[r'referrals'])!,
        rewardPaise: mapValueOfType<int>(json, r'reward_paise'),
        friendDiscountPaise: mapValueOfType<int>(json, r'friend_discount_paise'),
        items: ReferralItemsInner.listFromJson(json[r'items']),
      );
    }
    return null;
  }

  static List<Referral> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Referral>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Referral.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Referral> mapFromJson(dynamic json) {
    final map = <String, Referral>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Referral.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Referral-objects as value to a dart map
  static Map<String, List<Referral>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Referral>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Referral.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'code',
    'link',
    'referrals',
  };
}

