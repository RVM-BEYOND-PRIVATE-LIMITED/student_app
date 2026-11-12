import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The bundled fonts' licences (SIL Open Font License 1.1), by family.
const fontLicenseFiles = {
  'Geist, Geist Mono': 'assets/fonts/Geist/OFL.txt',
  'Fraunces': 'assets/fonts/Fraunces/OFL.txt',
  'Noto Sans Devanagari': 'assets/fonts/NotoSansDevanagari/OFL.txt',
};

/// Adds the fonts' licences to the app's licence page, as the Open Font
/// License asks of software that bundles the fonts.
void registerFontLicenses({AssetBundle? bundle}) {
  final assets = bundle ?? rootBundle;
  LicenseRegistry.addLicense(() async* {
    for (final entry in fontLicenseFiles.entries) {
      yield LicenseEntryWithLineBreaks([
        entry.key,
      ], await assets.loadString(entry.value));
    }
  });
}
