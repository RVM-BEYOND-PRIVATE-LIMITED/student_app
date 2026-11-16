//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RegistrationFields {
  /// Returns a new [RegistrationFields] instance.
  RegistrationFields({
    this.branchId,
    this.studentName,
    this.email,
    this.dateOfBirth,
    this.currentAddress,
    this.permanentAddress,
    this.fatherName,
    this.fatherPhone,
    this.idType,
    this.courseIds = const [],
  });

  /// Minimum value: 1
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? branchId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? studentName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? email;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? dateOfBirth;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? currentAddress;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? permanentAddress;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? fatherName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? fatherPhone;

  RegistrationFieldsIdTypeEnum? idType;

  List<String> courseIds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RegistrationFields &&
    other.branchId == branchId &&
    other.studentName == studentName &&
    other.email == email &&
    other.dateOfBirth == dateOfBirth &&
    other.currentAddress == currentAddress &&
    other.permanentAddress == permanentAddress &&
    other.fatherName == fatherName &&
    other.fatherPhone == fatherPhone &&
    other.idType == idType &&
    _deepEquality.equals(other.courseIds, courseIds);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (branchId == null ? 0 : branchId!.hashCode) +
    (studentName == null ? 0 : studentName!.hashCode) +
    (email == null ? 0 : email!.hashCode) +
    (dateOfBirth == null ? 0 : dateOfBirth!.hashCode) +
    (currentAddress == null ? 0 : currentAddress!.hashCode) +
    (permanentAddress == null ? 0 : permanentAddress!.hashCode) +
    (fatherName == null ? 0 : fatherName!.hashCode) +
    (fatherPhone == null ? 0 : fatherPhone!.hashCode) +
    (idType == null ? 0 : idType!.hashCode) +
    (courseIds.hashCode);

  @override
  String toString() => 'RegistrationFields[branchId=$branchId, studentName=$studentName, email=$email, dateOfBirth=$dateOfBirth, currentAddress=$currentAddress, permanentAddress=$permanentAddress, fatherName=$fatherName, fatherPhone=$fatherPhone, idType=$idType, courseIds=$courseIds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
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
      json[r'course_ids'] = this.courseIds;
    return json;
  }

  /// Returns a new [RegistrationFields] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RegistrationFields? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return RegistrationFields(
        branchId: mapValueOfType<int>(json, r'branch_id'),
        studentName: mapValueOfType<String>(json, r'student_name'),
        email: mapValueOfType<String>(json, r'email'),
        dateOfBirth: mapDateTime(json, r'date_of_birth', r''),
        currentAddress: mapValueOfType<String>(json, r'current_address'),
        permanentAddress: mapValueOfType<String>(json, r'permanent_address'),
        fatherName: mapValueOfType<String>(json, r'father_name'),
        fatherPhone: mapValueOfType<String>(json, r'father_phone'),
        idType: RegistrationFieldsIdTypeEnum.fromJson(json[r'id_type']),
        courseIds: json[r'course_ids'] is Iterable
            ? (json[r'course_ids'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<RegistrationFields> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RegistrationFields>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RegistrationFields.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RegistrationFields> mapFromJson(dynamic json) {
    final map = <String, RegistrationFields>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RegistrationFields.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RegistrationFields-objects as value to a dart map
  static Map<String, List<RegistrationFields>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RegistrationFields>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RegistrationFields.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


enum RegistrationFieldsIdTypeEnum {
  aadhaar._(r'aadhaar'),
  pan._(r'pan'),
  voterId._(r'voter_id'),
  drivingLicence._(r'driving_licence'),
  passport._(r'passport'),
  ;

  /// Instantiate a new enum with the provided value.
  const RegistrationFieldsIdTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [RegistrationFieldsIdTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static RegistrationFieldsIdTypeEnum? fromJson(dynamic value) => RegistrationFieldsIdTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [RegistrationFieldsIdTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<RegistrationFieldsIdTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RegistrationFieldsIdTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RegistrationFieldsIdTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RegistrationFieldsIdTypeEnum] to String,
/// and [decode] dynamic data back to [RegistrationFieldsIdTypeEnum].
class RegistrationFieldsIdTypeEnumTypeTransformer {
  factory RegistrationFieldsIdTypeEnumTypeTransformer() => _instance ??= const RegistrationFieldsIdTypeEnumTypeTransformer._();

  const RegistrationFieldsIdTypeEnumTypeTransformer._();

  String encode(RegistrationFieldsIdTypeEnum data) => data._value;

  /// Returns the instance of [RegistrationFieldsIdTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RegistrationFieldsIdTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is RegistrationFieldsIdTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'aadhaar': return RegistrationFieldsIdTypeEnum.aadhaar;
        case r'pan': return RegistrationFieldsIdTypeEnum.pan;
        case r'voter_id': return RegistrationFieldsIdTypeEnum.voterId;
        case r'driving_licence': return RegistrationFieldsIdTypeEnum.drivingLicence;
        case r'passport': return RegistrationFieldsIdTypeEnum.passport;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static RegistrationFieldsIdTypeEnumTypeTransformer? _instance;
}


