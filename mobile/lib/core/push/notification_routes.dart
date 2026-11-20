import 'package:firebase_messaging/firebase_messaging.dart';

import '../../router/app_router.dart';

/// Turns the server's notification route into one of this app's screens.
///
/// The backend sends the route it wants opened (`/fees`, `/attendance`,
/// `/online-classes`, `/community/posts/<id>`, ...). The app never navigates
/// to a server string directly: only the screens below are reachable, so a
/// bad or unknown route can never open an arbitrary address.
abstract final class NotificationRoutes {
  /// The app screen for one backend route, or null when it is unknown.
  static String? forServerRoute(String? raw) {
    final route = (raw ?? '').trim();
    if (route.isEmpty) return null;
    final path = Uri.tryParse(route)?.path ?? route;
    if (path == Routes.fees) return Routes.fees;
    if (path == Routes.attendance) return Routes.attendance;
    if (path == Routes.timetable) return Routes.timetable;
    if (path == Routes.announcements) return Routes.announcements;
    if (path == Routes.notifications) return Routes.notifications;
    if (path == Routes.learning || path == '/online-classes') {
      return Routes.learning;
    }
    if (path == Routes.complaints || path.startsWith('${Routes.complaints}/')) {
      return Routes.complaints;
    }
    if (path == Routes.community || path.startsWith('${Routes.community}/')) {
      return Routes.community;
    }
    if (path == Routes.placement ||
        path == '/placement-proofs' ||
        path == '/payout-account') {
      return Routes.placement;
    }
    if (path == '/placement-prompts' ||
        path == '/consent-requests' ||
        path == Routes.home) {
      return Routes.home;
    }
    return null;
  }

  /// The app screen for a push message, from its `data.route`.
  static String? forMessage(RemoteMessage message) =>
      forServerRoute('${message.data['route'] ?? ''}');
}
