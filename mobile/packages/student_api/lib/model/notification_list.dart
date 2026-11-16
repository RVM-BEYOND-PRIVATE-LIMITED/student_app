//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class NotificationList {
  /// Returns a new [NotificationList] instance.
  NotificationList({
    required this.unread,
    this.notifications = const [],
  });

  /// Minimum value: 0
  int unread;

  List<NotificationListNotificationsInner> notifications;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NotificationList &&
    other.unread == unread &&
    _deepEquality.equals(other.notifications, notifications);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (unread.hashCode) +
    (notifications.hashCode);

  @override
  String toString() => 'NotificationList[unread=$unread, notifications=$notifications]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'unread'] = this.unread;
      json[r'notifications'] = this.notifications;
    return json;
  }

  /// Returns a new [NotificationList] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static NotificationList? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'unread'), 'Required key "NotificationList[unread]" is missing from JSON.');
        assert(json[r'unread'] != null, 'Required key "NotificationList[unread]" has a null value in JSON.');
        assert(json.containsKey(r'notifications'), 'Required key "NotificationList[notifications]" is missing from JSON.');
        assert(json[r'notifications'] != null, 'Required key "NotificationList[notifications]" has a null value in JSON.');
        return true;
      }());

      return NotificationList(
        unread: mapValueOfType<int>(json, r'unread')!,
        notifications: NotificationListNotificationsInner.listFromJson(json[r'notifications']),
      );
    }
    return null;
  }

  static List<NotificationList> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NotificationList>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NotificationList.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NotificationList> mapFromJson(dynamic json) {
    final map = <String, NotificationList>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = NotificationList.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NotificationList-objects as value to a dart map
  static Map<String, List<NotificationList>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NotificationList>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NotificationList.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'unread',
    'notifications',
  };
}

