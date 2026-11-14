package com.rvm.rvmstudent

import android.os.Build
import android.os.Debug
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger

        // The capture guard (student_app #8, item 1). FLAG_SECURE makes
        // screenshots and screen recordings of the window come out black and
        // blanks its app-switcher preview. The Dart side
        // (lib/core/security/secure_window.dart) counts the screens that need
        // it and sends the first "enable" and the last "disable". Method calls
        // arrive on the main thread, where the window may be changed.
        MethodChannel(messenger, SECURE_WINDOW_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "enable" -> {
                    window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    result.success(null)
                }
                "disable" -> {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        // Device hints (student_app #8, item 2), for messages only: they never
        // decide anything, the server does (Scheduler_Backend #159, #192).
        // Nothing here needs a permission, and no installed app is listed
        // (no QUERY_ALL_PACKAGES).
        MethodChannel(messenger, DEVICE_HINTS_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "read" -> result.success(
                    mapOf(
                        "rootSuspected" to rootSuspected(),
                        "debuggerAttached" to Debug.isDebuggerConnected(),
                    )
                )
                else -> result.notImplemented()
            }
        }
    }

    /**
     * True when the phone looks rooted: an `su` binary in one of the usual
     * places, or a system built with test keys. Root can be hidden, so false
     * proves nothing.
     */
    private fun rootSuspected(): Boolean =
        Build.TAGS?.contains("test-keys") == true ||
            SU_PATHS.any { path -> runCatching { File(path).exists() }.getOrDefault(false) }

    private companion object {
        const val SECURE_WINDOW_CHANNEL = "rvm_student/secure_window"
        const val DEVICE_HINTS_CHANNEL = "rvm_student/device_hints"

        val SU_PATHS = listOf(
            "/system/bin/su",
            "/system/xbin/su",
            "/sbin/su",
            "/su/bin/su",
            "/system/su",
            "/system/bin/.ext/su",
            "/system/usr/we-need-root/su",
            "/system/app/Superuser.apk",
            "/data/local/su",
            "/data/local/bin/su",
            "/data/local/xbin/su",
            "/cache/su",
            "/data/su",
            "/dev/su",
        )
    }
}
