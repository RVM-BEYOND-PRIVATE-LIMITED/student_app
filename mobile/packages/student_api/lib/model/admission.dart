//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Admission {
  /// Returns a new [Admission] instance.
  Admission({
    required this.admissionNumber,
    required this.name,
    this.courses = const [],
    required this.branch,
    required this.paidFigures,
    required this.totalFeesPaise,
    this.totalPaidPaise,
    required this.remainingDuePaise,
    this.plan = const [],
  });

  String admissionNumber;

  String name;

  List<String> courses;

  AdmissionBranch branch;

  AdmissionPaidFiguresEnum paidFigures;

  /// Minimum value: 0
  int totalFeesPaise;

  /// Absent when paid_figures is legacy.
  ///
  /// Minimum value: 0
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? totalPaidPaise;

  /// Minimum value: 0
  int remainingDuePaise;

  List<AdmissionPlanInner> plan;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Admission &&
    other.admissionNumber == admissionNumber &&
    other.name == name &&
    _deepEquality.equals(other.courses, courses) &&
    other.branch == branch &&
    other.paidFigures == paidFigures &&
    other.totalFeesPaise == totalFeesPaise &&
    other.totalPaidPaise == totalPaidPaise &&
    other.remainingDuePaise == remainingDuePaise &&
    _deepEquality.equals(other.plan, plan);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (admissionNumber.hashCode) +
    (name.hashCode) +
    (courses.hashCode) +
    (branch.hashCode) +
    (paidFigures.hashCode) +
    (totalFeesPaise.hashCode) +
    (totalPaidPaise == null ? 0 : totalPaidPaise!.hashCode) +
    (remainingDuePaise.hashCode) +
    (plan.hashCode);

  @override
  String toString() => 'Admission[admissionNumber=$admissionNumber, name=$name, courses=$courses, branch=$branch, paidFigures=$paidFigures, totalFeesPaise=$totalFeesPaise, totalPaidPaise=$totalPaidPaise, remainingDuePaise=$remainingDuePaise, plan=$plan]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'admission_number'] = this.admissionNumber;
      json[r'name'] = this.name;
      json[r'courses'] = this.courses;
      json[r'branch'] = this.branch;
      json[r'paid_figures'] = this.paidFigures;
      json[r'total_fees_paise'] = this.totalFeesPaise;
    if (this.totalPaidPaise != null) {
      json[r'total_paid_paise'] = this.totalPaidPaise;
    } else {
      json[r'total_paid_paise'] = null;
    }
      json[r'remaining_due_paise'] = this.remainingDuePaise;
      json[r'plan'] = this.plan;
    return json;
  }

  /// Returns a new [Admission] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Admission? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'admission_number'), 'Required key "Admission[admission_number]" is missing from JSON.');
        assert(json[r'admission_number'] != null, 'Required key "Admission[admission_number]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "Admission[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "Admission[name]" has a null value in JSON.');
        assert(json.containsKey(r'courses'), 'Required key "Admission[courses]" is missing from JSON.');
        assert(json[r'courses'] != null, 'Required key "Admission[courses]" has a null value in JSON.');
        assert(json.containsKey(r'branch'), 'Required key "Admission[branch]" is missing from JSON.');
        assert(json[r'branch'] != null, 'Required key "Admission[branch]" has a null value in JSON.');
        assert(json.containsKey(r'paid_figures'), 'Required key "Admission[paid_figures]" is missing from JSON.');
        assert(json[r'paid_figures'] != null, 'Required key "Admission[paid_figures]" has a null value in JSON.');
        assert(json.containsKey(r'total_fees_paise'), 'Required key "Admission[total_fees_paise]" is missing from JSON.');
        assert(json[r'total_fees_paise'] != null, 'Required key "Admission[total_fees_paise]" has a null value in JSON.');
        assert(json.containsKey(r'remaining_due_paise'), 'Required key "Admission[remaining_due_paise]" is missing from JSON.');
        assert(json[r'remaining_due_paise'] != null, 'Required key "Admission[remaining_due_paise]" has a null value in JSON.');
        assert(json.containsKey(r'plan'), 'Required key "Admission[plan]" is missing from JSON.');
        assert(json[r'plan'] != null, 'Required key "Admission[plan]" has a null value in JSON.');
        return true;
      }());

      return Admission(
        admissionNumber: mapValueOfType<String>(json, r'admission_number')!,
        name: mapValueOfType<String>(json, r'name')!,
        courses: json[r'courses'] is Iterable
            ? (json[r'courses'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        branch: AdmissionBranch.fromJson(json[r'branch'])!,
        paidFigures: AdmissionPaidFiguresEnum.fromJson(json[r'paid_figures'])!,
        totalFeesPaise: mapValueOfType<int>(json, r'total_fees_paise')!,
        totalPaidPaise: mapValueOfType<int>(json, r'total_paid_paise'),
        remainingDuePaise: mapValueOfType<int>(json, r'remaining_due_paise')!,
        plan: AdmissionPlanInner.listFromJson(json[r'plan']),
      );
    }
    return null;
  }

  static List<Admission> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Admission>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Admission.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Admission> mapFromJson(dynamic json) {
    final map = <String, Admission>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Admission.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Admission-objects as value to a dart map
  static Map<String, List<Admission>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Admission>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Admission.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'admission_number',
    'name',
    'courses',
    'branch',
    'paid_figures',
    'total_fees_paise',
    'remaining_due_paise',
    'plan',
  };
}


enum AdmissionPaidFiguresEnum {
  current._(r'current'),
  legacy._(r'legacy'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdmissionPaidFiguresEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdmissionPaidFiguresEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdmissionPaidFiguresEnum? fromJson(dynamic value) => AdmissionPaidFiguresEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdmissionPaidFiguresEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdmissionPaidFiguresEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdmissionPaidFiguresEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdmissionPaidFiguresEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdmissionPaidFiguresEnum] to String,
/// and [decode] dynamic data back to [AdmissionPaidFiguresEnum].
class AdmissionPaidFiguresEnumTypeTransformer {
  factory AdmissionPaidFiguresEnumTypeTransformer() => _instance ??= const AdmissionPaidFiguresEnumTypeTransformer._();

  const AdmissionPaidFiguresEnumTypeTransformer._();

  String encode(AdmissionPaidFiguresEnum data) => data._value;

  /// Returns the instance of [AdmissionPaidFiguresEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdmissionPaidFiguresEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdmissionPaidFiguresEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'current': return AdmissionPaidFiguresEnum.current;
        case r'legacy': return AdmissionPaidFiguresEnum.legacy;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdmissionPaidFiguresEnumTypeTransformer? _instance;
}


