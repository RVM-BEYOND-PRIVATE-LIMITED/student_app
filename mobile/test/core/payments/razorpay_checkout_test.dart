import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/payments/razorpay_checkout.dart';

void main() {
  const checkout = {
    'key_id': 'rzp_test_key',
    'razorpay_order_id': 'order_123',
    'amount_paise': 100000,
    'currency': 'INR',
  };

  test('a live checkout becomes the options Razorpay needs', () {
    final options = RazorpayCheckout.optionsFor(checkout);
    expect(options, isNotNull);
    expect(options!['key'], 'rzp_test_key');
    expect(options['order_id'], 'order_123');
    expect(options['amount'], 100000);
    expect(options['currency'], 'INR');
    expect(options['name'], 'RVM');
  });

  test('an incomplete checkout never opens the plugin', () {
    expect(RazorpayCheckout.optionsFor(const {}), isNull);
    expect(
      RazorpayCheckout.optionsFor(const {
        'key_id': 'rzp_test_key',
        'razorpay_order_id': '',
        'amount_paise': 100000,
      }),
      isNull,
    );
    expect(
      RazorpayCheckout.optionsFor(const {
        'key_id': 'rzp_test_key',
        'razorpay_order_id': 'order_123',
        'amount_paise': 0,
      }),
      isNull,
    );
  });

  test('a dry run has no checkout to open', () {
    expect(
      RazorpayCheckout.optionsFor(const {
        'key_id': null,
        'razorpay_order_id': null,
        'amount_paise': null,
        'currency': null,
      }),
      isNull,
    );
  });
}
