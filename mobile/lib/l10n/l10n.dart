import 'package:flutter/widgets.dart';

import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart';

/// `context.l10n.retry` instead of `AppLocalizations.of(context).retry`.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// The languages the app speaks (student_app #1, item 8).
enum AppLanguage {
  en,
  hi;

  Locale get locale => Locale(name);

  /// The language's name in its own script, shown on the language picker
  /// whatever language the app is in, so a student who cannot read the
  /// current one still finds their own. It is never translated.
  String get endonym => switch (this) {
    AppLanguage.en => 'English',
    AppLanguage.hi => 'हिन्दी',
  };

  /// The language for [code] (`en`, `hi`), or null.
  static AppLanguage? fromCode(String? code) =>
      code == null ? null : AppLanguage.values.asNameMap()[code];

  /// The language to show when the student has not chosen one: the phone's
  /// first language the app speaks, else English. This is what MaterialApp
  /// would pick, worked out here so the requests' `Accept-Language` agrees
  /// with the screen.
  static AppLanguage fromDevice(List<Locale> deviceLocales) {
    for (final locale in deviceLocales) {
      final language = fromCode(locale.languageCode);
      if (language != null) return language;
    }
    return AppLanguage.en;
  }
}
