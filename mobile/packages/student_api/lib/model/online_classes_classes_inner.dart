//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OnlineClassesClassesInner {
  /// Returns a new [OnlineClassesClassesInner] instance.
  OnlineClassesClassesInner({
    required this.id,
    required this.batchId,
    required this.batchName,
    required this.date,
    required this.start,
    required this.end,
    required this.status,
    required this.canJoin,
    required this.reason,
    required this.link,
  });

  String id;

  String batchId;

  String batchName;

  DateTime date;

  String start;

  String end;

  OnlineClassesClassesInnerStatusEnum status;

  bool canJoin;

  OnlineClassesClassesInnerReasonEnum? reason;

  String? link;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OnlineClassesClassesInner &&
    other.id == id &&
    other.batchId == batchId &&
    other.batchName == batchName &&
    other.date == date &&
    other.start == start &&
    other.end == end &&
    other.status == status &&
    other.canJoin == canJoin &&
    other.reason == reason &&
    other.link == link;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (batchId.hashCode) +
    (batchName.hashCode) +
    (date.hashCode) +
    (start.hashCode) +
    (end.hashCode) +
    (status.hashCode) +
    (canJoin.hashCode) +
    (reason == null ? 0 : reason!.hashCode) +
    (link == null ? 0 : link!.hashCode);

  @override
  String toString() => 'OnlineClassesClassesInner[id=$id, batchId=$batchId, batchName=$batchName, date=$date, start=$start, end=$end, status=$status, canJoin=$canJoin, reason=$reason, link=$link]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'batch_id'] = this.batchId;
      json[r'batch_name'] = this.batchName;
      json[r'date'] = _dateFormatter.format(this.date);
      json[r'start'] = this.start;
      json[r'end'] = this.end;
      json[r'status'] = this.status;
      json[r'can_join'] = this.canJoin;
    if (this.reason != null) {
      json[r'reason'] = this.reason;
    } else {
      json[r'reason'] = null;
    }
    if (this.link != null) {
      json[r'link'] = this.link;
    } else {
      json[r'link'] = null;
    }
    return json;
  }

  /// Returns a new [OnlineClassesClassesInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OnlineClassesClassesInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "OnlineClassesClassesInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "OnlineClassesClassesInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'batch_id'), 'Required key "OnlineClassesClassesInner[batch_id]" is missing from JSON.');
        assert(json[r'batch_id'] != null, 'Required key "OnlineClassesClassesInner[batch_id]" has a null value in JSON.');
        assert(json.containsKey(r'batch_name'), 'Required key "OnlineClassesClassesInner[batch_name]" is missing from JSON.');
        assert(json[r'batch_name'] != null, 'Required key "OnlineClassesClassesInner[batch_name]" has a null value in JSON.');
        assert(json.containsKey(r'date'), 'Required key "OnlineClassesClassesInner[date]" is missing from JSON.');
        assert(json[r'date'] != null, 'Required key "OnlineClassesClassesInner[date]" has a null value in JSON.');
        assert(json.containsKey(r'start'), 'Required key "OnlineClassesClassesInner[start]" is missing from JSON.');
        assert(json[r'start'] != null, 'Required key "OnlineClassesClassesInner[start]" has a null value in JSON.');
        assert(json.containsKey(r'end'), 'Required key "OnlineClassesClassesInner[end]" is missing from JSON.');
        assert(json[r'end'] != null, 'Required key "OnlineClassesClassesInner[end]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "OnlineClassesClassesInner[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "OnlineClassesClassesInner[status]" has a null value in JSON.');
        assert(json.containsKey(r'can_join'), 'Required key "OnlineClassesClassesInner[can_join]" is missing from JSON.');
        assert(json[r'can_join'] != null, 'Required key "OnlineClassesClassesInner[can_join]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "OnlineClassesClassesInner[reason]" is missing from JSON.');
        assert(json.containsKey(r'link'), 'Required key "OnlineClassesClassesInner[link]" is missing from JSON.');
        return true;
      }());

      return OnlineClassesClassesInner(
        id: mapValueOfType<String>(json, r'id')!,
        batchId: mapValueOfType<String>(json, r'batch_id')!,
        batchName: mapValueOfType<String>(json, r'batch_name')!,
        date: mapDateTime(json, r'date', r'')!,
        start: mapValueOfType<String>(json, r'start')!,
        end: mapValueOfType<String>(json, r'end')!,
        status: OnlineClassesClassesInnerStatusEnum.fromJson(json[r'status'])!,
        canJoin: mapValueOfType<bool>(json, r'can_join')!,
        reason: OnlineClassesClassesInnerReasonEnum.fromJson(json[r'reason']),
        link: mapValueOfType<String>(json, r'link'),
      );
    }
    return null;
  }

  static List<OnlineClassesClassesInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnlineClassesClassesInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnlineClassesClassesInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OnlineClassesClassesInner> mapFromJson(dynamic json) {
    final map = <String, OnlineClassesClassesInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OnlineClassesClassesInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OnlineClassesClassesInner-objects as value to a dart map
  static Map<String, List<OnlineClassesClassesInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OnlineClassesClassesInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OnlineClassesClassesInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'batch_id',
    'batch_name',
    'date',
    'start',
    'end',
    'status',
    'can_join',
    'reason',
    'link',
  };
}


enum OnlineClassesClassesInnerStatusEnum {
  planned._(r'planned'),
  scheduled._(r'scheduled'),
  rescheduled._(r'rescheduled'),
  cancelled._(r'cancelled'),
  done._(r'done'),
  ;

  /// Instantiate a new enum with the provided value.
  const OnlineClassesClassesInnerStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [OnlineClassesClassesInnerStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static OnlineClassesClassesInnerStatusEnum? fromJson(dynamic value) => OnlineClassesClassesInnerStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [OnlineClassesClassesInnerStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<OnlineClassesClassesInnerStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnlineClassesClassesInnerStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnlineClassesClassesInnerStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [OnlineClassesClassesInnerStatusEnum] to String,
/// and [decode] dynamic data back to [OnlineClassesClassesInnerStatusEnum].
class OnlineClassesClassesInnerStatusEnumTypeTransformer {
  factory OnlineClassesClassesInnerStatusEnumTypeTransformer() => _instance ??= const OnlineClassesClassesInnerStatusEnumTypeTransformer._();

  const OnlineClassesClassesInnerStatusEnumTypeTransformer._();

  String encode(OnlineClassesClassesInnerStatusEnum data) => data._value;

  /// Returns the instance of [OnlineClassesClassesInnerStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  OnlineClassesClassesInnerStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is OnlineClassesClassesInnerStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'planned': return OnlineClassesClassesInnerStatusEnum.planned;
        case r'scheduled': return OnlineClassesClassesInnerStatusEnum.scheduled;
        case r'rescheduled': return OnlineClassesClassesInnerStatusEnum.rescheduled;
        case r'cancelled': return OnlineClassesClassesInnerStatusEnum.cancelled;
        case r'done': return OnlineClassesClassesInnerStatusEnum.done;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static OnlineClassesClassesInnerStatusEnumTypeTransformer? _instance;
}



enum OnlineClassesClassesInnerReasonEnum {
  feeHold._(r'fee_hold'),
  cancelled._(r'cancelled'),
  notReady._(r'not_ready'),
  ;

  /// Instantiate a new enum with the provided value.
  const OnlineClassesClassesInnerReasonEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [OnlineClassesClassesInnerReasonEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static OnlineClassesClassesInnerReasonEnum? fromJson(dynamic value) => OnlineClassesClassesInnerReasonEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [OnlineClassesClassesInnerReasonEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<OnlineClassesClassesInnerReasonEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnlineClassesClassesInnerReasonEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnlineClassesClassesInnerReasonEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [OnlineClassesClassesInnerReasonEnum] to String,
/// and [decode] dynamic data back to [OnlineClassesClassesInnerReasonEnum].
class OnlineClassesClassesInnerReasonEnumTypeTransformer {
  factory OnlineClassesClassesInnerReasonEnumTypeTransformer() => _instance ??= const OnlineClassesClassesInnerReasonEnumTypeTransformer._();

  const OnlineClassesClassesInnerReasonEnumTypeTransformer._();

  String encode(OnlineClassesClassesInnerReasonEnum data) => data._value;

  /// Returns the instance of [OnlineClassesClassesInnerReasonEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  OnlineClassesClassesInnerReasonEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is OnlineClassesClassesInnerReasonEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'fee_hold': return OnlineClassesClassesInnerReasonEnum.feeHold;
        case r'cancelled': return OnlineClassesClassesInnerReasonEnum.cancelled;
        case r'not_ready': return OnlineClassesClassesInnerReasonEnum.notReady;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static OnlineClassesClassesInnerReasonEnumTypeTransformer? _instance;
}


