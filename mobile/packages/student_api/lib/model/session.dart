//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Session {
  /// Returns a new [Session] instance.
  Session({
    required this.id,
    required this.clientKind,
    required this.platform,
    required this.createdAt,
    required this.lastUsedAt,
    required this.current,
  });

  String id;

  SessionClientKindEnum clientKind;

  SessionPlatformEnum platform;

  DateTime createdAt;

  DateTime lastUsedAt;

  bool current;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Session &&
    other.id == id &&
    other.clientKind == clientKind &&
    other.platform == platform &&
    other.createdAt == createdAt &&
    other.lastUsedAt == lastUsedAt &&
    other.current == current;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (clientKind.hashCode) +
    (platform.hashCode) +
    (createdAt.hashCode) +
    (lastUsedAt.hashCode) +
    (current.hashCode);

  @override
  String toString() => 'Session[id=$id, clientKind=$clientKind, platform=$platform, createdAt=$createdAt, lastUsedAt=$lastUsedAt, current=$current]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'client_kind'] = this.clientKind;
      json[r'platform'] = this.platform;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'last_used_at'] = this.lastUsedAt.toUtc().toIso8601String();
      json[r'current'] = this.current;
    return json;
  }

  /// Returns a new [Session] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Session? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "Session[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "Session[id]" has a null value in JSON.');
        assert(json.containsKey(r'client_kind'), 'Required key "Session[client_kind]" is missing from JSON.');
        assert(json[r'client_kind'] != null, 'Required key "Session[client_kind]" has a null value in JSON.');
        assert(json.containsKey(r'platform'), 'Required key "Session[platform]" is missing from JSON.');
        assert(json[r'platform'] != null, 'Required key "Session[platform]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'), 'Required key "Session[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null, 'Required key "Session[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'last_used_at'), 'Required key "Session[last_used_at]" is missing from JSON.');
        assert(json[r'last_used_at'] != null, 'Required key "Session[last_used_at]" has a null value in JSON.');
        assert(json.containsKey(r'current'), 'Required key "Session[current]" is missing from JSON.');
        assert(json[r'current'] != null, 'Required key "Session[current]" has a null value in JSON.');
        return true;
      }());

      return Session(
        id: mapValueOfType<String>(json, r'id')!,
        clientKind: SessionClientKindEnum.fromJson(json[r'client_kind'])!,
        platform: SessionPlatformEnum.fromJson(json[r'platform'])!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        lastUsedAt: mapDateTime(json, r'last_used_at', r'')!,
        current: mapValueOfType<bool>(json, r'current')!,
      );
    }
    return null;
  }

  static List<Session> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Session>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Session.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Session> mapFromJson(dynamic json) {
    final map = <String, Session>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Session.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Session-objects as value to a dart map
  static Map<String, List<Session>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Session>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Session.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'client_kind',
    'platform',
    'created_at',
    'last_used_at',
    'current',
  };
}


enum SessionClientKindEnum {
  app._(r'app'),
  web._(r'web'),
  ;

  /// Instantiate a new enum with the provided value.
  const SessionClientKindEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [SessionClientKindEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static SessionClientKindEnum? fromJson(dynamic value) => SessionClientKindEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [SessionClientKindEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<SessionClientKindEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SessionClientKindEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SessionClientKindEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [SessionClientKindEnum] to String,
/// and [decode] dynamic data back to [SessionClientKindEnum].
class SessionClientKindEnumTypeTransformer {
  factory SessionClientKindEnumTypeTransformer() => _instance ??= const SessionClientKindEnumTypeTransformer._();

  const SessionClientKindEnumTypeTransformer._();

  String encode(SessionClientKindEnum data) => data._value;

  /// Returns the instance of [SessionClientKindEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  SessionClientKindEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is SessionClientKindEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'app': return SessionClientKindEnum.app;
        case r'web': return SessionClientKindEnum.web;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static SessionClientKindEnumTypeTransformer? _instance;
}



enum SessionPlatformEnum {
  android._(r'android'),
  ios._(r'ios'),
  web._(r'web'),
  ;

  /// Instantiate a new enum with the provided value.
  const SessionPlatformEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [SessionPlatformEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static SessionPlatformEnum? fromJson(dynamic value) => SessionPlatformEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [SessionPlatformEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<SessionPlatformEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SessionPlatformEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SessionPlatformEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [SessionPlatformEnum] to String,
/// and [decode] dynamic data back to [SessionPlatformEnum].
class SessionPlatformEnumTypeTransformer {
  factory SessionPlatformEnumTypeTransformer() => _instance ??= const SessionPlatformEnumTypeTransformer._();

  const SessionPlatformEnumTypeTransformer._();

  String encode(SessionPlatformEnum data) => data._value;

  /// Returns the instance of [SessionPlatformEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  SessionPlatformEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is SessionPlatformEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'android': return SessionPlatformEnum.android;
        case r'ios': return SessionPlatformEnum.ios;
        case r'web': return SessionPlatformEnum.web;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static SessionPlatformEnumTypeTransformer? _instance;
}


