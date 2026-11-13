import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../l10n/l10n.dart';

/// What the phone says about itself (student_app #8, item 2): rooted, an
/// emulator, a debugger attached.
///
/// **For messages only.** These are hints: root and emulators can be hidden,
/// so a false proves nothing and a true can be wrong. Nothing in the app may
/// refuse, hide or limit anything because of them; the server decides that
/// from the Play Integrity verdict (Scheduler_Backend #159 at phone binding,
/// #192 at play-session start). They are not sent anywhere either: they only
/// add a line of explanation to what the student is shown ([notes]).
///
/// Each value is null when the phone could not tell.
class DeviceHints extends Equatable {
  const DeviceHints({this.rootSuspected, this.emulator, this.debuggerAttached});

  /// Nothing could be read (not Android, or no answer from the phone).
  static const unknown = DeviceHints();

  /// An `su` binary in one of the usual places, or a system built with test
  /// keys (`MainActivity.kt`).
  final bool? rootSuspected;

  /// Not a physical device, by device_info_plus's `isPhysicalDevice`.
  final bool? emulator;

  /// A Java debugger is attached to the app (`Debug.isDebuggerConnected`).
  final bool? debuggerAttached;

  /// One plain sentence per hint that is true, in the student's language, to
  /// add under a message the server sent (a refusal, student_app #8 item 4).
  /// Empty when no hint is true.
  List<String> notes(AppLocalizations l10n) => [
    if (rootSuspected == true) l10n.deviceHintRooted,
    if (emulator == true) l10n.deviceHintEmulator,
    if (debuggerAttached == true) l10n.deviceHintDebugger,
  ];

  @override
  List<Object?> get props => [rootSuspected, emulator, debuggerAttached];
}

/// Where [DeviceHints] come from. Tests pass their own.
abstract interface class DeviceHintsSource {
  /// Never throws: what cannot be read is null.
  Future<DeviceHints> read();
}

/// [DeviceHints] from the phone: `MainActivity.kt` on [channelName] for root
/// and the debugger, device_info_plus for the emulator.
class PlatformDeviceHints implements DeviceHintsSource {
  PlatformDeviceHints({
    MethodChannel? channel,
    DeviceInfoPlugin? deviceInfo,
    bool Function()? supported,
  }) : _channel = channel ?? const MethodChannel(channelName),
       _deviceInfo = deviceInfo ?? DeviceInfoPlugin(),
       _supported = supported ?? _isAndroid;

  /// The channel `MainActivity.kt` answers.
  static const channelName = 'rvm_student/device_hints';

  final MethodChannel _channel;
  final DeviceInfoPlugin _deviceInfo;
  final bool Function() _supported;

  static bool _isAndroid() =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  @override
  Future<DeviceHints> read() async {
    if (!_supported()) return DeviceHints.unknown;
    final native = await _native();
    return DeviceHints(
      rootSuspected: _flag(native?['rootSuspected']),
      emulator: await _emulator(),
      debuggerAttached: _flag(native?['debuggerAttached']),
    );
  }

  Future<Map<Object?, Object?>?> _native() async {
    try {
      return await _channel.invokeMethod<Map<Object?, Object?>>('read');
    } catch (_) {
      // No answer (a test, an older build of MainActivity): unknown.
      return null;
    }
  }

  Future<bool?> _emulator() async {
    try {
      return !(await _deviceInfo.androidInfo).isPhysicalDevice;
    } catch (_) {
      return null;
    }
  }

  static bool? _flag(Object? value) => value is bool ? value : null;
}
