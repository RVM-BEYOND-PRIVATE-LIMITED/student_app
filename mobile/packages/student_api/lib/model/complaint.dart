//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Complaint {
  /// Returns a new [Complaint] instance.
  Complaint({
    required this.id,
    required this.ref,
    required this.category,
    required this.categoryName,
    required this.status,
    required this.description,
    required this.createdAt,
    required this.replyDueAt,
    required this.resolveDueAt,
    required this.answered,
    required this.resolvedAt,
    required this.reopenUntil,
    required this.canReopen,
    required this.reopenCount,
    required this.lastActivityAt,
    this.earlierCourse,
  });

  String id;

  /// Quote it to the centre, for example C-2612-00012.
  String ref;

  String category;

  String categoryName;

  ComplaintStatusEnum status;

  String description;

  DateTime createdAt;

  /// When the centre should have replied.
  DateTime replyDueAt;

  /// When it should be resolved; after this it goes to the Head of Operations.
  DateTime resolveDueAt;

  /// Whether staff have replied.
  bool answered;

  DateTime? resolvedAt;

  /// Resolved or closed only.
  DateTime? reopenUntil;

  bool canReopen;

  /// Minimum value: 0
  int reopenCount;

  DateTime lastActivityAt;

  /// On the list only (0.34.0): raised under an earlier admission, the course the student left midway.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? earlierCourse;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Complaint &&
    other.id == id &&
    other.ref == ref &&
    other.category == category &&
    other.categoryName == categoryName &&
    other.status == status &&
    other.description == description &&
    other.createdAt == createdAt &&
    other.replyDueAt == replyDueAt &&
    other.resolveDueAt == resolveDueAt &&
    other.answered == answered &&
    other.resolvedAt == resolvedAt &&
    other.reopenUntil == reopenUntil &&
    other.canReopen == canReopen &&
    other.reopenCount == reopenCount &&
    other.lastActivityAt == lastActivityAt &&
    other.earlierCourse == earlierCourse;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (ref.hashCode) +
    (category.hashCode) +
    (categoryName.hashCode) +
    (status.hashCode) +
    (description.hashCode) +
    (createdAt.hashCode) +
    (replyDueAt.hashCode) +
    (resolveDueAt.hashCode) +
    (answered.hashCode) +
    (resolvedAt == null ? 0 : resolvedAt!.hashCode) +
    (reopenUntil == null ? 0 : reopenUntil!.hashCode) +
    (canReopen.hashCode) +
    (reopenCount.hashCode) +
    (lastActivityAt.hashCode) +
    (earlierCourse == null ? 0 : earlierCourse!.hashCode);

  @override
  String toString() => 'Complaint[id=$id, ref=$ref, category=$category, categoryName=$categoryName, status=$status, description=$description, createdAt=$createdAt, replyDueAt=$replyDueAt, resolveDueAt=$resolveDueAt, answered=$answered, resolvedAt=$resolvedAt, reopenUntil=$reopenUntil, canReopen=$canReopen, reopenCount=$reopenCount, lastActivityAt=$lastActivityAt, earlierCourse=$earlierCourse]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'ref'] = this.ref;
      json[r'category'] = this.category;
      json[r'category_name'] = this.categoryName;
      json[r'status'] = this.status;
      json[r'description'] = this.description;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'reply_due_at'] = this.replyDueAt.toUtc().toIso8601String();
      json[r'resolve_due_at'] = this.resolveDueAt.toUtc().toIso8601String();
      json[r'answered'] = this.answered;
    if (this.resolvedAt != null) {
      json[r'resolved_at'] = this.resolvedAt!.toUtc().toIso8601String();
    } else {
      json[r'resolved_at'] = null;
    }
    if (this.reopenUntil != null) {
      json[r'reopen_until'] = this.reopenUntil!.toUtc().toIso8601String();
    } else {
      json[r'reopen_until'] = null;
    }
      json[r'can_reopen'] = this.canReopen;
      json[r'reopen_count'] = this.reopenCount;
      json[r'last_activity_at'] = this.lastActivityAt.toUtc().toIso8601String();
    if (this.earlierCourse != null) {
      json[r'earlier_course'] = this.earlierCourse;
    } else {
      json[r'earlier_course'] = null;
    }
    return json;
  }

  /// Returns a new [Complaint] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Complaint? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "Complaint[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "Complaint[id]" has a null value in JSON.');
        assert(json.containsKey(r'ref'), 'Required key "Complaint[ref]" is missing from JSON.');
        assert(json[r'ref'] != null, 'Required key "Complaint[ref]" has a null value in JSON.');
        assert(json.containsKey(r'category'), 'Required key "Complaint[category]" is missing from JSON.');
        assert(json[r'category'] != null, 'Required key "Complaint[category]" has a null value in JSON.');
        assert(json.containsKey(r'category_name'), 'Required key "Complaint[category_name]" is missing from JSON.');
        assert(json[r'category_name'] != null, 'Required key "Complaint[category_name]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "Complaint[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "Complaint[status]" has a null value in JSON.');
        assert(json.containsKey(r'description'), 'Required key "Complaint[description]" is missing from JSON.');
        assert(json[r'description'] != null, 'Required key "Complaint[description]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'), 'Required key "Complaint[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null, 'Required key "Complaint[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'reply_due_at'), 'Required key "Complaint[reply_due_at]" is missing from JSON.');
        assert(json[r'reply_due_at'] != null, 'Required key "Complaint[reply_due_at]" has a null value in JSON.');
        assert(json.containsKey(r'resolve_due_at'), 'Required key "Complaint[resolve_due_at]" is missing from JSON.');
        assert(json[r'resolve_due_at'] != null, 'Required key "Complaint[resolve_due_at]" has a null value in JSON.');
        assert(json.containsKey(r'answered'), 'Required key "Complaint[answered]" is missing from JSON.');
        assert(json[r'answered'] != null, 'Required key "Complaint[answered]" has a null value in JSON.');
        assert(json.containsKey(r'resolved_at'), 'Required key "Complaint[resolved_at]" is missing from JSON.');
        assert(json.containsKey(r'reopen_until'), 'Required key "Complaint[reopen_until]" is missing from JSON.');
        assert(json.containsKey(r'can_reopen'), 'Required key "Complaint[can_reopen]" is missing from JSON.');
        assert(json[r'can_reopen'] != null, 'Required key "Complaint[can_reopen]" has a null value in JSON.');
        assert(json.containsKey(r'reopen_count'), 'Required key "Complaint[reopen_count]" is missing from JSON.');
        assert(json[r'reopen_count'] != null, 'Required key "Complaint[reopen_count]" has a null value in JSON.');
        assert(json.containsKey(r'last_activity_at'), 'Required key "Complaint[last_activity_at]" is missing from JSON.');
        assert(json[r'last_activity_at'] != null, 'Required key "Complaint[last_activity_at]" has a null value in JSON.');
        return true;
      }());

      return Complaint(
        id: mapValueOfType<String>(json, r'id')!,
        ref: mapValueOfType<String>(json, r'ref')!,
        category: mapValueOfType<String>(json, r'category')!,
        categoryName: mapValueOfType<String>(json, r'category_name')!,
        status: ComplaintStatusEnum.fromJson(json[r'status'])!,
        description: mapValueOfType<String>(json, r'description')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        replyDueAt: mapDateTime(json, r'reply_due_at', r'')!,
        resolveDueAt: mapDateTime(json, r'resolve_due_at', r'')!,
        answered: mapValueOfType<bool>(json, r'answered')!,
        resolvedAt: mapDateTime(json, r'resolved_at', r''),
        reopenUntil: mapDateTime(json, r'reopen_until', r''),
        canReopen: mapValueOfType<bool>(json, r'can_reopen')!,
        reopenCount: mapValueOfType<int>(json, r'reopen_count')!,
        lastActivityAt: mapDateTime(json, r'last_activity_at', r'')!,
        earlierCourse: mapValueOfType<bool>(json, r'earlier_course'),
      );
    }
    return null;
  }

  static List<Complaint> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Complaint>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Complaint.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Complaint> mapFromJson(dynamic json) {
    final map = <String, Complaint>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Complaint.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Complaint-objects as value to a dart map
  static Map<String, List<Complaint>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Complaint>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Complaint.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'ref',
    'category',
    'category_name',
    'status',
    'description',
    'created_at',
    'reply_due_at',
    'resolve_due_at',
    'answered',
    'resolved_at',
    'reopen_until',
    'can_reopen',
    'reopen_count',
    'last_activity_at',
  };
}


enum ComplaintStatusEnum {
  open._(r'open'),
  inProgress._(r'in_progress'),
  resolved._(r'resolved'),
  closed._(r'closed'),
  ;

  /// Instantiate a new enum with the provided value.
  const ComplaintStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ComplaintStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ComplaintStatusEnum? fromJson(dynamic value) => ComplaintStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ComplaintStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ComplaintStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ComplaintStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ComplaintStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ComplaintStatusEnum] to String,
/// and [decode] dynamic data back to [ComplaintStatusEnum].
class ComplaintStatusEnumTypeTransformer {
  factory ComplaintStatusEnumTypeTransformer() => _instance ??= const ComplaintStatusEnumTypeTransformer._();

  const ComplaintStatusEnumTypeTransformer._();

  String encode(ComplaintStatusEnum data) => data._value;

  /// Returns the instance of [ComplaintStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ComplaintStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ComplaintStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'open': return ComplaintStatusEnum.open;
        case r'in_progress': return ComplaintStatusEnum.inProgress;
        case r'resolved': return ComplaintStatusEnum.resolved;
        case r'closed': return ComplaintStatusEnum.closed;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ComplaintStatusEnumTypeTransformer? _instance;
}


