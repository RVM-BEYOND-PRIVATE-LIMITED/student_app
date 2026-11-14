import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/crash/crash_log.dart';
import 'l10n/gen/app_localizations.dart';
import 'theme/student_tokens.dart';

/// Sends every uncaught error to [CrashLog] (student_app #1, item 12), the
/// Team app's three hooks (rvm_team_app lib/main.dart) without Crashlytics:
///
/// * `FlutterError.onError` for framework errors;
/// * `PlatformDispatcher.onError` for errors no zone caught;
/// * the `runZonedGuarded` handler in `main.dart`, through [recordZoneError].
///
/// A debug build also prints framework errors in full, as Flutter does by
/// default. A release build prints nothing: the record is cleaned and kept on
/// the phone.
void installCrashCapture(CrashLogStore store) {
  CrashLog.store = store;
  FlutterError.onError = (details) {
    if (kDebugMode) FlutterError.presentError(details);
    unawaited(
      CrashLog.record(
        details.exception,
        details.stack,
        kind: CrashKind.flutter,
      ),
    );
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    unawaited(CrashLog.record(error, stack, kind: CrashKind.platform));
    return true;
  };
  ErrorWidget.builder = (_) => const SafeErrorView();
}

/// The `runZonedGuarded` handler.
void recordZoneError(Object error, StackTrace stack) {
  unawaited(CrashLog.record(error, stack, kind: CrashKind.zone));
}

/// Shown in place of Flutter's red error screen when a widget fails to build.
class SafeErrorView extends StatelessWidget {
  const SafeErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = Localizations.of<AppLocalizations>(context, AppLocalizations);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: StudentColors.bg,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 40,
                  color: StudentColors.danger,
                ),
                const SizedBox(height: 12),
                Text(
                  // Outside the app's localizations (a failure high in the
                  // tree) there is no chosen language to read.
                  l10n?.fatalErrorBody ??
                      'Something went wrong. Please close the app and open it '
                          'again.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: StudentFonts.sans,
                    fontFamilyFallback: StudentFonts.fallback,
                    fontSize: 15,
                    height: 1.5,
                    color: StudentColors.fg1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
