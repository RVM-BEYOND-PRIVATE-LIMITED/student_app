//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class LinkResult {
  /// Returns a new [LinkResult] instance.
  LinkResult({
    required this.state,
    required this.account,
  });

  LinkResultStateEnum state;

  Me account;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LinkResult &&
    other.state == state &&
    other.account == account;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (state.hashCode) +
    (account.hashCode);

  @override
  String toString() => 'LinkResult[state=$state, account=$account]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'state'] = this.state;
      json[r'account'] = this.account;
    return json;
  }

  /// Returns a new [LinkResult] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LinkResult? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'state'), 'Required key "LinkResult[state]" is missing from JSON.');
        assert(json[r'state'] != null, 'Required key "LinkResult[state]" has a null value in JSON.');
        assert(json.containsKey(r'account'), 'Required key "LinkResult[account]" is missing from JSON.');
        assert(json[r'account'] != null, 'Required key "LinkResult[account]" has a null value in JSON.');
        return true;
      }());

      return LinkResult(
        state: LinkResultStateEnum.fromJson(json[r'state'])!,
        account: Me.fromJson(json[r'account'])!,
      );
    }
    return null;
  }

  static List<LinkResult> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LinkResult>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LinkResult.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LinkResult> mapFromJson(dynamic json) {
    final map = <String, LinkResult>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LinkResult.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LinkResult-objects as value to a dart map
  static Map<String, List<LinkResult>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LinkResult>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LinkResult.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'state',
    'account',
  };
}


enum LinkResultStateEnum {
  linked._(r'linked'),
  needsCentre._(r'needs_centre'),
  requested._(r'requested'),
  ;

  /// Instantiate a new enum with the provided value.
  const LinkResultStateEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [LinkResultStateEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static LinkResultStateEnum? fromJson(dynamic value) => LinkResultStateEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [LinkResultStateEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<LinkResultStateEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LinkResultStateEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LinkResultStateEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [LinkResultStateEnum] to String,
/// and [decode] dynamic data back to [LinkResultStateEnum].
class LinkResultStateEnumTypeTransformer {
  factory LinkResultStateEnumTypeTransformer() => _instance ??= const LinkResultStateEnumTypeTransformer._();

  const LinkResultStateEnumTypeTransformer._();

  String encode(LinkResultStateEnum data) => data._value;

  /// Returns the instance of [LinkResultStateEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  LinkResultStateEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is LinkResultStateEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'linked': return LinkResultStateEnum.linked;
        case r'needs_centre': return LinkResultStateEnum.needsCentre;
        case r'requested': return LinkResultStateEnum.requested;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static LinkResultStateEnumTypeTransformer? _instance;
}


