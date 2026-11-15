//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AnnouncementListAnnouncementsInner {
  /// Returns a new [AnnouncementListAnnouncementsInner] instance.
  AnnouncementListAnnouncementsInner({
    required this.id,
    required this.title,
    required this.message,
    required this.scope,
    required this.batchId,
    required this.createdAt,
  });

  String id;

  String title;

  String message;

  AnnouncementListAnnouncementsInnerScopeEnum scope;

  String? batchId;

  DateTime createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AnnouncementListAnnouncementsInner &&
    other.id == id &&
    other.title == title &&
    other.message == message &&
    other.scope == scope &&
    other.batchId == batchId &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (message.hashCode) +
    (scope.hashCode) +
    (batchId == null ? 0 : batchId!.hashCode) +
    (createdAt.hashCode);

  @override
  String toString() => 'AnnouncementListAnnouncementsInner[id=$id, title=$title, message=$message, scope=$scope, batchId=$batchId, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'message'] = this.message;
      json[r'scope'] = this.scope;
    if (this.batchId != null) {
      json[r'batch_id'] = this.batchId;
    } else {
      json[r'batch_id'] = null;
    }
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [AnnouncementListAnnouncementsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AnnouncementListAnnouncementsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AnnouncementListAnnouncementsInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AnnouncementListAnnouncementsInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "AnnouncementListAnnouncementsInner[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "AnnouncementListAnnouncementsInner[title]" has a null value in JSON.');
        assert(json.containsKey(r'message'), 'Required key "AnnouncementListAnnouncementsInner[message]" is missing from JSON.');
        assert(json[r'message'] != null, 'Required key "AnnouncementListAnnouncementsInner[message]" has a null value in JSON.');
        assert(json.containsKey(r'scope'), 'Required key "AnnouncementListAnnouncementsInner[scope]" is missing from JSON.');
        assert(json[r'scope'] != null, 'Required key "AnnouncementListAnnouncementsInner[scope]" has a null value in JSON.');
        assert(json.containsKey(r'batch_id'), 'Required key "AnnouncementListAnnouncementsInner[batch_id]" is missing from JSON.');
        assert(json.containsKey(r'created_at'), 'Required key "AnnouncementListAnnouncementsInner[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null, 'Required key "AnnouncementListAnnouncementsInner[created_at]" has a null value in JSON.');
        return true;
      }());

      return AnnouncementListAnnouncementsInner(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        message: mapValueOfType<String>(json, r'message')!,
        scope: AnnouncementListAnnouncementsInnerScopeEnum.fromJson(json[r'scope'])!,
        batchId: mapValueOfType<String>(json, r'batch_id'),
        createdAt: mapDateTime(json, r'created_at', r'')!,
      );
    }
    return null;
  }

  static List<AnnouncementListAnnouncementsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AnnouncementListAnnouncementsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AnnouncementListAnnouncementsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AnnouncementListAnnouncementsInner> mapFromJson(dynamic json) {
    final map = <String, AnnouncementListAnnouncementsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AnnouncementListAnnouncementsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AnnouncementListAnnouncementsInner-objects as value to a dart map
  static Map<String, List<AnnouncementListAnnouncementsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AnnouncementListAnnouncementsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AnnouncementListAnnouncementsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'message',
    'scope',
    'batch_id',
    'created_at',
  };
}


enum AnnouncementListAnnouncementsInnerScopeEnum {
  all._(r'all'),
  batch._(r'batch'),
  ;

  /// Instantiate a new enum with the provided value.
  const AnnouncementListAnnouncementsInnerScopeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AnnouncementListAnnouncementsInnerScopeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AnnouncementListAnnouncementsInnerScopeEnum? fromJson(dynamic value) => AnnouncementListAnnouncementsInnerScopeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AnnouncementListAnnouncementsInnerScopeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AnnouncementListAnnouncementsInnerScopeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AnnouncementListAnnouncementsInnerScopeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AnnouncementListAnnouncementsInnerScopeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AnnouncementListAnnouncementsInnerScopeEnum] to String,
/// and [decode] dynamic data back to [AnnouncementListAnnouncementsInnerScopeEnum].
class AnnouncementListAnnouncementsInnerScopeEnumTypeTransformer {
  factory AnnouncementListAnnouncementsInnerScopeEnumTypeTransformer() => _instance ??= const AnnouncementListAnnouncementsInnerScopeEnumTypeTransformer._();

  const AnnouncementListAnnouncementsInnerScopeEnumTypeTransformer._();

  String encode(AnnouncementListAnnouncementsInnerScopeEnum data) => data._value;

  /// Returns the instance of [AnnouncementListAnnouncementsInnerScopeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AnnouncementListAnnouncementsInnerScopeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AnnouncementListAnnouncementsInnerScopeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'all': return AnnouncementListAnnouncementsInnerScopeEnum.all;
        case r'batch': return AnnouncementListAnnouncementsInnerScopeEnum.batch;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AnnouncementListAnnouncementsInnerScopeEnumTypeTransformer? _instance;
}


