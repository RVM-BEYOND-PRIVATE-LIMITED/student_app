//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PlacementProofListProofsInner {
  /// Returns a new [PlacementProofListProofsInner] instance.
  PlacementProofListProofsInner({
    required this.id,
    required this.companyName,
    required this.role,
    required this.salaryPaise,
    required this.joiningDate,
    required this.status,
    required this.reason,
    required this.reward,
    required this.createdAt,
    required this.decidedAt,
  });

  String id;

  String companyName;

  String role;

  int salaryPaise;

  DateTime joiningDate;

  PlacementProofListProofsInnerStatusEnum status;

  String? reason;

  PlacementProofListProofsInnerReward? reward;

  DateTime createdAt;

  DateTime? decidedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PlacementProofListProofsInner &&
    other.id == id &&
    other.companyName == companyName &&
    other.role == role &&
    other.salaryPaise == salaryPaise &&
    other.joiningDate == joiningDate &&
    other.status == status &&
    other.reason == reason &&
    other.reward == reward &&
    other.createdAt == createdAt &&
    other.decidedAt == decidedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (companyName.hashCode) +
    (role.hashCode) +
    (salaryPaise.hashCode) +
    (joiningDate.hashCode) +
    (status.hashCode) +
    (reason == null ? 0 : reason!.hashCode) +
    (reward == null ? 0 : reward!.hashCode) +
    (createdAt.hashCode) +
    (decidedAt == null ? 0 : decidedAt!.hashCode);

  @override
  String toString() => 'PlacementProofListProofsInner[id=$id, companyName=$companyName, role=$role, salaryPaise=$salaryPaise, joiningDate=$joiningDate, status=$status, reason=$reason, reward=$reward, createdAt=$createdAt, decidedAt=$decidedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'company_name'] = this.companyName;
      json[r'role'] = this.role;
      json[r'salary_paise'] = this.salaryPaise;
      json[r'joining_date'] = _dateFormatter.format(this.joiningDate);
      json[r'status'] = this.status;
    if (this.reason != null) {
      json[r'reason'] = this.reason;
    } else {
      json[r'reason'] = null;
    }
    if (this.reward != null) {
      json[r'reward'] = this.reward;
    } else {
      json[r'reward'] = null;
    }
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.decidedAt != null) {
      json[r'decided_at'] = this.decidedAt!.toUtc().toIso8601String();
    } else {
      json[r'decided_at'] = null;
    }
    return json;
  }

  /// Returns a new [PlacementProofListProofsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PlacementProofListProofsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "PlacementProofListProofsInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "PlacementProofListProofsInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'company_name'), 'Required key "PlacementProofListProofsInner[company_name]" is missing from JSON.');
        assert(json[r'company_name'] != null, 'Required key "PlacementProofListProofsInner[company_name]" has a null value in JSON.');
        assert(json.containsKey(r'role'), 'Required key "PlacementProofListProofsInner[role]" is missing from JSON.');
        assert(json[r'role'] != null, 'Required key "PlacementProofListProofsInner[role]" has a null value in JSON.');
        assert(json.containsKey(r'salary_paise'), 'Required key "PlacementProofListProofsInner[salary_paise]" is missing from JSON.');
        assert(json[r'salary_paise'] != null, 'Required key "PlacementProofListProofsInner[salary_paise]" has a null value in JSON.');
        assert(json.containsKey(r'joining_date'), 'Required key "PlacementProofListProofsInner[joining_date]" is missing from JSON.');
        assert(json[r'joining_date'] != null, 'Required key "PlacementProofListProofsInner[joining_date]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "PlacementProofListProofsInner[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "PlacementProofListProofsInner[status]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "PlacementProofListProofsInner[reason]" is missing from JSON.');
        assert(json.containsKey(r'reward'), 'Required key "PlacementProofListProofsInner[reward]" is missing from JSON.');
        assert(json.containsKey(r'created_at'), 'Required key "PlacementProofListProofsInner[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null, 'Required key "PlacementProofListProofsInner[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'decided_at'), 'Required key "PlacementProofListProofsInner[decided_at]" is missing from JSON.');
        return true;
      }());

      return PlacementProofListProofsInner(
        id: mapValueOfType<String>(json, r'id')!,
        companyName: mapValueOfType<String>(json, r'company_name')!,
        role: mapValueOfType<String>(json, r'role')!,
        salaryPaise: mapValueOfType<int>(json, r'salary_paise')!,
        joiningDate: mapDateTime(json, r'joining_date', r'')!,
        status: PlacementProofListProofsInnerStatusEnum.fromJson(json[r'status'])!,
        reason: mapValueOfType<String>(json, r'reason'),
        reward: PlacementProofListProofsInnerReward.fromJson(json[r'reward']),
        createdAt: mapDateTime(json, r'created_at', r'')!,
        decidedAt: mapDateTime(json, r'decided_at', r''),
      );
    }
    return null;
  }

  static List<PlacementProofListProofsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PlacementProofListProofsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PlacementProofListProofsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PlacementProofListProofsInner> mapFromJson(dynamic json) {
    final map = <String, PlacementProofListProofsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PlacementProofListProofsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PlacementProofListProofsInner-objects as value to a dart map
  static Map<String, List<PlacementProofListProofsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PlacementProofListProofsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PlacementProofListProofsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'company_name',
    'role',
    'salary_paise',
    'joining_date',
    'status',
    'reason',
    'reward',
    'created_at',
    'decided_at',
  };
}


enum PlacementProofListProofsInnerStatusEnum {
  submitted._(r'submitted'),
  beingVerified._(r'being_verified'),
  approved._(r'approved'),
  paid._(r'paid'),
  rejected._(r'rejected'),
  ;

  /// Instantiate a new enum with the provided value.
  const PlacementProofListProofsInnerStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PlacementProofListProofsInnerStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PlacementProofListProofsInnerStatusEnum? fromJson(dynamic value) => PlacementProofListProofsInnerStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PlacementProofListProofsInnerStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PlacementProofListProofsInnerStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PlacementProofListProofsInnerStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PlacementProofListProofsInnerStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PlacementProofListProofsInnerStatusEnum] to String,
/// and [decode] dynamic data back to [PlacementProofListProofsInnerStatusEnum].
class PlacementProofListProofsInnerStatusEnumTypeTransformer {
  factory PlacementProofListProofsInnerStatusEnumTypeTransformer() => _instance ??= const PlacementProofListProofsInnerStatusEnumTypeTransformer._();

  const PlacementProofListProofsInnerStatusEnumTypeTransformer._();

  String encode(PlacementProofListProofsInnerStatusEnum data) => data._value;

  /// Returns the instance of [PlacementProofListProofsInnerStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PlacementProofListProofsInnerStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PlacementProofListProofsInnerStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'submitted': return PlacementProofListProofsInnerStatusEnum.submitted;
        case r'being_verified': return PlacementProofListProofsInnerStatusEnum.beingVerified;
        case r'approved': return PlacementProofListProofsInnerStatusEnum.approved;
        case r'paid': return PlacementProofListProofsInnerStatusEnum.paid;
        case r'rejected': return PlacementProofListProofsInnerStatusEnum.rejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PlacementProofListProofsInnerStatusEnumTypeTransformer? _instance;
}


