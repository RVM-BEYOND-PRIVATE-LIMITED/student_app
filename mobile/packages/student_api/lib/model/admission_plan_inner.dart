//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdmissionPlanInner {
  /// Returns a new [AdmissionPlanInner] instance.
  AdmissionPlanInner({
    required this.dueDate,
    required this.amountPaise,
    required this.balanceDuePaise,
    required this.status,
  });

  DateTime dueDate;

  /// Minimum value: 0
  int amountPaise;

  /// Minimum value: 0
  int balanceDuePaise;

  AdmissionPlanInnerStatusEnum status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdmissionPlanInner &&
    other.dueDate == dueDate &&
    other.amountPaise == amountPaise &&
    other.balanceDuePaise == balanceDuePaise &&
    other.status == status;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (dueDate.hashCode) +
    (amountPaise.hashCode) +
    (balanceDuePaise.hashCode) +
    (status.hashCode);

  @override
  String toString() => 'AdmissionPlanInner[dueDate=$dueDate, amountPaise=$amountPaise, balanceDuePaise=$balanceDuePaise, status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'due_date'] = _dateFormatter.format(this.dueDate);
      json[r'amount_paise'] = this.amountPaise;
      json[r'balance_due_paise'] = this.balanceDuePaise;
      json[r'status'] = this.status;
    return json;
  }

  /// Returns a new [AdmissionPlanInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdmissionPlanInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'due_date'), 'Required key "AdmissionPlanInner[due_date]" is missing from JSON.');
        assert(json[r'due_date'] != null, 'Required key "AdmissionPlanInner[due_date]" has a null value in JSON.');
        assert(json.containsKey(r'amount_paise'), 'Required key "AdmissionPlanInner[amount_paise]" is missing from JSON.');
        assert(json[r'amount_paise'] != null, 'Required key "AdmissionPlanInner[amount_paise]" has a null value in JSON.');
        assert(json.containsKey(r'balance_due_paise'), 'Required key "AdmissionPlanInner[balance_due_paise]" is missing from JSON.');
        assert(json[r'balance_due_paise'] != null, 'Required key "AdmissionPlanInner[balance_due_paise]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdmissionPlanInner[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdmissionPlanInner[status]" has a null value in JSON.');
        return true;
      }());

      return AdmissionPlanInner(
        dueDate: mapDateTime(json, r'due_date', r'')!,
        amountPaise: mapValueOfType<int>(json, r'amount_paise')!,
        balanceDuePaise: mapValueOfType<int>(json, r'balance_due_paise')!,
        status: AdmissionPlanInnerStatusEnum.fromJson(json[r'status'])!,
      );
    }
    return null;
  }

  static List<AdmissionPlanInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdmissionPlanInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdmissionPlanInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdmissionPlanInner> mapFromJson(dynamic json) {
    final map = <String, AdmissionPlanInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdmissionPlanInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdmissionPlanInner-objects as value to a dart map
  static Map<String, List<AdmissionPlanInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdmissionPlanInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdmissionPlanInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'due_date',
    'amount_paise',
    'balance_due_paise',
    'status',
  };
}


enum AdmissionPlanInnerStatusEnum {
  paid._(r'paid'),
  pending._(r'pending'),
  overdue._(r'overdue'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdmissionPlanInnerStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdmissionPlanInnerStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdmissionPlanInnerStatusEnum? fromJson(dynamic value) => AdmissionPlanInnerStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdmissionPlanInnerStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdmissionPlanInnerStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdmissionPlanInnerStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdmissionPlanInnerStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdmissionPlanInnerStatusEnum] to String,
/// and [decode] dynamic data back to [AdmissionPlanInnerStatusEnum].
class AdmissionPlanInnerStatusEnumTypeTransformer {
  factory AdmissionPlanInnerStatusEnumTypeTransformer() => _instance ??= const AdmissionPlanInnerStatusEnumTypeTransformer._();

  const AdmissionPlanInnerStatusEnumTypeTransformer._();

  String encode(AdmissionPlanInnerStatusEnum data) => data._value;

  /// Returns the instance of [AdmissionPlanInnerStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdmissionPlanInnerStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdmissionPlanInnerStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'paid': return AdmissionPlanInnerStatusEnum.paid;
        case r'pending': return AdmissionPlanInnerStatusEnum.pending;
        case r'overdue': return AdmissionPlanInnerStatusEnum.overdue;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdmissionPlanInnerStatusEnumTypeTransformer? _instance;
}


