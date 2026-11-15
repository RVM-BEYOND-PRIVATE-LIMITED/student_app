//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Correction {
  /// Returns a new [Correction] instance.
  Correction({
    required this.id,
    required this.batchId,
    required this.date,
    required this.reason,
    required this.status,
    required this.createdAt,
    required this.decidedAt,
    required this.note,
  });

  String id;

  String batchId;

  DateTime date;

  String reason;

  CorrectionStatusEnum status;

  DateTime createdAt;

  DateTime? decidedAt;

  String? note;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Correction &&
    other.id == id &&
    other.batchId == batchId &&
    other.date == date &&
    other.reason == reason &&
    other.status == status &&
    other.createdAt == createdAt &&
    other.decidedAt == decidedAt &&
    other.note == note;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (batchId.hashCode) +
    (date.hashCode) +
    (reason.hashCode) +
    (status.hashCode) +
    (createdAt.hashCode) +
    (decidedAt == null ? 0 : decidedAt!.hashCode) +
    (note == null ? 0 : note!.hashCode);

  @override
  String toString() => 'Correction[id=$id, batchId=$batchId, date=$date, reason=$reason, status=$status, createdAt=$createdAt, decidedAt=$decidedAt, note=$note]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'batch_id'] = this.batchId;
      json[r'date'] = _dateFormatter.format(this.date);
      json[r'reason'] = this.reason;
      json[r'status'] = this.status;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.decidedAt != null) {
      json[r'decided_at'] = this.decidedAt!.toUtc().toIso8601String();
    } else {
      json[r'decided_at'] = null;
    }
    if (this.note != null) {
      json[r'note'] = this.note;
    } else {
      json[r'note'] = null;
    }
    return json;
  }

  /// Returns a new [Correction] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Correction? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "Correction[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "Correction[id]" has a null value in JSON.');
        assert(json.containsKey(r'batch_id'), 'Required key "Correction[batch_id]" is missing from JSON.');
        assert(json[r'batch_id'] != null, 'Required key "Correction[batch_id]" has a null value in JSON.');
        assert(json.containsKey(r'date'), 'Required key "Correction[date]" is missing from JSON.');
        assert(json[r'date'] != null, 'Required key "Correction[date]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "Correction[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "Correction[reason]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "Correction[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "Correction[status]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'), 'Required key "Correction[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null, 'Required key "Correction[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'decided_at'), 'Required key "Correction[decided_at]" is missing from JSON.');
        assert(json.containsKey(r'note'), 'Required key "Correction[note]" is missing from JSON.');
        return true;
      }());

      return Correction(
        id: mapValueOfType<String>(json, r'id')!,
        batchId: mapValueOfType<String>(json, r'batch_id')!,
        date: mapDateTime(json, r'date', r'')!,
        reason: mapValueOfType<String>(json, r'reason')!,
        status: CorrectionStatusEnum.fromJson(json[r'status'])!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        decidedAt: mapDateTime(json, r'decided_at', r''),
        note: mapValueOfType<String>(json, r'note'),
      );
    }
    return null;
  }

  static List<Correction> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Correction>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Correction.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Correction> mapFromJson(dynamic json) {
    final map = <String, Correction>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Correction.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Correction-objects as value to a dart map
  static Map<String, List<Correction>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Correction>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Correction.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'batch_id',
    'date',
    'reason',
    'status',
    'created_at',
    'decided_at',
    'note',
  };
}


enum CorrectionStatusEnum {
  open._(r'open'),
  approved._(r'approved'),
  rejected._(r'rejected'),
  ;

  /// Instantiate a new enum with the provided value.
  const CorrectionStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CorrectionStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CorrectionStatusEnum? fromJson(dynamic value) => CorrectionStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CorrectionStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CorrectionStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CorrectionStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CorrectionStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CorrectionStatusEnum] to String,
/// and [decode] dynamic data back to [CorrectionStatusEnum].
class CorrectionStatusEnumTypeTransformer {
  factory CorrectionStatusEnumTypeTransformer() => _instance ??= const CorrectionStatusEnumTypeTransformer._();

  const CorrectionStatusEnumTypeTransformer._();

  String encode(CorrectionStatusEnum data) => data._value;

  /// Returns the instance of [CorrectionStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CorrectionStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CorrectionStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'open': return CorrectionStatusEnum.open;
        case r'approved': return CorrectionStatusEnum.approved;
        case r'rejected': return CorrectionStatusEnum.rejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CorrectionStatusEnumTypeTransformer? _instance;
}


