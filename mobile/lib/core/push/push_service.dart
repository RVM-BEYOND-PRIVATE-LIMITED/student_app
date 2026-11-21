import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_bootstrap.dart';
import 'notification_routes.dart';

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

  /// Called when FCM gives this handset a new token, so the signed-in
  /// student's registration moves to it. Set after sign-in; null signs out.
  Future<void> Function(String token)? onToken;

  /// A screen a notification asked for, waiting for the app shell to open it.
  /// The app sets it back to null once it has navigated.
  final ValueNotifier<String?> openedRoute = ValueNotifier<String?>(null);

  /// A message that arrived while the app was open. The shell shows its
  /// title and body, with an Open action, and clears it.
  final ValueNotifier<RemoteMessage?> foregroundNotice =
      ValueNotifier<RemoteMessage?>(null);

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
        unawaited(_deliverToken(newToken));
      });

      // Listen for foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        foregroundNotice.value = message;
      });

      // Handle message clicks when app is opened from background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        openedRoute.value = NotificationRoutes.forMessage(message);
      });

      // Handle message click when app launched from terminated state
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        openedRoute.value = NotificationRoutes.forMessage(initialMessage);
      }
    } catch (error) {
      debugPrint('RVM Student push service setup failed: $error');
    }
  }

  Future<void> _deliverToken(String token) async {
    final handler = onToken;
    if (handler == null) return;
    try {
      await handler(token);
    } catch (_) {
      // The next sign-in or token refresh tries again.
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
      return await messaging.getToken();
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
