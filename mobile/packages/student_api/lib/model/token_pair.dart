//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TokenPair {
  /// Returns a new [TokenPair] instance.
  TokenPair({
    required this.tokenType,
    required this.accessToken,
    required this.accessExpiresAt,
    this.refreshToken,
    this.refreshExpiresAt,
    required this.sessionId,
  });

  TokenPairTokenTypeEnum tokenType;

  String accessToken;

  DateTime accessExpiresAt;

  /// App only. The web version receives it as a cookie instead.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? refreshToken;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? refreshExpiresAt;

  String sessionId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TokenPair &&
    other.tokenType == tokenType &&
    other.accessToken == accessToken &&
    other.accessExpiresAt == accessExpiresAt &&
    other.refreshToken == refreshToken &&
    other.refreshExpiresAt == refreshExpiresAt &&
    other.sessionId == sessionId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (tokenType.hashCode) +
    (accessToken.hashCode) +
    (accessExpiresAt.hashCode) +
    (refreshToken == null ? 0 : refreshToken!.hashCode) +
    (refreshExpiresAt == null ? 0 : refreshExpiresAt!.hashCode) +
    (sessionId.hashCode);

  @override
  String toString() => 'TokenPair[tokenType=$tokenType, accessToken=$accessToken, accessExpiresAt=$accessExpiresAt, refreshToken=$refreshToken, refreshExpiresAt=$refreshExpiresAt, sessionId=$sessionId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'token_type'] = this.tokenType;
      json[r'access_token'] = this.accessToken;
      json[r'access_expires_at'] = this.accessExpiresAt.toUtc().toIso8601String();
    if (this.refreshToken != null) {
      json[r'refresh_token'] = this.refreshToken;
    } else {
      json[r'refresh_token'] = null;
    }
    if (this.refreshExpiresAt != null) {
      json[r'refresh_expires_at'] = this.refreshExpiresAt!.toUtc().toIso8601String();
    } else {
      json[r'refresh_expires_at'] = null;
    }
      json[r'session_id'] = this.sessionId;
    return json;
  }

  /// Returns a new [TokenPair] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TokenPair? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'token_type'), 'Required key "TokenPair[token_type]" is missing from JSON.');
        assert(json[r'token_type'] != null, 'Required key "TokenPair[token_type]" has a null value in JSON.');
        assert(json.containsKey(r'access_token'), 'Required key "TokenPair[access_token]" is missing from JSON.');
        assert(json[r'access_token'] != null, 'Required key "TokenPair[access_token]" has a null value in JSON.');
        assert(json.containsKey(r'access_expires_at'), 'Required key "TokenPair[access_expires_at]" is missing from JSON.');
        assert(json[r'access_expires_at'] != null, 'Required key "TokenPair[access_expires_at]" has a null value in JSON.');
        assert(json.containsKey(r'session_id'), 'Required key "TokenPair[session_id]" is missing from JSON.');
        assert(json[r'session_id'] != null, 'Required key "TokenPair[session_id]" has a null value in JSON.');
        return true;
      }());

      return TokenPair(
        tokenType: TokenPairTokenTypeEnum.fromJson(json[r'token_type'])!,
        accessToken: mapValueOfType<String>(json, r'access_token')!,
        accessExpiresAt: mapDateTime(json, r'access_expires_at', r'')!,
        refreshToken: mapValueOfType<String>(json, r'refresh_token'),
        refreshExpiresAt: mapDateTime(json, r'refresh_expires_at', r''),
        sessionId: mapValueOfType<String>(json, r'session_id')!,
      );
    }
    return null;
  }

  static List<TokenPair> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TokenPair>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TokenPair.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TokenPair> mapFromJson(dynamic json) {
    final map = <String, TokenPair>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TokenPair.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TokenPair-objects as value to a dart map
  static Map<String, List<TokenPair>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TokenPair>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TokenPair.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'token_type',
    'access_token',
    'access_expires_at',
    'session_id',
  };
}


enum TokenPairTokenTypeEnum {
  bearer._(r'Bearer'),
  ;

  /// Instantiate a new enum with the provided value.
  const TokenPairTokenTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [TokenPairTokenTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static TokenPairTokenTypeEnum? fromJson(dynamic value) => TokenPairTokenTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [TokenPairTokenTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<TokenPairTokenTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TokenPairTokenTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TokenPairTokenTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [TokenPairTokenTypeEnum] to String,
/// and [decode] dynamic data back to [TokenPairTokenTypeEnum].
class TokenPairTokenTypeEnumTypeTransformer {
  factory TokenPairTokenTypeEnumTypeTransformer() => _instance ??= const TokenPairTokenTypeEnumTypeTransformer._();

  const TokenPairTokenTypeEnumTypeTransformer._();

  String encode(TokenPairTokenTypeEnum data) => data._value;

  /// Returns the instance of [TokenPairTokenTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  TokenPairTokenTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is TokenPairTokenTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'Bearer': return TokenPairTokenTypeEnum.bearer;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static TokenPairTokenTypeEnumTypeTransformer? _instance;
}


