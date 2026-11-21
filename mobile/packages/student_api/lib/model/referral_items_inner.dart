//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReferralItemsInner {
  /// Returns a new [ReferralItemsInner] instance.
  ReferralItemsInner({
    required this.id,
    required this.friendPhoneMasked,
    required this.status,
    required this.appliedAt,
    required this.reward,
  });

  String id;

  String friendPhoneMasked;

  ReferralItemsInnerStatusEnum status;

  DateTime appliedAt;

  ReferralItemsInnerReward? reward;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReferralItemsInner &&
    other.id == id &&
    other.friendPhoneMasked == friendPhoneMasked &&
    other.status == status &&
    other.appliedAt == appliedAt &&
    other.reward == reward;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (friendPhoneMasked.hashCode) +
    (status.hashCode) +
    (appliedAt.hashCode) +
    (reward == null ? 0 : reward!.hashCode);

  @override
  String toString() => 'ReferralItemsInner[id=$id, friendPhoneMasked=$friendPhoneMasked, status=$status, appliedAt=$appliedAt, reward=$reward]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'friend_phone_masked'] = this.friendPhoneMasked;
      json[r'status'] = this.status;
      json[r'applied_at'] = this.appliedAt.toUtc().toIso8601String();
    if (this.reward != null) {
      json[r'reward'] = this.reward;
    } else {
      json[r'reward'] = null;
    }
    return json;
  }

  /// Returns a new [ReferralItemsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReferralItemsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ReferralItemsInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ReferralItemsInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'friend_phone_masked'), 'Required key "ReferralItemsInner[friend_phone_masked]" is missing from JSON.');
        assert(json[r'friend_phone_masked'] != null, 'Required key "ReferralItemsInner[friend_phone_masked]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "ReferralItemsInner[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "ReferralItemsInner[status]" has a null value in JSON.');
        assert(json.containsKey(r'applied_at'), 'Required key "ReferralItemsInner[applied_at]" is missing from JSON.');
        assert(json[r'applied_at'] != null, 'Required key "ReferralItemsInner[applied_at]" has a null value in JSON.');
        assert(json.containsKey(r'reward'), 'Required key "ReferralItemsInner[reward]" is missing from JSON.');
        return true;
      }());

      return ReferralItemsInner(
        id: mapValueOfType<String>(json, r'id')!,
        friendPhoneMasked: mapValueOfType<String>(json, r'friend_phone_masked')!,
        status: ReferralItemsInnerStatusEnum.fromJson(json[r'status'])!,
        appliedAt: mapDateTime(json, r'applied_at', r'')!,
        reward: ReferralItemsInnerReward.fromJson(json[r'reward']),
      );
    }
    return null;
  }

  static List<ReferralItemsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReferralItemsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReferralItemsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReferralItemsInner> mapFromJson(dynamic json) {
    final map = <String, ReferralItemsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReferralItemsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReferralItemsInner-objects as value to a dart map
  static Map<String, List<ReferralItemsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReferralItemsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReferralItemsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'friend_phone_masked',
    'status',
    'applied_at',
    'reward',
  };
}


enum ReferralItemsInnerStatusEnum {
  applied._(r'applied'),
  joined._(r'joined'),
  rewarded._(r'rewarded'),
  ;

  /// Instantiate a new enum with the provided value.
  const ReferralItemsInnerStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ReferralItemsInnerStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ReferralItemsInnerStatusEnum? fromJson(dynamic value) => ReferralItemsInnerStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ReferralItemsInnerStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ReferralItemsInnerStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReferralItemsInnerStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReferralItemsInnerStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ReferralItemsInnerStatusEnum] to String,
/// and [decode] dynamic data back to [ReferralItemsInnerStatusEnum].
class ReferralItemsInnerStatusEnumTypeTransformer {
  factory ReferralItemsInnerStatusEnumTypeTransformer() => _instance ??= const ReferralItemsInnerStatusEnumTypeTransformer._();

  const ReferralItemsInnerStatusEnumTypeTransformer._();

  String encode(ReferralItemsInnerStatusEnum data) => data._value;

  /// Returns the instance of [ReferralItemsInnerStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ReferralItemsInnerStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ReferralItemsInnerStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'applied': return ReferralItemsInnerStatusEnum.applied;
        case r'joined': return ReferralItemsInnerStatusEnum.joined;
        case r'rewarded': return ReferralItemsInnerStatusEnum.rewarded;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ReferralItemsInnerStatusEnumTypeTransformer? _instance;
}


