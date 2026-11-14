import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/l10n/l10n.dart';
import 'package:rvm_student/theme/student_theme.dart';
import 'package:rvm_student/widgets/data_text.dart';

const english = Locale('en');
const hindi = Locale('hi');

/// A small phone, so a widget that overflows on cheap hardware fails here.
const smallPhone = Size(320, 640);

/// Wraps [child] in the app's theme and translations for [locale].
Widget localized(Widget child, {Locale locale = english}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: StudentTheme.forLanguageCode(locale.languageCode),
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: child,
  );
}

/// Sets the test surface to [size] logical pixels for this test.
void useSurface(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
}

/// Every piece of text on screen that contains Latin letters (English),
/// except what [allowed] lists and technical values shown as [DataText].
///
/// Covers drawn text, tooltips and screen-reader labels, so a Hindi screen
/// passes only when nothing a student can see or hear is still English
/// (student_app #1, check 2).
List<String> englishOnScreen(
  WidgetTester tester, {
  Set<String> allowed = const {'RVM'},
}) {
  final latin = RegExp(r'[A-Za-z]');
  final found = <String>[];

  bool insideData(Element element) {
    var inside = false;
    element.visitAncestorElements((ancestor) {
      if (ancestor.widget is DataText) {
        inside = true;
        return false;
      }
      return true;
    });
    return inside;
  }

  void check(String text) {
    var rest = text;
    for (final word in allowed) {
      rest = rest.replaceAll(word, '');
    }
    if (latin.hasMatch(rest)) found.add(text);
  }

  for (final element in find.byType(RichText).evaluate()) {
    if (insideData(element)) continue;
    check((element.widget as RichText).text.toPlainText());
  }
  for (final element in find.byType(Tooltip).evaluate()) {
    final message = (element.widget as Tooltip).message;
    if (message != null) check(message);
  }
  for (final element in find.byType(Semantics).evaluate()) {
    if (insideData(element)) continue;
    final label = (element.widget as Semantics).properties.label;
    if (label != null && label.isNotEmpty) check(label);
  }
  return found;
}
