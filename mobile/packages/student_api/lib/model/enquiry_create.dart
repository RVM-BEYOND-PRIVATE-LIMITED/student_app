//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EnquiryCreate {
  /// Returns a new [EnquiryCreate] instance.
  EnquiryCreate({
    required this.name,
    required this.phone,
    this.courseId,
    this.locationId,
    required this.formType,
    this.message,
    this.page,
    this.utmSource,
    this.utmMedium,
    this.utmCampaign,
    this.utmTerm,
    this.utmContent,
    this.consent,
    this.consentVersion,
    this.source_ = const EnquiryCreateSource_Enum._('website'),
    this.companyWebsite,
    this.referralCode,
  });

  String name;

  /// Any spacing, with or without +91.
  String phone;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? courseId;

  /// Minimum value: 1
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? locationId;

  EnquiryCreateFormTypeEnum formType;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? message;

  /// The page path the form was on, for example /pricing.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? page;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? utmSource;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? utmMedium;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? utmCampaign;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? utmTerm;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? utmContent;

  /// The \"you may call me\" tick.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? consent;

  /// The version of the consent line's text the person saw, for example website-enquiry-v1 (#276). Send it whenever the form shows the line.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? consentVersion;

  EnquiryCreateSource_Enum source_;

  /// Trap field: never shown, never sent by a person.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? companyWebsite;

  /// A referral code from the link (?ref=); the friend gets the referral discount on joining.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? referralCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EnquiryCreate &&
    other.name == name &&
    other.phone == phone &&
    other.courseId == courseId &&
    other.locationId == locationId &&
    other.formType == formType &&
    other.message == message &&
    other.page == page &&
    other.utmSource == utmSource &&
    other.utmMedium == utmMedium &&
    other.utmCampaign == utmCampaign &&
    other.utmTerm == utmTerm &&
    other.utmContent == utmContent &&
    other.consent == consent &&
    other.consentVersion == consentVersion &&
    other.source_ == source_ &&
    other.companyWebsite == companyWebsite &&
    other.referralCode == referralCode;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (phone.hashCode) +
    (courseId == null ? 0 : courseId!.hashCode) +
    (locationId == null ? 0 : locationId!.hashCode) +
    (formType.hashCode) +
    (message == null ? 0 : message!.hashCode) +
    (page == null ? 0 : page!.hashCode) +
    (utmSource == null ? 0 : utmSource!.hashCode) +
    (utmMedium == null ? 0 : utmMedium!.hashCode) +
    (utmCampaign == null ? 0 : utmCampaign!.hashCode) +
    (utmTerm == null ? 0 : utmTerm!.hashCode) +
    (utmContent == null ? 0 : utmContent!.hashCode) +
    (consent == null ? 0 : consent!.hashCode) +
    (consentVersion == null ? 0 : consentVersion!.hashCode) +
    (source_.hashCode) +
    (companyWebsite == null ? 0 : companyWebsite!.hashCode) +
    (referralCode == null ? 0 : referralCode!.hashCode);

  @override
  String toString() => 'EnquiryCreate[name=$name, phone=$phone, courseId=$courseId, locationId=$locationId, formType=$formType, message=$message, page=$page, utmSource=$utmSource, utmMedium=$utmMedium, utmCampaign=$utmCampaign, utmTerm=$utmTerm, utmContent=$utmContent, consent=$consent, consentVersion=$consentVersion, source_=$source_, companyWebsite=$companyWebsite, referralCode=$referralCode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'phone'] = this.phone;
    if (this.courseId != null) {
      json[r'course_id'] = this.courseId;
    } else {
      json[r'course_id'] = null;
    }
    if (this.locationId != null) {
      json[r'location_id'] = this.locationId;
    } else {
      json[r'location_id'] = null;
    }
      json[r'form_type'] = this.formType;
    if (this.message != null) {
      json[r'message'] = this.message;
    } else {
      json[r'message'] = null;
    }
    if (this.page != null) {
      json[r'page'] = this.page;
    } else {
      json[r'page'] = null;
    }
    if (this.utmSource != null) {
      json[r'utm_source'] = this.utmSource;
    } else {
      json[r'utm_source'] = null;
    }
    if (this.utmMedium != null) {
      json[r'utm_medium'] = this.utmMedium;
    } else {
      json[r'utm_medium'] = null;
    }
    if (this.utmCampaign != null) {
      json[r'utm_campaign'] = this.utmCampaign;
    } else {
      json[r'utm_campaign'] = null;
    }
    if (this.utmTerm != null) {
      json[r'utm_term'] = this.utmTerm;
    } else {
      json[r'utm_term'] = null;
    }
    if (this.utmContent != null) {
      json[r'utm_content'] = this.utmContent;
    } else {
      json[r'utm_content'] = null;
    }
    if (this.consent != null) {
      json[r'consent'] = this.consent;
    } else {
      json[r'consent'] = null;
    }
    if (this.consentVersion != null) {
      json[r'consent_version'] = this.consentVersion;
    } else {
      json[r'consent_version'] = null;
    }
      json[r'source'] = this.source_;
    if (this.companyWebsite != null) {
      json[r'company_website'] = this.companyWebsite;
    } else {
      json[r'company_website'] = null;
    }
    if (this.referralCode != null) {
      json[r'referral_code'] = this.referralCode;
    } else {
      json[r'referral_code'] = null;
    }
    return json;
  }

  /// Returns a new [EnquiryCreate] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EnquiryCreate? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'name'), 'Required key "EnquiryCreate[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "EnquiryCreate[name]" has a null value in JSON.');
        assert(json.containsKey(r'phone'), 'Required key "EnquiryCreate[phone]" is missing from JSON.');
        assert(json[r'phone'] != null, 'Required key "EnquiryCreate[phone]" has a null value in JSON.');
        assert(json.containsKey(r'form_type'), 'Required key "EnquiryCreate[form_type]" is missing from JSON.');
        assert(json[r'form_type'] != null, 'Required key "EnquiryCreate[form_type]" has a null value in JSON.');
        return true;
      }());

      return EnquiryCreate(
        name: mapValueOfType<String>(json, r'name')!,
        phone: mapValueOfType<String>(json, r'phone')!,
        courseId: mapValueOfType<String>(json, r'course_id'),
        locationId: mapValueOfType<int>(json, r'location_id'),
        formType: EnquiryCreateFormTypeEnum.fromJson(json[r'form_type'])!,
        message: mapValueOfType<String>(json, r'message'),
        page: mapValueOfType<String>(json, r'page'),
        utmSource: mapValueOfType<String>(json, r'utm_source'),
        utmMedium: mapValueOfType<String>(json, r'utm_medium'),
        utmCampaign: mapValueOfType<String>(json, r'utm_campaign'),
        utmTerm: mapValueOfType<String>(json, r'utm_term'),
        utmContent: mapValueOfType<String>(json, r'utm_content'),
        consent: mapValueOfType<bool>(json, r'consent'),
        consentVersion: mapValueOfType<String>(json, r'consent_version'),
        source_: EnquiryCreateSource_Enum.fromJson(json[r'source']) ?? const EnquiryCreateSource_Enum._('website'),
        companyWebsite: mapValueOfType<String>(json, r'company_website'),
        referralCode: mapValueOfType<String>(json, r'referral_code'),
      );
    }
    return null;
  }

  static List<EnquiryCreate> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EnquiryCreate>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EnquiryCreate.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EnquiryCreate> mapFromJson(dynamic json) {
    final map = <String, EnquiryCreate>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EnquiryCreate.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EnquiryCreate-objects as value to a dart map
  static Map<String, List<EnquiryCreate>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EnquiryCreate>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EnquiryCreate.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'phone',
    'form_type',
  };
}


enum EnquiryCreateFormTypeEnum {
  counselling._(r'counselling'),
  callback._(r'callback'),
  blogCallback._(r'blog_callback'),
  pricingUnlock._(r'pricing_unlock'),
  company._(r'company'),
  ;

  /// Instantiate a new enum with the provided value.
  const EnquiryCreateFormTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [EnquiryCreateFormTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static EnquiryCreateFormTypeEnum? fromJson(dynamic value) => EnquiryCreateFormTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [EnquiryCreateFormTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<EnquiryCreateFormTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EnquiryCreateFormTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EnquiryCreateFormTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [EnquiryCreateFormTypeEnum] to String,
/// and [decode] dynamic data back to [EnquiryCreateFormTypeEnum].
class EnquiryCreateFormTypeEnumTypeTransformer {
  factory EnquiryCreateFormTypeEnumTypeTransformer() => _instance ??= const EnquiryCreateFormTypeEnumTypeTransformer._();

  const EnquiryCreateFormTypeEnumTypeTransformer._();

  String encode(EnquiryCreateFormTypeEnum data) => data._value;

  /// Returns the instance of [EnquiryCreateFormTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  EnquiryCreateFormTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is EnquiryCreateFormTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'counselling': return EnquiryCreateFormTypeEnum.counselling;
        case r'callback': return EnquiryCreateFormTypeEnum.callback;
        case r'blog_callback': return EnquiryCreateFormTypeEnum.blogCallback;
        case r'pricing_unlock': return EnquiryCreateFormTypeEnum.pricingUnlock;
        case r'company': return EnquiryCreateFormTypeEnum.company;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static EnquiryCreateFormTypeEnumTypeTransformer? _instance;
}



enum EnquiryCreateSource_Enum {
  website._(r'website'),
  studentApp._(r'student_app'),
  ;

  /// Instantiate a new enum with the provided value.
  const EnquiryCreateSource_Enum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [EnquiryCreateSource_Enum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static EnquiryCreateSource_Enum? fromJson(dynamic value) => EnquiryCreateSource_EnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [EnquiryCreateSource_Enum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<EnquiryCreateSource_Enum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EnquiryCreateSource_Enum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EnquiryCreateSource_Enum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [EnquiryCreateSource_Enum] to String,
/// and [decode] dynamic data back to [EnquiryCreateSource_Enum].
class EnquiryCreateSource_EnumTypeTransformer {
  factory EnquiryCreateSource_EnumTypeTransformer() => _instance ??= const EnquiryCreateSource_EnumTypeTransformer._();

  const EnquiryCreateSource_EnumTypeTransformer._();

  String encode(EnquiryCreateSource_Enum data) => data._value;

  /// Returns the instance of [EnquiryCreateSource_Enum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  EnquiryCreateSource_Enum? decode(dynamic data, {bool allowNull = true}) {
    if (data is EnquiryCreateSource_Enum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'website': return EnquiryCreateSource_Enum.website;
        case r'student_app': return EnquiryCreateSource_Enum.studentApp;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static EnquiryCreateSource_EnumTypeTransformer? _instance;
}


