import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/push/notification_routes.dart';
import 'package:rvm_student/router/app_router.dart';

void main() {
  test('a backend route opens only a known app screen', () {
    expect(NotificationRoutes.forServerRoute('/fees'), Routes.fees);
    expect(NotificationRoutes.forServerRoute('/attendance'), Routes.attendance);
    expect(
      NotificationRoutes.forServerRoute('/complaints/abc-123'),
      Routes.complaints,
    );
    expect(
      NotificationRoutes.forServerRoute('/community/posts/abc-123'),
      Routes.community,
    );
    expect(
      NotificationRoutes.forServerRoute('/online-classes'),
      Routes.learning,
    );
    expect(
      NotificationRoutes.forServerRoute('/placement-proofs'),
      Routes.placement,
    );
    expect(
      NotificationRoutes.forServerRoute('/consent-requests'),
      Routes.home,
    );
    expect(
      NotificationRoutes.forServerRoute('https://app.rvmcad.org/fees'),
      Routes.fees,
    );
  });

  test('an unknown or empty route opens nothing', () {
    expect(NotificationRoutes.forServerRoute(null), isNull);
    expect(NotificationRoutes.forServerRoute(''), isNull);
    expect(NotificationRoutes.forServerRoute('/admin'), isNull);
    expect(NotificationRoutes.forServerRoute('/https://evil.example'), isNull);
  });
}
