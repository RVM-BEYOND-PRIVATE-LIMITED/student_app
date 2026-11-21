//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdmissionHistoryAdmissionsInner {
  /// Returns a new [AdmissionHistoryAdmissionsInner] instance.
  AdmissionHistoryAdmissionsInner({
    required this.admissionNumber,
    required this.dateOfAdmission,
    this.courses = const [],
    required this.status,
    required this.closedOn,
    required this.totalFeesPaise,
    required this.totalPaidPaise,
    required this.writtenOffPaise,
    this.batches = const [],
    this.receipts = const [],
  });

  String admissionNumber;

  DateTime? dateOfAdmission;

  List<String> courses;

  AdmissionHistoryAdmissionsInnerStatusEnum status;

  DateTime? closedOn;

  /// Minimum value: 0
  int totalFeesPaise;

  /// Minimum value: 0
  int totalPaidPaise;

  /// The balance written off when it closed as a midway dropout.
  ///
  /// Minimum value: 0
  int writtenOffPaise;

  List<AdmissionHistoryAdmissionsInnerBatchesInner> batches;

  List<AdmissionHistoryAdmissionsInnerReceiptsInner> receipts;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdmissionHistoryAdmissionsInner &&
    other.admissionNumber == admissionNumber &&
    other.dateOfAdmission == dateOfAdmission &&
    _deepEquality.equals(other.courses, courses) &&
    other.status == status &&
    other.closedOn == closedOn &&
    other.totalFeesPaise == totalFeesPaise &&
    other.totalPaidPaise == totalPaidPaise &&
    other.writtenOffPaise == writtenOffPaise &&
    _deepEquality.equals(other.batches, batches) &&
    _deepEquality.equals(other.receipts, receipts);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (admissionNumber.hashCode) +
    (dateOfAdmission == null ? 0 : dateOfAdmission!.hashCode) +
    (courses.hashCode) +
    (status.hashCode) +
    (closedOn == null ? 0 : closedOn!.hashCode) +
    (totalFeesPaise.hashCode) +
    (totalPaidPaise.hashCode) +
    (writtenOffPaise.hashCode) +
    (batches.hashCode) +
    (receipts.hashCode);

  @override
  String toString() => 'AdmissionHistoryAdmissionsInner[admissionNumber=$admissionNumber, dateOfAdmission=$dateOfAdmission, courses=$courses, status=$status, closedOn=$closedOn, totalFeesPaise=$totalFeesPaise, totalPaidPaise=$totalPaidPaise, writtenOffPaise=$writtenOffPaise, batches=$batches, receipts=$receipts]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'admission_number'] = this.admissionNumber;
    if (this.dateOfAdmission != null) {
      json[r'date_of_admission'] = _dateFormatter.format(this.dateOfAdmission!);
    } else {
      json[r'date_of_admission'] = null;
    }
      json[r'courses'] = this.courses;
      json[r'status'] = this.status;
    if (this.closedOn != null) {
      json[r'closed_on'] = _dateFormatter.format(this.closedOn!);
    } else {
      json[r'closed_on'] = null;
    }
      json[r'total_fees_paise'] = this.totalFeesPaise;
      json[r'total_paid_paise'] = this.totalPaidPaise;
      json[r'written_off_paise'] = this.writtenOffPaise;
      json[r'batches'] = this.batches;
      json[r'receipts'] = this.receipts;
    return json;
  }

  /// Returns a new [AdmissionHistoryAdmissionsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdmissionHistoryAdmissionsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'admission_number'), 'Required key "AdmissionHistoryAdmissionsInner[admission_number]" is missing from JSON.');
        assert(json[r'admission_number'] != null, 'Required key "AdmissionHistoryAdmissionsInner[admission_number]" has a null value in JSON.');
        assert(json.containsKey(r'date_of_admission'), 'Required key "AdmissionHistoryAdmissionsInner[date_of_admission]" is missing from JSON.');
        assert(json.containsKey(r'courses'), 'Required key "AdmissionHistoryAdmissionsInner[courses]" is missing from JSON.');
        assert(json[r'courses'] != null, 'Required key "AdmissionHistoryAdmissionsInner[courses]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdmissionHistoryAdmissionsInner[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdmissionHistoryAdmissionsInner[status]" has a null value in JSON.');
        assert(json.containsKey(r'closed_on'), 'Required key "AdmissionHistoryAdmissionsInner[closed_on]" is missing from JSON.');
        assert(json.containsKey(r'total_fees_paise'), 'Required key "AdmissionHistoryAdmissionsInner[total_fees_paise]" is missing from JSON.');
        assert(json[r'total_fees_paise'] != null, 'Required key "AdmissionHistoryAdmissionsInner[total_fees_paise]" has a null value in JSON.');
        assert(json.containsKey(r'total_paid_paise'), 'Required key "AdmissionHistoryAdmissionsInner[total_paid_paise]" is missing from JSON.');
        assert(json[r'total_paid_paise'] != null, 'Required key "AdmissionHistoryAdmissionsInner[total_paid_paise]" has a null value in JSON.');
        assert(json.containsKey(r'written_off_paise'), 'Required key "AdmissionHistoryAdmissionsInner[written_off_paise]" is missing from JSON.');
        assert(json[r'written_off_paise'] != null, 'Required key "AdmissionHistoryAdmissionsInner[written_off_paise]" has a null value in JSON.');
        assert(json.containsKey(r'batches'), 'Required key "AdmissionHistoryAdmissionsInner[batches]" is missing from JSON.');
        assert(json[r'batches'] != null, 'Required key "AdmissionHistoryAdmissionsInner[batches]" has a null value in JSON.');
        assert(json.containsKey(r'receipts'), 'Required key "AdmissionHistoryAdmissionsInner[receipts]" is missing from JSON.');
        assert(json[r'receipts'] != null, 'Required key "AdmissionHistoryAdmissionsInner[receipts]" has a null value in JSON.');
        return true;
      }());

      return AdmissionHistoryAdmissionsInner(
        admissionNumber: mapValueOfType<String>(json, r'admission_number')!,
        dateOfAdmission: mapDateTime(json, r'date_of_admission', r''),
        courses: json[r'courses'] is Iterable
            ? (json[r'courses'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        status: AdmissionHistoryAdmissionsInnerStatusEnum.fromJson(json[r'status'])!,
        closedOn: mapDateTime(json, r'closed_on', r''),
        totalFeesPaise: mapValueOfType<int>(json, r'total_fees_paise')!,
        totalPaidPaise: mapValueOfType<int>(json, r'total_paid_paise')!,
        writtenOffPaise: mapValueOfType<int>(json, r'written_off_paise')!,
        batches: AdmissionHistoryAdmissionsInnerBatchesInner.listFromJson(json[r'batches']),
        receipts: AdmissionHistoryAdmissionsInnerReceiptsInner.listFromJson(json[r'receipts']),
      );
    }
    return null;
  }

  static List<AdmissionHistoryAdmissionsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdmissionHistoryAdmissionsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdmissionHistoryAdmissionsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdmissionHistoryAdmissionsInner> mapFromJson(dynamic json) {
    final map = <String, AdmissionHistoryAdmissionsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdmissionHistoryAdmissionsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdmissionHistoryAdmissionsInner-objects as value to a dart map
  static Map<String, List<AdmissionHistoryAdmissionsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdmissionHistoryAdmissionsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdmissionHistoryAdmissionsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'admission_number',
    'date_of_admission',
    'courses',
    'status',
    'closed_on',
    'total_fees_paise',
    'total_paid_paise',
    'written_off_paise',
    'batches',
    'receipts',
  };
}


enum AdmissionHistoryAdmissionsInnerStatusEnum {
  midwayDropout._(r'midway_dropout'),
  dropout._(r'dropout'),
  oldPortal._(r'old_portal'),
  closed._(r'closed'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdmissionHistoryAdmissionsInnerStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdmissionHistoryAdmissionsInnerStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdmissionHistoryAdmissionsInnerStatusEnum? fromJson(dynamic value) => AdmissionHistoryAdmissionsInnerStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdmissionHistoryAdmissionsInnerStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdmissionHistoryAdmissionsInnerStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdmissionHistoryAdmissionsInnerStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdmissionHistoryAdmissionsInnerStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdmissionHistoryAdmissionsInnerStatusEnum] to String,
/// and [decode] dynamic data back to [AdmissionHistoryAdmissionsInnerStatusEnum].
class AdmissionHistoryAdmissionsInnerStatusEnumTypeTransformer {
  factory AdmissionHistoryAdmissionsInnerStatusEnumTypeTransformer() => _instance ??= const AdmissionHistoryAdmissionsInnerStatusEnumTypeTransformer._();

  const AdmissionHistoryAdmissionsInnerStatusEnumTypeTransformer._();

  String encode(AdmissionHistoryAdmissionsInnerStatusEnum data) => data._value;

  /// Returns the instance of [AdmissionHistoryAdmissionsInnerStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdmissionHistoryAdmissionsInnerStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdmissionHistoryAdmissionsInnerStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'midway_dropout': return AdmissionHistoryAdmissionsInnerStatusEnum.midwayDropout;
        case r'dropout': return AdmissionHistoryAdmissionsInnerStatusEnum.dropout;
        case r'old_portal': return AdmissionHistoryAdmissionsInnerStatusEnum.oldPortal;
        case r'closed': return AdmissionHistoryAdmissionsInnerStatusEnum.closed;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdmissionHistoryAdmissionsInnerStatusEnumTypeTransformer? _instance;
}


