import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rvm_student/core/session/student_session.dart';
import 'package:rvm_student/core/version/version_gate.dart';
import 'package:rvm_student/features/language/bloc/language_bloc.dart';
import 'package:rvm_student/features/language/language_store.dart';
import 'package:rvm_student/features/startup/bloc/startup_bloc.dart';
import 'package:rvm_student/l10n/l10n.dart';
import 'package:rvm_student/router/app_router.dart';

import '../support/fakes.dart';

/// Screens the student app must never have, checked on every route the
/// router knows and every English and Hindi string:
///
/// * student_app #4, C11: no student ID card, certificate or placed-students
///   screen;
/// * student_app #5, C12: no private or direct messages ("messages" in
///   general stays allowed, for the complaint thread);
/// * student_app #6, C11: no reward for a review, and no paying for a
///   placement or a job ("payout-account" stays allowed).
///
/// Each group also shows that its check catches a violation. The Hindi
/// phrases are whole phrases: a bare syllable such as 'रु' sits inside
/// ordinary words ('शुरुआती', 'रुकें') and is never banned alone.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final en = messages('lib/l10n/app_en.arb');
  final hi = messages('lib/l10n/app_hi.arb');
  final strings = {
    for (final MapEntry(:key, :value) in en.entries) 'en $key': value,
    for (final MapEntry(:key, :value) in hi.entries) 'hi $key': value,
  };

  late List<String> paths;

  setUp(() {
    final startup = StartupBloc(
      session: StudentSession(FakeSecureStore()),
      gate: VersionGate(
        source: const UnpublishedVersionSource(),
        installedVersion: '0.1.0',
      ),
    );
    final language = LanguageBloc(
      store: LanguageStore(FakeSecureStore()),
      deviceDefault: AppLanguage.en,
      saved: AppLanguage.en,
    );
    final router = createRouter(
      startup: startup,
      language: language,
      isDev: true,
    );
    addTearDown(() async {
      router.dispose();
      await startup.close();
      await language.close();
    });
    paths = routePaths(router.configuration.routes);
  });

  test('the checks read every route, nested ones included, and every '
      'English and Hindi string', () {
    expect(paths, containsAll([Routes.welcome, Routes.devCaptureGuard]));
    expect(strings, containsPair('en welcomeBody', en['welcomeBody']));
    expect(strings, containsPair('hi welcomeBody', hi['welcomeBody']));
  });

  test('the walk joins nested paths and goes through shell routes', () {
    expect(
      routePaths([
        route('/profile', [
          route('id-card'),
          route(':id', [route('edit')]),
        ]),
        ShellRoute(
          builder: (_, _, child) => child,
          routes: [
            route('/home', [route('news')]),
          ],
        ),
      ]),
      [
        '/profile',
        '/profile/id-card',
        '/profile/:id',
        '/profile/:id/edit',
        '/home',
        '/home/news',
      ],
    );
  });

  group('student_app #4, C11: no ID card, certificate or placed students', () {
    final banned = [
      RegExp(r'\bid[- ]?cards?\b'),
      RegExp(r'\bidentity cards?\b'),
      RegExp(r'\bcertificates?\b'),
      RegExp(r'\bplaced (students?|candidates?|alumni)\b'),
      hindi('पहचान[- ]?पत्र|प्रमाण[- ]?पत्र|आईडी कार्ड|सर्टिफिकेट'),
      hindi('प्लेस्ड|प्लेस हुए|प्लेस हो चुके'),
    ];

    test('no route', () {
      expect(paths.where(idCardOrCertificatePath).toList(), isEmpty);
    });

    test('no English or Hindi string', () {
      expect(offending(strings, banned), isEmpty);
    });

    test('the checks catch one', () {
      expect(
        routePaths([
          route('/profile', [route('my-id-card')]),
          route('/certificates'),
          route('/placed-students'),
          route('/courses/:id/certificate'),
        ]).where(idCardOrCertificatePath),
        hasLength(4),
      );
      expect(
        offending({
          'a': 'Download your ID card',
          'b': 'Course certificate',
          'c': 'Meet our placed students',
          'd': 'अपना पहचान पत्र दिखाएँ',
          'e': 'आपका प्रमाणपत्र तैयार है',
          'f': 'सर्टिफ़िकेट डाउनलोड करें',
          'g': 'प्लेस हुए स्टूडेंट्स',
        }, banned),
        hasLength(7),
      );
    });

    test('lookalikes pass', () {
      expect(
        [
          '/placement',
          '/replaced',
          '/paid-cards',
          '/profile/:id',
        ].where(idCardOrCertificatePath),
        isEmpty,
      );
      expect(
        offending({
          'a': 'Reference ID',
          'b': 'Student ID: RVM-1042',
          'c': 'The old card was replaced',
          'd': 'Placement drives this month',
          'e': 'रेफ़रेंस आईडी',
          'f': 'प्लेसमेंट ड्राइव',
        }, banned),
        isEmpty,
      );
    });
  });

  group('student_app #5, C12: no private or direct messages', () {
    final banned = [
      RegExp(r'\b(private|direct|personal) (messages?|chats?)\b'),
      RegExp(r'\bdms?\b'),
      hindi('(निजी|प्राइवेट|डायरेक्ट|व्यक्तिगत) (संदेश|मैसेज|चैट)'),
    ];

    test('no route', () {
      expect(paths.where(privateMessagePath).toList(), isEmpty);
    });

    test('no English or Hindi string', () {
      expect(offending(strings, banned), isEmpty);
    });

    test('the checks catch one', () {
      expect(
        routePaths([
          route('/dm'),
          route('/chat:trainerId'),
          route('/chat', [route(':id')]),
          route('/inbox'),
          route('/trainers/:id', [route('private-messages')]),
          route('/faculty-chat'),
          route('/conversations'),
          route('/direct-message'),
        ]).where(privateMessagePath),
        // '/chat' and '/chat/:id' both.
        hasLength(9),
      );
      expect(
        offending({
          'a': 'Send a private message',
          'b': 'Direct messages',
          'c': 'Send your trainer a DM',
          'd': 'निजी संदेश भेजें',
          'e': 'प्राइवेट चैट',
        }, banned),
        hasLength(5),
      );
    });

    test('messages in general pass', () {
      expect(
        [
          '/messages',
          '/complaints/:id',
          '/complaints/:id/messages',
          '/notifications',
          '/announcements',
          '/admission',
        ].where(privateMessagePath),
        isEmpty,
      );
      expect(
        offending({
          'a': 'Hints for messages only.',
          'b': 'Read the messages on your complaint',
          'c': 'Personal data is removed',
          'd': 'ये सिर्फ़ संदेशों के लिए संकेत हैं।',
          'e': 'निजी जानकारी हटा दी जाती है।',
        }, banned),
        isEmpty,
      );
    });
  });

  group('student_app #6, C11: no reward for a review, no paying for a '
      'placement', () {
    const review = r'\b(reviews?|reviewing|ratings?|rate|(5|five)[- ]stars?)\b';
    const reward =
        r'\b(rewards?|rewarded|cashback|discounts?|gifts?|coupons?|vouchers?|'
        r'prizes?|bonus(es)?|earn|win)\b';
    const hiReview = 'रिव्यू|समीक्षा|रेटिंग|रेट कर|स्टार दे';
    const hiReward =
        'इनाम|ईनाम|रिवॉर्ड|रिवार्ड|कैशबैक|छूट|डिस्काउंट|गिफ्ट|उपहार|कूपन|'
        'वाउचर|बोनस|पुरस्कार';
    const job = r'\b(placements?|jobs?)\b';
    const hiJob = 'नौकरी|प्लेसमेंट|जॉब';
    const hiPay =
        'भुगतान कर|पेमेंट कर|पैसे दे|पैसे जमा|फीस दे|फीस भर|शुल्क दे|शुल्क भर';
    // Within one sentence.
    const gap = '[^.!?।]*';
    final rewardForReview = [
      RegExp('$review$gap$reward|$reward$gap$review'),
      RegExp(r'\bgoogle (reviews?|ratings?)\b'),
      hindi('($hiReview)$gap($hiReward)'),
      hindi('($hiReward)$gap($hiReview)'),
      hindi('गूगल (पर )?(रिव्यू|रेटिंग)'),
    ];
    final payForPlacement = [
      RegExp('\\bpay\\b$gap$job|$job$gap\\bpay\\b'),
      RegExp(r'\b(placement|job) (fees?|charges?|deposits?)\b'),
      RegExp(r'\bfees? for (a |an |the |your )?(placements?|jobs?)\b'),
      hindi('($hiJob) के लिए (भुगतान|पेमेंट|फीस|शुल्क|चार्ज|पैसे दे|पैसे जमा)'),
      hindi('($hiJob) (फीस|शुल्क|चार्ज)'),
      hindi('($hiPay)$gap($hiJob)'),
      hindi('($hiJob)$gap($hiPay)'),
    ];

    test('no string ties a reward to a review', () {
      expect(offending(strings, rewardForReview), isEmpty);
    });

    test('no string asks to pay for a placement or a job', () {
      expect(offending(strings, payForPlacement), isEmpty);
    });

    test('no payment route under placement, proof or referral', () {
      expect(paths.where(payForPlacementPath).toList(), isEmpty);
    });

    test('the checks catch one', () {
      expect(
        offending({
          'a': 'Leave a Google review',
          'b': 'Rate us 5 stars and get a ₹100 voucher',
          'c': 'Earn cashback for every review',
          'd': 'रिव्यू लिखें और इनाम पाएँ',
          'e': 'गूगल पर रिव्यू दें',
          'f': 'कैशबैक के लिए 5 स्टार रेटिंग दें',
        }, rewardForReview),
        hasLength(6),
      );
      expect(
        offending({
          'a': 'Pay ₹5,000 to confirm your placement',
          'b': 'Your job is waiting: pay now',
          'c': 'Placement fee',
          'd': 'Fees for a job guarantee',
          'e': 'नौकरी के लिए भुगतान करें',
          'f': 'प्लेसमेंट के लिए फ़ीस जमा करें',
          'g': 'प्लेसमेंट शुल्क',
          'h': 'पैसे जमा करें, नौकरी पक्की',
          // फ़ as one precomposed letter, not फ plus a nukta.
          'i': 'प्लेसमेंट \u095Eीस',
        }, payForPlacement),
        hasLength(9),
      );
      expect(
        routePaths([
          route('/placement', [
            route(':id', [route('pay')]),
          ]),
          route('/referrals', [route('checkout')]),
          route('/proof', [route('payment-orders')]),
          route('/placements/fee'),
          route('/pay-for-placement'),
          route('/job-fees'),
        ]).where(payForPlacementPath),
        hasLength(6),
      );
    });

    test(
      'lookalikes pass: payout-account, preview, fees and words with रु',
      () {
        expect(
          [
            '/referrals/payout-account',
            '/placement/proof/payout-account',
            '/fees/pay',
            '/payments/checkout',
            '/placement/:id',
          ].where(payForPlacementPath),
          isEmpty,
        );
        final lookalikes = {
          'a': 'Its preview in recent apps is blank.',
          'b': 'Your documents are under review.',
          'c': 'Pay your course fees at the centre.',
          'd': 'Placement support is included in your course fee.',
          'e': 'Add your payout account.',
          'f': 'आप शुरुआती वर्ज़न इस्तेमाल कर रहे हैं।',
          'g': 'कुछ मिनट रुकें, फिर से कोशिश करें।',
          'h': 'इसका प्रीव्यू खाली दिखता है।',
          'i': 'इस नौकरी के लिए ₹20,000 वेतन है।',
        };
        expect(offending(lookalikes, rewardForReview), isEmpty);
        expect(offending(lookalikes, payForPlacement), isEmpty);
      },
    );
  });
}

/// A route for the walk's own tests.
GoRoute route(String path, [List<RouteBase> routes = const []]) =>
    GoRoute(path: path, builder: (_, _) => const SizedBox(), routes: routes);

/// Every message in the ARB [file] by key, its '@' metadata left out
/// (`flutter test` runs in mobile/).
Map<String, String> messages(String file) {
  final arb = jsonDecode(File(file).readAsStringSync()) as Map<String, dynamic>;
  return {
    for (final MapEntry(:key, :value) in arb.entries)
      if (!key.startsWith('@')) key: value as String,
  };
}

/// The full path of every [GoRoute] in [routes] and below: a nested path is
/// joined to its parent's, and a shell route adds no path of its own.
List<String> routePaths(List<RouteBase> routes, [String parent = '']) => [
  for (final route in routes)
    if (route is GoRoute) ...[
      join(parent, route.path),
      ...routePaths(route.routes, join(parent, route.path)),
    ] else
      ...routePaths(route.routes, parent),
];

String join(String parent, String path) {
  if (path.startsWith('/') || parent.isEmpty) return path;
  return parent.endsWith('/') ? '$parent$path' : '$parent/$path';
}

List<String> segments(String path) =>
    path.toLowerCase().split('/').where((s) => s.isNotEmpty).toList();

/// student_app #4: a route for an ID card, a certificate or placed
/// students.
bool idCardOrCertificatePath(String path) => RegExp(
  r'(^|[^a-z])id[-_]?cards?|certificates?|(^|[^a-z])placed',
).hasMatch(path.toLowerCase());

/// student_app #5: a segment for private or direct messages, a chat, an
/// inbox or a conversation: alone, as one word of a longer segment, or
/// before a parameter ('chat:id').
bool privateMessagePath(String path) => segments(path).any(
  RegExp(
    r'^(.*-)?(dms?|chats?|inbox|conversations?|(private|direct)-?(messages?|chats?))([-:].*)?$',
  ).hasMatch,
);

/// student_app #6: a payment segment under a placement, proof or referral
/// one, or a segment that names paying for a placement or a job.
bool payForPlacementPath(String path) {
  final parts = segments(path);
  final area = parts.indexWhere(
    RegExp(r'^(placements?|placement-proofs?|proofs?|referrals?)$').hasMatch,
  );
  final payment = RegExp(r'^(pay|checkout|payment-orders?|fees?)$');
  if (area != -1 && parts.skip(area + 1).any(payment.hasMatch)) return true;
  return parts.any(
    RegExp(
      r'(^|-)(pay-for-(placements?|jobs?)|(placements?|jobs?)-(fees?|payments?|charges?|deposits?))(-|$)',
    ).hasMatch,
  );
}

/// [phrase] in Devanagari, matched only where a word starts: never from
/// inside another word.
RegExp hindi(String phrase) => RegExp('(?<![\u0900-\u097F])(?:$phrase)');

/// The entries of [strings] that one of [banned] finds, as `key: text`.
/// Matched on [fold]ed text, so the patterns are lower case and without
/// nukta.
List<String> offending(Map<String, String> strings, List<RegExp> banned) => [
  for (final MapEntry(:key, :value) in strings.entries)
    if (banned.any((pattern) => pattern.hasMatch(fold(value)))) '$key: $value',
];

/// [text] in lower case, with the Devanagari nukta dropped and
/// chandrabindu read as anusvara, so 'फ़ीस' and 'फीस', or 'पाएँ' and 'पाएं',
/// are the same word.
String fold(String text) => text
    .toLowerCase()
    .replaceAll('\u093C', '')
    .replaceAll('\u0901', '\u0902')
    .replaceAll(RegExp('[\u200C\u200D]'), '')
    .replaceAllMapped(
      RegExp('[\u0958-\u095F]'),
      (m) => String.fromCharCode(_nuktaBase[m[0]!.codeUnitAt(0) - 0x0958]),
    );

/// क़ ख़ ग़ ज़ ड़ ढ़ फ़ य़ (U+0958 to U+095F) without their nukta.
const _nuktaBase = [
  0x0915,
  0x0916,
  0x0917,
  0x091C,
  0x0921,
  0x0922,
  0x092B,
  0x092F,
];
