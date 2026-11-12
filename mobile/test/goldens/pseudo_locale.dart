import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rvm_student/l10n/gen/app_localizations_hi.dart';
import 'package:rvm_student/l10n/l10n.dart';

/// A test-only long-text locale (student_app #11): the Hindi wording made
/// about 40 % longer with Devanagari that reaches high above and low below
/// the line, inside brackets that show where each string starts and ends.
///
/// A screen that clips, cuts or overflows a long Hindi string shows it in
/// this locale's goldens first. It never ships: it lives under test/ only.
const pseudoLocale = Locale('hi', 'XA');

/// Every word the shared states use, lengthened.
class PseudoLongLocalizations extends AppLocalizationsHi {
  PseudoLongLocalizations() : super('hi');

  /// Marks above (ि ँ ै ॅ) and below (ु ृ ़ ्) the letters.
  static const _filler = ['क्षि', 'ड़ुँ', 'र्कृ', 'ठू', 'ग्रै', 'ॐ', 'ह्यॅ'];

  /// [text] about 40 % longer, bracketed.
  static String lengthen(String text) {
    final extra = (text.characters.length * 0.4).ceil();
    final pad = StringBuffer();
    var i = 0;
    while (pad.toString().characters.length < extra) {
      if (i > 0 && i % 3 == 0) pad.write(' ');
      pad.write(_filler[i % _filler.length]);
      i++;
    }
    return '[$text $pad]';
  }

  @override
  String get loading => lengthen(super.loading);
  @override
  String get retry => lengthen(super.retry);
  @override
  String get requestIdLabel => lengthen(super.requestIdLabel);
  @override
  String get copyRequestId => lengthen(super.copyRequestId);
  @override
  String get copied => lengthen(super.copied);
  @override
  String get offlineBanner => lengthen(super.offlineBanner);
  @override
  String get emptyTitle => lengthen(super.emptyTitle);
  @override
  String get emptyBody => lengthen(super.emptyBody);
  @override
  String get gallerySkeleton => lengthen(super.gallerySkeleton);
  @override
  String get galleryEmpty => lengthen(super.galleryEmpty);
  @override
  String get galleryError => lengthen(super.galleryError);
  @override
  String get galleryOffline => lengthen(super.galleryOffline);
  @override
  String get errorNoConnectionTitle => lengthen(super.errorNoConnectionTitle);
  @override
  String get errorNoConnectionBody => lengthen(super.errorNoConnectionBody);
  @override
  String get errorTimeoutTitle => lengthen(super.errorTimeoutTitle);
  @override
  String get errorTimeoutBody => lengthen(super.errorTimeoutBody);
  @override
  String get errorSessionTitle => lengthen(super.errorSessionTitle);
  @override
  String get errorSessionBody => lengthen(super.errorSessionBody);
  @override
  String get errorForbiddenTitle => lengthen(super.errorForbiddenTitle);
  @override
  String get errorForbiddenBody => lengthen(super.errorForbiddenBody);
  @override
  String get errorNotFoundTitle => lengthen(super.errorNotFoundTitle);
  @override
  String get errorNotFoundBody => lengthen(super.errorNotFoundBody);
  @override
  String get errorTooManyTitle => lengthen(super.errorTooManyTitle);
  @override
  String get errorTooManyBody => lengthen(super.errorTooManyBody);
  @override
  String get errorServerTitle => lengthen(super.errorServerTitle);
  @override
  String get errorServerBody => lengthen(super.errorServerBody);
  @override
  String get errorRequestTitle => lengthen(super.errorRequestTitle);
  @override
  String get errorRequestBody => lengthen(super.errorRequestBody);
  @override
  String get errorParseTitle => lengthen(super.errorParseTitle);
  @override
  String get errorParseBody => lengthen(super.errorParseBody);
  @override
  String get errorUnknownTitle => lengthen(super.errorUnknownTitle);
  @override
  String get errorUnknownBody => lengthen(super.errorUnknownBody);
}

/// Serves [PseudoLongLocalizations] for [pseudoLocale]. List it before
/// `AppLocalizations.delegate`: the first delegate for a type wins.
class PseudoLongLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const PseudoLongLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale == pseudoLocale;

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture<AppLocalizations>(PseudoLongLocalizations());

  @override
  bool shouldReload(PseudoLongLocalizationsDelegate old) => false;
}
