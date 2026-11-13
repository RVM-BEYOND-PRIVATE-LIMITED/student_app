import 'package:core_network/core_network.dart';

/// Takes personal data and secrets out of text before it is kept anywhere
/// (student_app #1, item 12; the repo's rule: never log a phone number,
/// Aadhaar, token or full name).
///
/// core_network's [Redact] already removes phone-like numbers (ten digits or
/// more, so an Aadhaar number too) and the values of name and phone keys.
/// This adds what a student app also handles:
///
/// * tokens: `Bearer …`, anything shaped like a JWT, and the value of any key
///   that names a token, password, OTP, PIN, secret, session or cookie;
/// * one-time codes written after "OTP", "code" or "PIN";
/// * email addresses, wherever they are.
///
/// It only ever removes text, so it is always on.
abstract final class StudentRedact {
  static const mask = Redact.mask;

  static final _bearer = RegExp(
    r'\b(Bearer)\s+[A-Za-z0-9\-._~+/]+=*',
    caseSensitive: false,
  );

  static final _jwt = RegExp(
    r'\beyJ[A-Za-z0-9_-]{4,}\.[A-Za-z0-9_-]{4,}\.[A-Za-z0-9_-]*',
  );

  /// `key=value`, `key: value` or `"key": "value"` for a secret's key.
  static final _secretPair = RegExp(
    r'''(["']?)([A-Za-z0-9_\-]*(?:token|password|passwd|otp|pin|secret|session|cookie|authorization|aadhaar)[A-Za-z0-9_\-]*)\1(\s*[:=]\s*)("[^"]*"|'[^']*'|[^\s,&;}\])"']+)''',
    caseSensitive: false,
  );

  /// A short code right after the word OTP, code or PIN.
  static final _codePhrase = RegExp(
    r'\b(otp|code|pin)\b([^0-9\n]{0,12})(\d{4,8})\b',
    caseSensitive: false,
  );

  /// `name@example.com`: a local part, `@`, and a domain ending in letters.
  static final _email = RegExp(
    r'[A-Za-z0-9._%+\-]+@[A-Za-z0-9\-]+(?:\.[A-Za-z0-9\-]+)*\.[A-Za-z]{2,}\b',
  );

  /// [input] with every secret and every piece of personal data replaced by
  /// [mask].
  static String text(String input) {
    final withoutSecrets = input
        .replaceAllMapped(_bearer, (m) => '${m[1]} $mask')
        .replaceAll(_jwt, mask)
        .replaceAllMapped(_secretPair, (m) {
          final value = m[4]!;
          final quote = value.startsWith('"') || value.startsWith("'")
              ? value[0]
              : '';
          return '${m[1]}${m[2]}${m[1]}${m[3]}$quote$mask$quote';
        })
        .replaceAllMapped(_codePhrase, (m) => '${m[1]}${m[2]}$mask')
        .replaceAll(_email, mask);
    return Redact.text(withoutSecrets);
  }
}
