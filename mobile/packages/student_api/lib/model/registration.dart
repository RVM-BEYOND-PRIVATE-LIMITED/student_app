//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Registration {
  /// Returns a new [Registration] instance.
  Registration({
    required this.id,
    required this.status,
    required this.branchId,
    required this.studentName,
    required this.email,
    required this.dateOfBirth,
    required this.currentAddress,
    required this.permanentAddress,
    required this.fatherName,
    required this.fatherPhone,
    required this.idType,
    this.courses = const [],
    required this.totalPaise,
    this.joiningPayment,
    required this.undertaking,
    required this.idDocument,
    required this.submittedAt,
    this.missing = const [],
  });

  String id;

  RegistrationStatusEnum status;

  int? branchId;

  String? studentName;

  String? email;

  DateTime? dateOfBirth;

  String? currentAddress;

  String? permanentAddress;

  String? fatherName;

  String? fatherPhone;

  String? idType;

  List<Course> courses;

  /// Minimum value: 0
  int totalPaise;

  RegistrationJoiningPayment? joiningPayment;

  RegistrationUndertaking undertaking;

  RegistrationIdDocument? idDocument;

  DateTime? submittedAt;

  /// What still stops submitting, in a fixed order (branch, name, date_of_birth, current_address, permanent_address, father_name, father_phone, id_type, courses, video, terms, id_document).
  List<String> missing;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Registration &&
    other.id == id &&
    other.status == status &&
    other.branchId == branchId &&
    other.studentName == studentName &&
    other.email == email &&
    other.dateOfBirth == dateOfBirth &&
    other.currentAddress == currentAddress &&
    other.permanentAddress == permanentAddress &&
    other.fatherName == fatherName &&
    other.fatherPhone == fatherPhone &&
    other.idType == idType &&
    _deepEquality.equals(other.courses, courses) &&
    other.totalPaise == totalPaise &&
    other.joiningPayment == joiningPayment &&
    other.undertaking == undertaking &&
    other.idDocument == idDocument &&
    other.submittedAt == submittedAt &&
    _deepEquality.equals(other.missing, missing);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (status.hashCode) +
    (branchId == null ? 0 : branchId!.hashCode) +
    (studentName == null ? 0 : studentName!.hashCode) +
    (email == null ? 0 : email!.hashCode) +
    (dateOfBirth == null ? 0 : dateOfBirth!.hashCode) +
    (currentAddress == null ? 0 : currentAddress!.hashCode) +
    (permanentAddress == null ? 0 : permanentAddress!.hashCode) +
    (fatherName == null ? 0 : fatherName!.hashCode) +
    (fatherPhone == null ? 0 : fatherPhone!.hashCode) +
    (idType == null ? 0 : idType!.hashCode) +
    (courses.hashCode) +
    (totalPaise.hashCode) +
    (joiningPayment == null ? 0 : joiningPayment!.hashCode) +
    (undertaking.hashCode) +
    (idDocument == null ? 0 : idDocument!.hashCode) +
    (submittedAt == null ? 0 : submittedAt!.hashCode) +
    (missing.hashCode);

  @override
  String toString() => 'Registration[id=$id, status=$status, branchId=$branchId, studentName=$studentName, email=$email, dateOfBirth=$dateOfBirth, currentAddress=$currentAddress, permanentAddress=$permanentAddress, fatherName=$fatherName, fatherPhone=$fatherPhone, idType=$idType, courses=$courses, totalPaise=$totalPaise, joiningPayment=$joiningPayment, undertaking=$undertaking, idDocument=$idDocument, submittedAt=$submittedAt, missing=$missing]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'status'] = this.status;
    if (this.branchId != null) {
      json[r'branch_id'] = this.branchId;
    } else {
      json[r'branch_id'] = null;
    }
    if (this.studentName != null) {
      json[r'student_name'] = this.studentName;
    } else {
      json[r'student_name'] = null;
    }
    if (this.email != null) {
      json[r'email'] = this.email;
    } else {
      json[r'email'] = null;
    }
    if (this.dateOfBirth != null) {
      json[r'date_of_birth'] = _dateFormatter.format(this.dateOfBirth!);
    } else {
      json[r'date_of_birth'] = null;
    }
    if (this.currentAddress != null) {
      json[r'current_address'] = this.currentAddress;
    } else {
      json[r'current_address'] = null;
    }
    if (this.permanentAddress != null) {
      json[r'permanent_address'] = this.permanentAddress;
    } else {
      json[r'permanent_address'] = null;
    }
    if (this.fatherName != null) {
      json[r'father_name'] = this.fatherName;
    } else {
      json[r'father_name'] = null;
    }
    if (this.fatherPhone != null) {
      json[r'father_phone'] = this.fatherPhone;
    } else {
      json[r'father_phone'] = null;
    }
    if (this.idType != null) {
      json[r'id_type'] = this.idType;
    } else {
      json[r'id_type'] = null;
    }
      json[r'courses'] = this.courses;
      json[r'total_paise'] = this.totalPaise;
    if (this.joiningPayment != null) {
      json[r'joining_payment'] = this.joiningPayment;
    } else {
      json[r'joining_payment'] = null;
    }
      json[r'undertaking'] = this.undertaking;
    if (this.idDocument != null) {
      json[r'id_document'] = this.idDocument;
    } else {
      json[r'id_document'] = null;
    }
    if (this.submittedAt != null) {
      json[r'submitted_at'] = this.submittedAt!.toUtc().toIso8601String();
    } else {
      json[r'submitted_at'] = null;
    }
      json[r'missing'] = this.missing;
    return json;
  }

  /// Returns a new [Registration] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Registration? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "Registration[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "Registration[id]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "Registration[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "Registration[status]" has a null value in JSON.');
        assert(json.containsKey(r'branch_id'), 'Required key "Registration[branch_id]" is missing from JSON.');
        assert(json.containsKey(r'student_name'), 'Required key "Registration[student_name]" is missing from JSON.');
        assert(json.containsKey(r'email'), 'Required key "Registration[email]" is missing from JSON.');
        assert(json.containsKey(r'date_of_birth'), 'Required key "Registration[date_of_birth]" is missing from JSON.');
        assert(json.containsKey(r'current_address'), 'Required key "Registration[current_address]" is missing from JSON.');
        assert(json.containsKey(r'permanent_address'), 'Required key "Registration[permanent_address]" is missing from JSON.');
        assert(json.containsKey(r'father_name'), 'Required key "Registration[father_name]" is missing from JSON.');
        assert(json.containsKey(r'father_phone'), 'Required key "Registration[father_phone]" is missing from JSON.');
        assert(json.containsKey(r'id_type'), 'Required key "Registration[id_type]" is missing from JSON.');
        assert(json.containsKey(r'courses'), 'Required key "Registration[courses]" is missing from JSON.');
        assert(json[r'courses'] != null, 'Required key "Registration[courses]" has a null value in JSON.');
        assert(json.containsKey(r'total_paise'), 'Required key "Registration[total_paise]" is missing from JSON.');
        assert(json[r'total_paise'] != null, 'Required key "Registration[total_paise]" has a null value in JSON.');
        assert(json.containsKey(r'undertaking'), 'Required key "Registration[undertaking]" is missing from JSON.');
        assert(json[r'undertaking'] != null, 'Required key "Registration[undertaking]" has a null value in JSON.');
        assert(json.containsKey(r'id_document'), 'Required key "Registration[id_document]" is missing from JSON.');
        assert(json.containsKey(r'submitted_at'), 'Required key "Registration[submitted_at]" is missing from JSON.');
        assert(json.containsKey(r'missing'), 'Required key "Registration[missing]" is missing from JSON.');
        assert(json[r'missing'] != null, 'Required key "Registration[missing]" has a null value in JSON.');
        return true;
      }());

      return Registration(
        id: mapValueOfType<String>(json, r'id')!,
        status: RegistrationStatusEnum.fromJson(json[r'status'])!,
        branchId: mapValueOfType<int>(json, r'branch_id'),
        studentName: mapValueOfType<String>(json, r'student_name'),
        email: mapValueOfType<String>(json, r'email'),
        dateOfBirth: mapDateTime(json, r'date_of_birth', r''),
        currentAddress: mapValueOfType<String>(json, r'current_address'),
        permanentAddress: mapValueOfType<String>(json, r'permanent_address'),
        fatherName: mapValueOfType<String>(json, r'father_name'),
        fatherPhone: mapValueOfType<String>(json, r'father_phone'),
        idType: mapValueOfType<String>(json, r'id_type'),
        courses: Course.listFromJson(json[r'courses']),
        totalPaise: mapValueOfType<int>(json, r'total_paise')!,
        joiningPayment: RegistrationJoiningPayment.fromJson(json[r'joining_payment']),
        undertaking: RegistrationUndertaking.fromJson(json[r'undertaking'])!,
        idDocument: RegistrationIdDocument.fromJson(json[r'id_document']),
        submittedAt: mapDateTime(json, r'submitted_at', r''),
        missing: json[r'missing'] is Iterable
            ? (json[r'missing'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<Registration> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Registration>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Registration.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Registration> mapFromJson(dynamic json) {
    final map = <String, Registration>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Registration.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Registration-objects as value to a dart map
  static Map<String, List<Registration>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Registration>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Registration.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'status',
    'branch_id',
    'student_name',
    'email',
    'date_of_birth',
    'current_address',
    'permanent_address',
    'father_name',
    'father_phone',
    'id_type',
    'courses',
    'total_paise',
    'undertaking',
    'id_document',
    'submitted_at',
    'missing',
  };
}


enum RegistrationStatusEnum {
  draft._(r'draft'),
  submitted._(r'submitted'),
  admitted._(r'admitted'),
  cancelled._(r'cancelled'),
  ;

  /// Instantiate a new enum with the provided value.
  const RegistrationStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [RegistrationStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static RegistrationStatusEnum? fromJson(dynamic value) => RegistrationStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [RegistrationStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<RegistrationStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RegistrationStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RegistrationStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RegistrationStatusEnum] to String,
/// and [decode] dynamic data back to [RegistrationStatusEnum].
class RegistrationStatusEnumTypeTransformer {
  factory RegistrationStatusEnumTypeTransformer() => _instance ??= const RegistrationStatusEnumTypeTransformer._();

  const RegistrationStatusEnumTypeTransformer._();

  String encode(RegistrationStatusEnum data) => data._value;

  /// Returns the instance of [RegistrationStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RegistrationStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is RegistrationStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'draft': return RegistrationStatusEnum.draft;
        case r'submitted': return RegistrationStatusEnum.submitted;
        case r'admitted': return RegistrationStatusEnum.admitted;
        case r'cancelled': return RegistrationStatusEnum.cancelled;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static RegistrationStatusEnumTypeTransformer? _instance;
}


