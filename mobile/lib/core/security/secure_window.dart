import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../crash/crash_log.dart';

/// The capture guard on the app's one window (student_app #8, item 1):
/// Android's `FLAG_SECURE`, set and cleared by `MainActivity.kt` on the
/// [channelName] channel. While it is on, screenshots and screen recordings
/// come out black and the app-switcher preview is blank. It does not stop a
/// second phone's camera.
///
/// The flag covers the whole window, which every Flutter screen shares, and
/// more than one screen can need it at once (a marked screen pushed over a
/// marked tab, or two marked screens crossing in a transition). So it is
/// counted: the first [acquire] turns it on and the last [release] turns it
/// off. While it is on, it is sent again each time the app comes back to the
/// foreground, so the window never loses it behind the app's back.
///
/// Screens use it through `SecureScreen`, never directly. Android only:
/// elsewhere the count is kept and nothing is sent.
class SecureWindow with WidgetsBindingObserver {
  SecureWindow({MethodChannel? channel, bool Function()? supported})
    : _channel = channel ?? const MethodChannel(channelName),
      _supported = supported ?? _isAndroid;

  /// The app's one window.
  static final SecureWindow instance = SecureWindow();

  /// The channel `MainActivity.kt` answers.
  static const channelName = 'rvm_student/secure_window';

  final MethodChannel _channel;
  final bool Function() _supported;
  int _holders = 0;

  /// How many screens hold the guard now.
  int get holders => _holders;

  /// True while at least one screen holds the guard.
  bool get isOn => _holders > 0;

  /// One more screen needs the guard; the first one turns it on.
  void acquire() {
    _holders++;
    if (_holders == 1) {
      WidgetsBinding.instance.addObserver(this);
      _send('enable');
    }
  }

  /// A screen no longer needs the guard; the last one turns it off. A
  /// release without an acquire changes nothing.
  void release() {
    if (_holders == 0) return;
    _holders--;
    if (_holders == 0) {
      WidgetsBinding.instance.removeObserver(this);
      _send('disable');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && isOn) _send('enable');
  }

  static bool _isAndroid() =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Calls go out in order on one channel, so an "enable" and the "disable"
  /// right after it reach the window in that order.
  void _send(String method) {
    if (!_supported()) return;
    unawaited(_invoke(method));
  }

  Future<void> _invoke(String method) async {
    try {
      await _channel.invokeMethod<void>(method);
    } on MissingPluginException {
      // No MainActivity answers (a test, or an engine without the app's
      // activity): there is no window flag to set.
    } catch (error, stack) {
      await CrashLog.record(error, stack, kind: CrashKind.platform);
    }
  }
}
