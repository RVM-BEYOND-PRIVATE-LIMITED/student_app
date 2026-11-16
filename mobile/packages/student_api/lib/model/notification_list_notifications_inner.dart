//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class NotificationListNotificationsInner {
  /// Returns a new [NotificationListNotificationsInner] instance.
  NotificationListNotificationsInner({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.route,
    required this.createdAt,
    required this.read,
  });

  String id;

  NotificationListNotificationsInnerCategoryEnum category;

  String title;

  String body;

  String? route;

  DateTime createdAt;

  bool read;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NotificationListNotificationsInner &&
    other.id == id &&
    other.category == category &&
    other.title == title &&
    other.body == body &&
    other.route == route &&
    other.createdAt == createdAt &&
    other.read == read;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (category.hashCode) +
    (title.hashCode) +
    (body.hashCode) +
    (route == null ? 0 : route!.hashCode) +
    (createdAt.hashCode) +
    (read.hashCode);

  @override
  String toString() => 'NotificationListNotificationsInner[id=$id, category=$category, title=$title, body=$body, route=$route, createdAt=$createdAt, read=$read]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'category'] = this.category;
      json[r'title'] = this.title;
      json[r'body'] = this.body;
    if (this.route != null) {
      json[r'route'] = this.route;
    } else {
      json[r'route'] = null;
    }
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'read'] = this.read;
    return json;
  }

  /// Returns a new [NotificationListNotificationsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static NotificationListNotificationsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "NotificationListNotificationsInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "NotificationListNotificationsInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'category'), 'Required key "NotificationListNotificationsInner[category]" is missing from JSON.');
        assert(json[r'category'] != null, 'Required key "NotificationListNotificationsInner[category]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "NotificationListNotificationsInner[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "NotificationListNotificationsInner[title]" has a null value in JSON.');
        assert(json.containsKey(r'body'), 'Required key "NotificationListNotificationsInner[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "NotificationListNotificationsInner[body]" has a null value in JSON.');
        assert(json.containsKey(r'route'), 'Required key "NotificationListNotificationsInner[route]" is missing from JSON.');
        assert(json.containsKey(r'created_at'), 'Required key "NotificationListNotificationsInner[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null, 'Required key "NotificationListNotificationsInner[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'read'), 'Required key "NotificationListNotificationsInner[read]" is missing from JSON.');
        assert(json[r'read'] != null, 'Required key "NotificationListNotificationsInner[read]" has a null value in JSON.');
        return true;
      }());

      return NotificationListNotificationsInner(
        id: mapValueOfType<String>(json, r'id')!,
        category: NotificationListNotificationsInnerCategoryEnum.fromJson(json[r'category'])!,
        title: mapValueOfType<String>(json, r'title')!,
        body: mapValueOfType<String>(json, r'body')!,
        route: mapValueOfType<String>(json, r'route'),
        createdAt: mapDateTime(json, r'created_at', r'')!,
        read: mapValueOfType<bool>(json, r'read')!,
      );
    }
    return null;
  }

  static List<NotificationListNotificationsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NotificationListNotificationsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NotificationListNotificationsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NotificationListNotificationsInner> mapFromJson(dynamic json) {
    final map = <String, NotificationListNotificationsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = NotificationListNotificationsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NotificationListNotificationsInner-objects as value to a dart map
  static Map<String, List<NotificationListNotificationsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NotificationListNotificationsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NotificationListNotificationsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'category',
    'title',
    'body',
    'route',
    'created_at',
    'read',
  };
}


enum NotificationListNotificationsInnerCategoryEnum {
  classes._(r'classes'),
  fees._(r'fees'),
  complaints._(r'complaints'),
  community._(r'community'),
  placement._(r'placement'),
  account._(r'account'),
  ;

  /// Instantiate a new enum with the provided value.
  const NotificationListNotificationsInnerCategoryEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [NotificationListNotificationsInnerCategoryEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static NotificationListNotificationsInnerCategoryEnum? fromJson(dynamic value) => NotificationListNotificationsInnerCategoryEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [NotificationListNotificationsInnerCategoryEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<NotificationListNotificationsInnerCategoryEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NotificationListNotificationsInnerCategoryEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NotificationListNotificationsInnerCategoryEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [NotificationListNotificationsInnerCategoryEnum] to String,
/// and [decode] dynamic data back to [NotificationListNotificationsInnerCategoryEnum].
class NotificationListNotificationsInnerCategoryEnumTypeTransformer {
  factory NotificationListNotificationsInnerCategoryEnumTypeTransformer() => _instance ??= const NotificationListNotificationsInnerCategoryEnumTypeTransformer._();

  const NotificationListNotificationsInnerCategoryEnumTypeTransformer._();

  String encode(NotificationListNotificationsInnerCategoryEnum data) => data._value;

  /// Returns the instance of [NotificationListNotificationsInnerCategoryEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  NotificationListNotificationsInnerCategoryEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is NotificationListNotificationsInnerCategoryEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'classes': return NotificationListNotificationsInnerCategoryEnum.classes;
        case r'fees': return NotificationListNotificationsInnerCategoryEnum.fees;
        case r'complaints': return NotificationListNotificationsInnerCategoryEnum.complaints;
        case r'community': return NotificationListNotificationsInnerCategoryEnum.community;
        case r'placement': return NotificationListNotificationsInnerCategoryEnum.placement;
        case r'account': return NotificationListNotificationsInnerCategoryEnum.account;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static NotificationListNotificationsInnerCategoryEnumTypeTransformer? _instance;
}


