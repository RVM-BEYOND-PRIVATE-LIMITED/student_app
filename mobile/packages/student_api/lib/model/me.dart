//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Me {
  /// Returns a new [Me] instance.
  Me({
    required this.id,
    required this.phoneMasked,
    required this.language,
    required this.stage,
    required this.feeFullyPaid,
    required this.isAlumni,
    required this.linkState,
    required this.onboarding,
    required this.counts,
  });

  /// The student's account id. The same id is the student's reference on Campus.
  String id;

  /// The bound phone, for example ••••••0000.
  String phoneMasked;

  MeLanguageEnum language;

  Stage stage;

  bool feeFullyPaid;

  bool isAlumni;

  MeLinkStateEnum linkState;

  MeOnboarding onboarding;

  MeCounts counts;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Me &&
    other.id == id &&
    other.phoneMasked == phoneMasked &&
    other.language == language &&
    other.stage == stage &&
    other.feeFullyPaid == feeFullyPaid &&
    other.isAlumni == isAlumni &&
    other.linkState == linkState &&
    other.onboarding == onboarding &&
    other.counts == counts;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (phoneMasked.hashCode) +
    (language.hashCode) +
    (stage.hashCode) +
    (feeFullyPaid.hashCode) +
    (isAlumni.hashCode) +
    (linkState.hashCode) +
    (onboarding.hashCode) +
    (counts.hashCode);

  @override
  String toString() => 'Me[id=$id, phoneMasked=$phoneMasked, language=$language, stage=$stage, feeFullyPaid=$feeFullyPaid, isAlumni=$isAlumni, linkState=$linkState, onboarding=$onboarding, counts=$counts]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'phone_masked'] = this.phoneMasked;
      json[r'language'] = this.language;
      json[r'stage'] = this.stage;
      json[r'fee_fully_paid'] = this.feeFullyPaid;
      json[r'is_alumni'] = this.isAlumni;
      json[r'link_state'] = this.linkState;
      json[r'onboarding'] = this.onboarding;
      json[r'counts'] = this.counts;
    return json;
  }

  /// Returns a new [Me] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Me? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "Me[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "Me[id]" has a null value in JSON.');
        assert(json.containsKey(r'phone_masked'), 'Required key "Me[phone_masked]" is missing from JSON.');
        assert(json[r'phone_masked'] != null, 'Required key "Me[phone_masked]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "Me[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "Me[language]" has a null value in JSON.');
        assert(json.containsKey(r'stage'), 'Required key "Me[stage]" is missing from JSON.');
        assert(json[r'stage'] != null, 'Required key "Me[stage]" has a null value in JSON.');
        assert(json.containsKey(r'fee_fully_paid'), 'Required key "Me[fee_fully_paid]" is missing from JSON.');
        assert(json[r'fee_fully_paid'] != null, 'Required key "Me[fee_fully_paid]" has a null value in JSON.');
        assert(json.containsKey(r'is_alumni'), 'Required key "Me[is_alumni]" is missing from JSON.');
        assert(json[r'is_alumni'] != null, 'Required key "Me[is_alumni]" has a null value in JSON.');
        assert(json.containsKey(r'link_state'), 'Required key "Me[link_state]" is missing from JSON.');
        assert(json[r'link_state'] != null, 'Required key "Me[link_state]" has a null value in JSON.');
        assert(json.containsKey(r'onboarding'), 'Required key "Me[onboarding]" is missing from JSON.');
        assert(json[r'onboarding'] != null, 'Required key "Me[onboarding]" has a null value in JSON.');
        assert(json.containsKey(r'counts'), 'Required key "Me[counts]" is missing from JSON.');
        assert(json[r'counts'] != null, 'Required key "Me[counts]" has a null value in JSON.');
        return true;
      }());

      return Me(
        id: mapValueOfType<String>(json, r'id')!,
        phoneMasked: mapValueOfType<String>(json, r'phone_masked')!,
        language: MeLanguageEnum.fromJson(json[r'language'])!,
        stage: Stage.fromJson(json[r'stage'])!,
        feeFullyPaid: mapValueOfType<bool>(json, r'fee_fully_paid')!,
        isAlumni: mapValueOfType<bool>(json, r'is_alumni')!,
        linkState: MeLinkStateEnum.fromJson(json[r'link_state'])!,
        onboarding: MeOnboarding.fromJson(json[r'onboarding'])!,
        counts: MeCounts.fromJson(json[r'counts'])!,
      );
    }
    return null;
  }

  static List<Me> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Me>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Me.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Me> mapFromJson(dynamic json) {
    final map = <String, Me>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Me.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Me-objects as value to a dart map
  static Map<String, List<Me>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Me>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Me.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'phone_masked',
    'language',
    'stage',
    'fee_fully_paid',
    'is_alumni',
    'link_state',
    'onboarding',
    'counts',
  };
}


enum MeLanguageEnum {
  en._(r'en'),
  hi._(r'hi'),
  ;

  /// Instantiate a new enum with the provided value.
  const MeLanguageEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [MeLanguageEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static MeLanguageEnum? fromJson(dynamic value) => MeLanguageEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [MeLanguageEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<MeLanguageEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MeLanguageEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MeLanguageEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MeLanguageEnum] to String,
/// and [decode] dynamic data back to [MeLanguageEnum].
class MeLanguageEnumTypeTransformer {
  factory MeLanguageEnumTypeTransformer() => _instance ??= const MeLanguageEnumTypeTransformer._();

  const MeLanguageEnumTypeTransformer._();

  String encode(MeLanguageEnum data) => data._value;

  /// Returns the instance of [MeLanguageEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MeLanguageEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is MeLanguageEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'en': return MeLanguageEnum.en;
        case r'hi': return MeLanguageEnum.hi;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static MeLanguageEnumTypeTransformer? _instance;
}



enum MeLinkStateEnum {
  unlinked._(r'unlinked'),
  requested._(r'requested'),
  linked._(r'linked'),
  ;

  /// Instantiate a new enum with the provided value.
  const MeLinkStateEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [MeLinkStateEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static MeLinkStateEnum? fromJson(dynamic value) => MeLinkStateEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [MeLinkStateEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<MeLinkStateEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MeLinkStateEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MeLinkStateEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MeLinkStateEnum] to String,
/// and [decode] dynamic data back to [MeLinkStateEnum].
class MeLinkStateEnumTypeTransformer {
  factory MeLinkStateEnumTypeTransformer() => _instance ??= const MeLinkStateEnumTypeTransformer._();

  const MeLinkStateEnumTypeTransformer._();

  String encode(MeLinkStateEnum data) => data._value;

  /// Returns the instance of [MeLinkStateEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MeLinkStateEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is MeLinkStateEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'unlinked': return MeLinkStateEnum.unlinked;
        case r'requested': return MeLinkStateEnum.requested;
        case r'linked': return MeLinkStateEnum.linked;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static MeLinkStateEnumTypeTransformer? _instance;
}


