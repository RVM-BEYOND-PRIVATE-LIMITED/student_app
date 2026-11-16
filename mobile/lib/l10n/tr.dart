import 'package:flutter/widgets.dart';

/// A short, screen-local English/Hindi pair for the Stage 3/4 modules. The
/// Stage 1A screens use the generated `AppLocalizations`; these modules keep
/// their copy beside the screen so a new label cannot land in English only.
String tr(BuildContext context, String en, String hi) =>
    Localizations.localeOf(context).languageCode == 'hi' ? hi : en;
