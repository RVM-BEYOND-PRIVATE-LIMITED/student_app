import 'dart:async';

import 'package:razorpay_flutter/razorpay_flutter.dart';

/// What happened in Razorpay Checkout. A success here is only a hint: the
/// server makes the receipt from the signed webhook, so the caller asks the
/// order for `paid` before telling the student the money is in.
enum CheckoutResult { paid, cancelled, failed, unavailable }

/// Opens the live Razorpay Checkout from the `checkout` object an order
/// returns (`key_id`, `razorpay_order_id`, `amount_paise`, `currency`).
/// Nothing here is logged, stored or shown; only the result comes back.
abstract final class RazorpayCheckout {
  /// The options Razorpay Checkout needs, or null when the server's checkout
  /// object is incomplete. Pure, so a test can check it without the plugin.
  static Map<String, dynamic>? optionsFor(Map<String, dynamic> checkout) {
    final key = '${checkout['key_id'] ?? ''}'.trim();
    final orderId = '${checkout['razorpay_order_id'] ?? ''}'.trim();
    final amount = (checkout['amount_paise'] as num?)?.toInt() ?? 0;
    if (key.isEmpty || orderId.isEmpty || amount < 1) return null;
    return {
      'key': key,
      'order_id': orderId,
      'amount': amount,
      'currency': '${checkout['currency'] ?? 'INR'}',
      'name': 'RVM',
      'description': 'Course fee',
      'retry': {'enabled': true},
    };
  }

  static Future<CheckoutResult> open(Map<String, dynamic> checkout) async {
    final options = optionsFor(checkout);
    if (options == null) return CheckoutResult.unavailable;
    final razorpay = Razorpay();
    final done = Completer<CheckoutResult>();

    void finish(CheckoutResult result) {
      if (!done.isCompleted) done.complete(result);
    }

    razorpay
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, (_) => finish(CheckoutResult.paid))
      ..on(Razorpay.EVENT_PAYMENT_ERROR, (dynamic response) {
        final code = response is PaymentFailureResponse ? response.code : null;
        finish(
          code == Razorpay.PAYMENT_CANCELLED
              ? CheckoutResult.cancelled
              : CheckoutResult.failed,
        );
      })
      ..on(
        Razorpay.EVENT_EXTERNAL_WALLET,
        (_) => finish(CheckoutResult.failed),
      );

    try {
      razorpay.open(options);
      return await done.future.timeout(
        const Duration(minutes: 10),
        onTimeout: () => CheckoutResult.failed,
      );
    } catch (_) {
      return CheckoutResult.unavailable;
    } finally {
      razorpay.clear();
    }
  }
}
