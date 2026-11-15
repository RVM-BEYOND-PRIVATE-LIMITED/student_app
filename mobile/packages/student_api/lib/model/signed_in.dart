//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SignedIn {
  /// Returns a new [SignedIn] instance.
  SignedIn({
    required this.tokens,
    required this.account,
    required this.created,
  });

  TokenPair tokens;

  Me account;

  /// True when this sign-in made the account.
  bool created;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SignedIn &&
    other.tokens == tokens &&
    other.account == account &&
    other.created == created;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (tokens.hashCode) +
    (account.hashCode) +
    (created.hashCode);

  @override
  String toString() => 'SignedIn[tokens=$tokens, account=$account, created=$created]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'tokens'] = this.tokens;
      json[r'account'] = this.account;
      json[r'created'] = this.created;
    return json;
  }

  /// Returns a new [SignedIn] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SignedIn? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'tokens'), 'Required key "SignedIn[tokens]" is missing from JSON.');
        assert(json[r'tokens'] != null, 'Required key "SignedIn[tokens]" has a null value in JSON.');
        assert(json.containsKey(r'account'), 'Required key "SignedIn[account]" is missing from JSON.');
        assert(json[r'account'] != null, 'Required key "SignedIn[account]" has a null value in JSON.');
        assert(json.containsKey(r'created'), 'Required key "SignedIn[created]" is missing from JSON.');
        assert(json[r'created'] != null, 'Required key "SignedIn[created]" has a null value in JSON.');
        return true;
      }());

      return SignedIn(
        tokens: TokenPair.fromJson(json[r'tokens'])!,
        account: Me.fromJson(json[r'account'])!,
        created: mapValueOfType<bool>(json, r'created')!,
      );
    }
    return null;
  }

  static List<SignedIn> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SignedIn>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SignedIn.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SignedIn> mapFromJson(dynamic json) {
    final map = <String, SignedIn>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SignedIn.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SignedIn-objects as value to a dart map
  static Map<String, List<SignedIn>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SignedIn>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SignedIn.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'tokens',
    'account',
    'created',
  };
}

