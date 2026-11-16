//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Fees {
  /// Returns a new [Fees] instance.
  Fees({
    required this.totalPaise,
    required this.paidPaise,
    required this.duePaise,
    required this.nextDueDate,
    this.plan = const [],
    required this.planPending,
    required this.feeHold,
  });

  /// Minimum value: 0
  int totalPaise;

  int paidPaise;

  /// Minimum value: 0
  int duePaise;

  DateTime? nextDueDate;

  List<AdmissionPlanInner> plan;

  bool planPending;

  TodayFeeHold feeHold;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Fees &&
    other.totalPaise == totalPaise &&
    other.paidPaise == paidPaise &&
    other.duePaise == duePaise &&
    other.nextDueDate == nextDueDate &&
    _deepEquality.equals(other.plan, plan) &&
    other.planPending == planPending &&
    other.feeHold == feeHold;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (totalPaise.hashCode) +
    (paidPaise.hashCode) +
    (duePaise.hashCode) +
    (nextDueDate == null ? 0 : nextDueDate!.hashCode) +
    (plan.hashCode) +
    (planPending.hashCode) +
    (feeHold.hashCode);

  @override
  String toString() => 'Fees[totalPaise=$totalPaise, paidPaise=$paidPaise, duePaise=$duePaise, nextDueDate=$nextDueDate, plan=$plan, planPending=$planPending, feeHold=$feeHold]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'total_paise'] = this.totalPaise;
      json[r'paid_paise'] = this.paidPaise;
      json[r'due_paise'] = this.duePaise;
    if (this.nextDueDate != null) {
      json[r'next_due_date'] = _dateFormatter.format(this.nextDueDate!);
    } else {
      json[r'next_due_date'] = null;
    }
      json[r'plan'] = this.plan;
      json[r'plan_pending'] = this.planPending;
      json[r'fee_hold'] = this.feeHold;
    return json;
  }

  /// Returns a new [Fees] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Fees? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'total_paise'), 'Required key "Fees[total_paise]" is missing from JSON.');
        assert(json[r'total_paise'] != null, 'Required key "Fees[total_paise]" has a null value in JSON.');
        assert(json.containsKey(r'paid_paise'), 'Required key "Fees[paid_paise]" is missing from JSON.');
        assert(json[r'paid_paise'] != null, 'Required key "Fees[paid_paise]" has a null value in JSON.');
        assert(json.containsKey(r'due_paise'), 'Required key "Fees[due_paise]" is missing from JSON.');
        assert(json[r'due_paise'] != null, 'Required key "Fees[due_paise]" has a null value in JSON.');
        assert(json.containsKey(r'next_due_date'), 'Required key "Fees[next_due_date]" is missing from JSON.');
        assert(json.containsKey(r'plan'), 'Required key "Fees[plan]" is missing from JSON.');
        assert(json[r'plan'] != null, 'Required key "Fees[plan]" has a null value in JSON.');
        assert(json.containsKey(r'plan_pending'), 'Required key "Fees[plan_pending]" is missing from JSON.');
        assert(json[r'plan_pending'] != null, 'Required key "Fees[plan_pending]" has a null value in JSON.');
        assert(json.containsKey(r'fee_hold'), 'Required key "Fees[fee_hold]" is missing from JSON.');
        assert(json[r'fee_hold'] != null, 'Required key "Fees[fee_hold]" has a null value in JSON.');
        return true;
      }());

      return Fees(
        totalPaise: mapValueOfType<int>(json, r'total_paise')!,
        paidPaise: mapValueOfType<int>(json, r'paid_paise')!,
        duePaise: mapValueOfType<int>(json, r'due_paise')!,
        nextDueDate: mapDateTime(json, r'next_due_date', r''),
        plan: AdmissionPlanInner.listFromJson(json[r'plan']),
        planPending: mapValueOfType<bool>(json, r'plan_pending')!,
        feeHold: TodayFeeHold.fromJson(json[r'fee_hold'])!,
      );
    }
    return null;
  }

  static List<Fees> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Fees>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Fees.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Fees> mapFromJson(dynamic json) {
    final map = <String, Fees>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Fees.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Fees-objects as value to a dart map
  static Map<String, List<Fees>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Fees>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Fees.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'total_paise',
    'paid_paise',
    'due_paise',
    'next_due_date',
    'plan',
    'plan_pending',
    'fee_hold',
  };
}

