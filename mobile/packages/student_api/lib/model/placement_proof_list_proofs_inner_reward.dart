//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PlacementProofListProofsInnerReward {
  /// Returns a new [PlacementProofListProofsInnerReward] instance.
  PlacementProofListProofsInnerReward({
    required this.amountPaise,
    required this.status,
  });

  int amountPaise;

  PlacementProofListProofsInnerRewardStatusEnum status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PlacementProofListProofsInnerReward &&
    other.amountPaise == amountPaise &&
    other.status == status;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (amountPaise.hashCode) +
    (status.hashCode);

  @override
  String toString() => 'PlacementProofListProofsInnerReward[amountPaise=$amountPaise, status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'amount_paise'] = this.amountPaise;
      json[r'status'] = this.status;
    return json;
  }

  /// Returns a new [PlacementProofListProofsInnerReward] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PlacementProofListProofsInnerReward? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'amount_paise'), 'Required key "PlacementProofListProofsInnerReward[amount_paise]" is missing from JSON.');
        assert(json[r'amount_paise'] != null, 'Required key "PlacementProofListProofsInnerReward[amount_paise]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "PlacementProofListProofsInnerReward[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "PlacementProofListProofsInnerReward[status]" has a null value in JSON.');
        return true;
      }());

      return PlacementProofListProofsInnerReward(
        amountPaise: mapValueOfType<int>(json, r'amount_paise')!,
        status: PlacementProofListProofsInnerRewardStatusEnum.fromJson(json[r'status'])!,
      );
    }
    return null;
  }

  static List<PlacementProofListProofsInnerReward> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PlacementProofListProofsInnerReward>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PlacementProofListProofsInnerReward.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PlacementProofListProofsInnerReward> mapFromJson(dynamic json) {
    final map = <String, PlacementProofListProofsInnerReward>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PlacementProofListProofsInnerReward.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PlacementProofListProofsInnerReward-objects as value to a dart map
  static Map<String, List<PlacementProofListProofsInnerReward>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PlacementProofListProofsInnerReward>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PlacementProofListProofsInnerReward.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'amount_paise',
    'status',
  };
}


enum PlacementProofListProofsInnerRewardStatusEnum {
  waitingAccount._(r'waiting_account'),
  queued._(r'queued'),
  processing._(r'processing'),
  paid._(r'paid'),
  failed._(r'failed'),
  reversed._(r'reversed'),
  held._(r'held'),
  ;

  /// Instantiate a new enum with the provided value.
  const PlacementProofListProofsInnerRewardStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PlacementProofListProofsInnerRewardStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PlacementProofListProofsInnerRewardStatusEnum? fromJson(dynamic value) => PlacementProofListProofsInnerRewardStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PlacementProofListProofsInnerRewardStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PlacementProofListProofsInnerRewardStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PlacementProofListProofsInnerRewardStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PlacementProofListProofsInnerRewardStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PlacementProofListProofsInnerRewardStatusEnum] to String,
/// and [decode] dynamic data back to [PlacementProofListProofsInnerRewardStatusEnum].
class PlacementProofListProofsInnerRewardStatusEnumTypeTransformer {
  factory PlacementProofListProofsInnerRewardStatusEnumTypeTransformer() => _instance ??= const PlacementProofListProofsInnerRewardStatusEnumTypeTransformer._();

  const PlacementProofListProofsInnerRewardStatusEnumTypeTransformer._();

  String encode(PlacementProofListProofsInnerRewardStatusEnum data) => data._value;

  /// Returns the instance of [PlacementProofListProofsInnerRewardStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PlacementProofListProofsInnerRewardStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PlacementProofListProofsInnerRewardStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'waiting_account': return PlacementProofListProofsInnerRewardStatusEnum.waitingAccount;
        case r'queued': return PlacementProofListProofsInnerRewardStatusEnum.queued;
        case r'processing': return PlacementProofListProofsInnerRewardStatusEnum.processing;
        case r'paid': return PlacementProofListProofsInnerRewardStatusEnum.paid;
        case r'failed': return PlacementProofListProofsInnerRewardStatusEnum.failed;
        case r'reversed': return PlacementProofListProofsInnerRewardStatusEnum.reversed;
        case r'held': return PlacementProofListProofsInnerRewardStatusEnum.held;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PlacementProofListProofsInnerRewardStatusEnumTypeTransformer? _instance;
}


