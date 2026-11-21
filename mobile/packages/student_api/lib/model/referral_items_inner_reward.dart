//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReferralItemsInnerReward {
  /// Returns a new [ReferralItemsInnerReward] instance.
  ReferralItemsInnerReward({
    required this.amountPaise,
    required this.status,
    required this.paidAt,
  });

  int amountPaise;

  ReferralItemsInnerRewardStatusEnum status;

  DateTime? paidAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReferralItemsInnerReward &&
    other.amountPaise == amountPaise &&
    other.status == status &&
    other.paidAt == paidAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (amountPaise.hashCode) +
    (status.hashCode) +
    (paidAt == null ? 0 : paidAt!.hashCode);

  @override
  String toString() => 'ReferralItemsInnerReward[amountPaise=$amountPaise, status=$status, paidAt=$paidAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'amount_paise'] = this.amountPaise;
      json[r'status'] = this.status;
    if (this.paidAt != null) {
      json[r'paid_at'] = this.paidAt!.toUtc().toIso8601String();
    } else {
      json[r'paid_at'] = null;
    }
    return json;
  }

  /// Returns a new [ReferralItemsInnerReward] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReferralItemsInnerReward? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'amount_paise'), 'Required key "ReferralItemsInnerReward[amount_paise]" is missing from JSON.');
        assert(json[r'amount_paise'] != null, 'Required key "ReferralItemsInnerReward[amount_paise]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "ReferralItemsInnerReward[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "ReferralItemsInnerReward[status]" has a null value in JSON.');
        assert(json.containsKey(r'paid_at'), 'Required key "ReferralItemsInnerReward[paid_at]" is missing from JSON.');
        return true;
      }());

      return ReferralItemsInnerReward(
        amountPaise: mapValueOfType<int>(json, r'amount_paise')!,
        status: ReferralItemsInnerRewardStatusEnum.fromJson(json[r'status'])!,
        paidAt: mapDateTime(json, r'paid_at', r''),
      );
    }
    return null;
  }

  static List<ReferralItemsInnerReward> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReferralItemsInnerReward>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReferralItemsInnerReward.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReferralItemsInnerReward> mapFromJson(dynamic json) {
    final map = <String, ReferralItemsInnerReward>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReferralItemsInnerReward.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReferralItemsInnerReward-objects as value to a dart map
  static Map<String, List<ReferralItemsInnerReward>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReferralItemsInnerReward>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReferralItemsInnerReward.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'amount_paise',
    'status',
    'paid_at',
  };
}


enum ReferralItemsInnerRewardStatusEnum {
  waitingAccount._(r'waiting_account'),
  queued._(r'queued'),
  processing._(r'processing'),
  paid._(r'paid'),
  failed._(r'failed'),
  reversed._(r'reversed'),
  held._(r'held'),
  ;

  /// Instantiate a new enum with the provided value.
  const ReferralItemsInnerRewardStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ReferralItemsInnerRewardStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ReferralItemsInnerRewardStatusEnum? fromJson(dynamic value) => ReferralItemsInnerRewardStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ReferralItemsInnerRewardStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ReferralItemsInnerRewardStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReferralItemsInnerRewardStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReferralItemsInnerRewardStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ReferralItemsInnerRewardStatusEnum] to String,
/// and [decode] dynamic data back to [ReferralItemsInnerRewardStatusEnum].
class ReferralItemsInnerRewardStatusEnumTypeTransformer {
  factory ReferralItemsInnerRewardStatusEnumTypeTransformer() => _instance ??= const ReferralItemsInnerRewardStatusEnumTypeTransformer._();

  const ReferralItemsInnerRewardStatusEnumTypeTransformer._();

  String encode(ReferralItemsInnerRewardStatusEnum data) => data._value;

  /// Returns the instance of [ReferralItemsInnerRewardStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ReferralItemsInnerRewardStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ReferralItemsInnerRewardStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'waiting_account': return ReferralItemsInnerRewardStatusEnum.waitingAccount;
        case r'queued': return ReferralItemsInnerRewardStatusEnum.queued;
        case r'processing': return ReferralItemsInnerRewardStatusEnum.processing;
        case r'paid': return ReferralItemsInnerRewardStatusEnum.paid;
        case r'failed': return ReferralItemsInnerRewardStatusEnum.failed;
        case r'reversed': return ReferralItemsInnerRewardStatusEnum.reversed;
        case r'held': return ReferralItemsInnerRewardStatusEnum.held;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ReferralItemsInnerRewardStatusEnumTypeTransformer? _instance;
}


