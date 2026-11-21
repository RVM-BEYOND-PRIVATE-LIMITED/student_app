import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/crash/crash_log.dart';
import 'core/redact/student_redact.dart';
import 'firebase_bootstrap.dart';
import 'l10n/gen/app_localizations.dart';
import 'theme/student_tokens.dart';

/// Sends every error to Firebase Crashlytics in release builds, if available.
abstract final class CrashReporter {
  static bool _available = false;

  /// True once Firebase Crashlytics initialised successfully.
  static bool get available => _available;

  static Future<void> init() async {
    // student_app #75: crash reports leave the phone from release builds
    // only. Debug builds keep the on-device log and send nothing.
    if (!kReleaseMode) {
      _available = false;
      return;
    }
    try {
      await ensureFirebase();
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      _available = true;
    } catch (_) {
      _available = false;
    }
  }

  static void note(String key, String value) {
    if (!_available) return;
    try {
      FirebaseCrashlytics.instance.setCustomKey(key, StudentRedact.text(value));
    } catch (_) {}
  }

  static Future<void> recordFlutterError(FlutterErrorDetails details) async {
    if (!_available) return;
    try {
      await FirebaseCrashlytics.instance.recordError(
        StudentRedact.text('${details.exception}'),
        details.stack,
        reason: details.context == null
            ? null
            : StudentRedact.text('${details.context}'),
        printDetails: false,
      );
    } catch (_) {}
  }

  static Future<void> record(
    Object error,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) async {
    if (!_available) return;
    try {
      await FirebaseCrashlytics.instance.recordError(
        StudentRedact.text('$error'),
        stack,
        reason: reason == null ? null : StudentRedact.text(reason),
        fatal: fatal,
        printDetails: false,
      );
    } catch (_) {}
  }
}

/// Sends every uncaught error to [CrashLog] (student_app #1, item 12) and
/// [CrashReporter] (Firebase Crashlytics):
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
    unawaited(CrashReporter.recordFlutterError(details));
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    unawaited(CrashLog.record(error, stack, kind: CrashKind.platform));
    unawaited(CrashReporter.record(error, stack, fatal: true));
    return true;
  };
  ErrorWidget.builder = (_) => const SafeErrorView();
}

/// The `runZonedGuarded` handler.
void recordZoneError(Object error, StackTrace stack) {
  unawaited(CrashLog.record(error, stack, kind: CrashKind.zone));
  unawaited(CrashReporter.record(error, stack, fatal: true));
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
        color: context.palette.bg,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 40,
                  color: context.palette.danger,
                ),
                const SizedBox(height: 12),
                Text(
                  // Outside the app's localizations (a failure high in the
                  // tree) there is no chosen language to read.
                  l10n?.fatalErrorBody ??
                      'Something went wrong. Please close the app and open it '
                          'again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: StudentFonts.sans,
                    fontFamilyFallback: StudentFonts.fallback,
                    fontSize: 15,
                    height: 1.5,
                    color: context.palette.fg1,
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
