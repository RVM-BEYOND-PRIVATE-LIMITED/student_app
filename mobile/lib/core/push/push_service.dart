import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_bootstrap.dart';

/// The default channel ID declared in AndroidManifest.xml
const String studentNotificationChannelId = 'student_rvm_alerts';

/// Background message handler for Firebase Cloud Messaging.
/// Must be an entry-point function at top-level.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await ensureFirebase();
    if (kDebugMode) {
      debugPrint('RVM Student background message received: ${message.messageId}');
    }
  } catch (error) {
    debugPrint('RVM Student background message handler error: $error');
  }
}

/// Service managing Firebase Cloud Messaging (Push Notifications) lifecycle.
class PushService {
  PushService._();
  static final PushService instance = PushService._();

  Future<void>? _initFuture;
  String? _token;

  String? get token => _token;

  /// Initializes push notification service.
  /// Safe to call multiple times; initialisation occurs once.
  Future<void> init() => _initFuture ??= _init();

  Future<void> _init() async {
    try {
      await ensureFirebase();
    } catch (error) {
      debugPrint('RVM Student push unavailable: Firebase not initialised ($error)');
      return;
    }

    try {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      final messaging = FirebaseMessaging.instance;

      // Request notification permissions (POST_NOTIFICATIONS on Android 13+)
      await _requestPermission(messaging);

      // Foreground presentation options
      try {
        await messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      } catch (_) {}

      // Get initial FCM token
      _token = await _safeToken(messaging);

      // Listen for token updates
      // ignore: deprecated_member_use
      messaging.onTokenRefresh.listen((newToken) {
        _token = newToken;
        if (kDebugMode) {
          debugPrint('RVM Student FCM token refreshed: $newToken');
        }
      });

      // Listen for foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          debugPrint(
            'RVM Student foreground message received: '
            '${message.notification?.title} - ${message.notification?.body}',
          );
        }
      });

      // Handle message clicks when app is opened from background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (kDebugMode) {
          debugPrint('RVM Student message opened app: ${message.data}');
        }
      });

      // Handle message click when app launched from terminated state
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null && kDebugMode) {
        debugPrint('RVM Student initial notification launch: ${initialMessage.data}');
      }
    } catch (error) {
      debugPrint('RVM Student push service setup failed: $error');
    }
  }

  Future<void> _requestPermission(FirebaseMessaging messaging) async {
    try {
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
    } catch (error) {
      debugPrint('RVM Student push permission request failed: $error');
    }
  }

  Future<String?> _safeToken(FirebaseMessaging messaging) async {
    try {
      // Classic FCM registration token
      // ignore: deprecated_member_use
      final token = await messaging.getToken();
      if (kDebugMode && token != null && token.isNotEmpty) {
        debugPrint('RVM Student FCM token: $token');
      }
      return token;
    } catch (error) {
      debugPrint('RVM Student failed to get FCM token: $error');
      return null;
    }
  }

  /// Subscribe to a topic for broadcast notifications (e.g., 'all_students')
  Future<void> subscribeToTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
    } catch (error) {
      debugPrint('RVM Student failed to subscribe to topic $topic: $error');
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    } catch (error) {
      debugPrint('RVM Student failed to unsubscribe from topic $topic: $error');
    }
  }
}
