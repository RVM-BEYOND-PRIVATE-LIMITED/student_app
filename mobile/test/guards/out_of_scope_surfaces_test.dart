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
/// * student_app #6, C11 and item 13: no review mentioned at all, no reward
///   for a rating, and no paying for a placement or a job
///   ("payout-account" stays allowed);
/// * student_app #9: no route for an AI feature or a resume builder,
///   wherever it is declared (tool/no_ai_features.sh reads the SDKs and the
///   strings).
///
/// Each group also shows that its check catches a violation. The Hindi
/// phrases are whole phrases: a bare syllable such as 'रु' sits inside
/// ordinary words ('शुरुआती', 'रुकें') and is never banned alone.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final english = messages('lib/l10n/app_en.arb');
  final hindiArb = messages('lib/l10n/app_hi.arb');
  final strings = {
    for (final MapEntry(:key, :value) in english.entries) 'en $key': value,
    for (final MapEntry(:key, :value) in hindiArb.entries) 'hi $key': value,
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
    expect(strings, containsPair('en welcomeBody', english['welcomeBody']));
    expect(strings, containsPair('hi welcomeBody', hindiArb['welcomeBody']));
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

  test('one sentence ends at a full stop, "!", "?" or "।"; one string does '
      'not', () {
    final sentence = inOneSentence('pay', 'job');
    final string = inOneString('pay', 'job');

    expect(sentence.hasMatch('pay for the job'), isTrue);
    expect(sentence.hasMatch('the job: pay now'), isTrue);
    for (final text in ['pay. job', 'pay! job', 'pay? job', 'pay। job']) {
      expect(sentence.hasMatch(text), isFalse, reason: text);
      expect(string.hasMatch(text), isTrue, reason: text);
    }
    expect(string.hasMatch('pay'), isFalse);
    expect(
      inOneSentence(
        'pay',
        'job',
        unless: 'reward',
      ).hasMatch('job pay reward. job'),
      isFalse,
    );
    expect(
      inOneSentence(
        'pay',
        'job',
        unless: 'reward',
      ).hasMatch('reward. pay for the job'),
      isTrue,
    );
  });

  group('student_app #4, C11: no ID card, certificate or placed students', () {
    // A student placed in a batch or a queue is not a placement.
    const placed =
        r'\bplaced\b(?! (in|into|on) (a |an |the |your |their )?(batch(es)?|queue)\b)';
    const people = r'\b(students?|candidates?|alumni|trainees?)\b';
    final banned = [
      RegExp(r'\b(id|identity)[- ]?cards?\b'),
      RegExp(r'\bcertificates?\b'),
      inOneSentence(placed, people),
      hindi('पहचान[- ]?पत्र|प्रमाण[- ]?पत्र|(आईडी|आइडी)[- ]?कार्ड|सर्टिफिकेट'),
      // Hindi copy often keeps 'ID' in Latin letters.
      RegExp(r'\bid[- ]?कार्ड'),
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
          route('/identity-card'),
          route('/student-id'),
          route('/digital-id'),
          route('/my_id'),
        ]).where(idCardOrCertificatePath),
        hasLength(8),
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
          'h': 'Show your identity card',
          'i': 'ID कार्ड दिखाएँ',
          'j': 'Placed: 120 students',
          'k': 'Students we placed',
        }, banned),
        hasLength(11),
      );
    });

    test('lookalikes pass', () {
      expect(
        [
          '/placement',
          '/replaced',
          '/paid-cards',
          '/profile/:id',
          '/students/:id',
          '/my-ideas',
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
          'g': 'Students are placed in a batch after payment.',
          'h': 'Your order is placed. Students get it at the centre.',
        }, banned),
        isEmpty,
      );
    });
  });

  group('student_app #5, C12: no private or direct messages', () {
    final banned = [
      RegExp(r'\b(private|direct|personal)[- ](messag(e|es|ing)|chats?)\b'),
      RegExp(r'\bdms?\b'),
      // A chat with someone is one to one.
      RegExp(r'\bchat(s|ting)? with\b'),
      hindi('(निजी|प्राइवेट|डायरेक्ट|व्यक्तिगत)[- ](संदेश|मैसेज|चैट)'),
      hindi('(से|के साथ) चैट'),
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
          route('/private_messages'),
          route('/chat_room'),
        ]).where(privateMessagePath),
        // '/chat' and '/chat/:id' both.
        hasLength(11),
      );
      expect(
        offending({
          'a': 'Send a private message',
          'b': 'Direct messages',
          'c': 'Send your trainer a DM',
          'd': 'निजी संदेश भेजें',
          'e': 'प्राइवेट चैट',
          'f': 'Private messaging',
          'g': 'Direct-message your trainer',
          'h': 'Chat with your trainer',
          'i': 'ट्रेनर से चैट करें',
        }, banned),
        hasLength(9),
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

  group('student_app #6, C11 and item 13: no review, no reward for a '
      'rating, no paying for a placement', () {
    // A review in any form, banned outright: item 13 allows no review
    // mention. The word boundary keeps 'preview' allowed, and matching only
    // whole Hindi words keeps 'प्रिव्यू'.
    final review = [
      RegExp(r'\breview(s|ed|er|ers|ing)?\b'),
      RegExp(r'\bgoogle (reviews?|ratings?)\b'),
      hindi('रिव्यू|समीक्षा|गूगल (पर )?रेटिंग'),
    ];

    // A rating and a reward anywhere in one string: 'Rate us! Win a
    // prize!' is one offer in two sentences. 'rate' counts only as a verb,
    // so 'at the current rate' passes, and a number only as money, so 'from
    // 1 to 5' passes.
    final rating =
        r'\bratings?\b|\b(5|five)[- ]stars?\b'
        r'|(^|[.!?,;:]\s*|\b(to|and|or|please|then|now|you|would|will|can|must|should)\s+)'
        r'rate\b(?! (of|per|is|was|for)\b)'
        '|${hi('रेटिंग|रेट कर|रेट दे|स्टार दे|(5|पांच) स्टार')}';
    final reward =
        r'\b(rewards?|rewarded|cashback|cash|discounts?|gifts?|coupons?|'
        r'vouchers?|prizes?|bonus(es)?|earn(s|ed)?|wins?|won)\b'
        r'|\b(get|win|earn|claim)( a)? free\b|\bfor free\b'
        r'|₹|\brs\.? ?\d|\binr\b|\d ?%'
        '|${hi('इनाम|ईनाम|रिवॉर्ड|रिवार्ड|कैशबैक|छूट|डिस्काउंट|गिफ्ट|उपहार|'
        'कूपन|वाउचर|बोनस|पुरस्कार|मुफ्त|फ्री|जीत|कमाएं|कमाइए|कमाओ|कमाई')}';
    final rewardForRating = [inOneString(rating, reward)];

    const job = r'\b(placements?|jobs?)\b';
    const hiJob = 'नौकरी|प्लेसमेंट|जॉब';
    // Paying in any form, but not a salary: 'starting pay', 'job pay', 'pay
    // scale', 'this job pays' and 'a paid job' pass.
    const pay =
        r'(?<!\b(starting|monthly|basic|base|net|gross|take-home|in-hand|'
        r'average|good|better|higher|fair|the|your|job|daily|weekly|hourly|'
        r'yearly|annual) )\bpay\b(?! (scale|package|slip|range|band|grade)s?\b)'
        r'|\b(paying|payments?|deposit(s|ed|ing)?)\b|\bpaid for\b';
    // Paying in Hindi, or giving or depositing an amount: 'जमा करें' alone
    // is also handing in a document, so it counts only after money.
    const hiPay =
        'भुगतान कर|पेमेंट कर'
        '|(₹ ?[0-9,]+|[0-9,]+ ?(रुपये|रुपए)|पैसे|राशि|रकम|फीस|शुल्क) ?'
        '(जमा|दें|दीजिए|दो|देना|देनी|देने|भरें|भरिए|भरो|भरना|भरनी|भरने|'
        'चुकाएं|चुकाइए|चुकाना|चुकाने)(?![ऀ-ॿ])';
    // Money the student receives: a reward, a payout or a salary.
    final inbound =
        r'\b(rewards?|payouts?|salary|salaries|stipends?|wages?)\b'
        '|${hi('इनाम|ईनाम|रिवॉर्ड|रिवार्ड|पेआउट|वेतन|सैलरी|तनख्वाह')}';
    final payForPlacement = [
      inOneSentence('$pay|${hi(hiPay)}', '$job|${hi(hiJob)}', unless: inbound),
      RegExp(r'\b(placements?|jobs?)( \w+)? (fees?|charges?|deposits?)\b'),
      RegExp(r'\bfees? for (a |an |the |your )?(placements?|jobs?)\b'),
      hindi('($hiJob) के लिए (भुगतान|पेमेंट|फीस|शुल्क|चार्ज|पैसे दे|पैसे जमा)'),
      hindi('($hiJob) (फीस|शुल्क|चार्ज)'),
    ];

    test('no string mentions a review', () {
      expect(offending(strings, review), isEmpty);
    });

    test('no string ties a reward to a rating', () {
      expect(offending(strings, rewardForRating), isEmpty);
    });

    test('no string asks to pay for a placement or a job', () {
      expect(offending(strings, payForPlacement), isEmpty);
    });

    test('no payment route under a placement, job, proof or referral', () {
      expect(paths.where(payForPlacementPath).toList(), isEmpty);
    });

    test('the checks catch one', () {
      expect(
        offending({
          'a': 'Leave a Google review',
          'b': 'Write a review. Get a ₹100 voucher.',
          'c': 'Review us and get free T-shirt',
          'd': 'Your documents are under review.',
          'e': 'Earn cashback for every review',
          'f': 'रिव्यू दें। इनाम पाएँ।',
          'g': 'गूगल पर रिव्यू दें',
          'h': 'अपनी समीक्षा लिखें',
          'i': 'गूगल रेटिंग दें',
        }, review),
        hasLength(9),
      );
      expect(
        offending({
          'a': 'Rate us 5 stars and get a ₹100 voucher',
          'b': 'Leave a 5-star rating and get ₹100 off',
          'c': 'Rate us! Win a prize!',
          'd': 'Rate us and get a free T-shirt',
          'e': 'Give us a rating. 10% off your next course.',
          'f': 'कैशबैक के लिए 5 स्टार रेटिंग दें',
          'g': 'ऐप को रेटिंग दें। इनाम जीतें।',
          'h': 'ऐप को रेट करें और ₹100 पाएँ',
        }, rewardForRating),
        hasLength(8),
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
          'i': 'प्लेसमेंट फ़ीस',
          'j': 'Make a payment of ₹5,000 to confirm your placement',
          'k': 'Deposit ₹10,000 to secure your job',
          'l': 'Paying ₹2,000 confirms your placement',
          'm': 'Placement guarantee fee: ₹20,000',
          'n': '₹5,000 जमा करें और नौकरी पाएँ',
          'o': 'नौकरी पक्की करने के लिए ₹5,000 दें',
          'p': 'Have you paid for your placement?',
        }, payForPlacement),
        hasLength(16),
      );
      expect(
        [
          '/placement/:id/pay',
          '/referrals/checkout',
          '/proof/payment-orders',
          '/placements/fee',
          '/pay-for-placement',
          '/job-fees',
          '/placement-drives/:id/pay',
          '/jobs/:id/pay',
          '/placement/:id/payment',
          '/placements/:id/payments',
          '/placement/:id/deposit',
        ].where(payForPlacementPath),
        hasLength(11),
      );
    });

    test('lookalikes pass: payout-account, preview, a rate, a salary, '
        'course fees and words with रु', () {
      expect(
        [
          '/referrals/payout-account',
          '/placement/proof/payout-account',
          '/fees/pay',
          '/payments/checkout',
          '/placement/:id',
          '/jobs/:id',
        ].where(payForPlacementPath),
        isEmpty,
      );
      final lookalikes = {
        'a': 'Its preview in recent apps is blank.',
        'b': 'Get a 10% discount on fees at the current rate.',
        'c': "Rate today's class from 1 to 5.",
        'd': 'Pay your course fees at the centre.',
        'e': 'Placement support is included in your course fee.',
        'f': 'Add your payout account.',
        'g': 'Starting pay for this job is ₹15,000 a month.',
        'h': 'Job pay: ₹18,000',
        'i': 'This job pays ₹15,000 a month.',
        'j': 'A paid job after the course.',
        'k': 'Your placement reward payment failed. Check your payout account.',
        'l': 'आप शुरुआती वर्ज़न इस्तेमाल कर रहे हैं।',
        'm': 'कुछ मिनट रुकें, फिर से कोशिश करें।',
        'n': 'इसका प्रीव्यू खाली दिखता है।',
        'o': 'इसका प्रिव्यू खाली दिखता है।',
        'p': 'इस नौकरी के लिए ₹20,000 वेतन है।',
        'q': 'प्लेसमेंट का प्रूफ़ जमा करें।',
        'r': 'नौकरी के लिए अपने दस्तावेज़ जमा करें।',
      };
      expect(offending(lookalikes, review), isEmpty);
      expect(offending(lookalikes, rewardForRating), isEmpty);
      expect(offending(lookalikes, payForPlacement), isEmpty);
    });
  });

  group('student_app #9: no AI feature and no resume builder', () {
    test('no route, wherever it is declared', () {
      expect(paths.where(aiOrResumePath).toList(), isEmpty);
    });

    test('the check catches one', () {
      expect(
        routePaths([
          route('/doubts', [route('ai')]),
          route('/ask-ai'),
          route('/ai-tutor'),
          route('/ai_counsellor'),
          route('/AIMockInterview'),
          route('/profile', [route('resume')]),
          route('/resume', [route('create')]),
          route('/careers/cvBuilder'),
        ]).where(aiOrResumePath),
        // '/resume' and '/resume/create' both.
        hasLength(9),
      );
    });

    test('a counsellor, a mock interview, doubts and lookalikes pass', () {
      expect(
        [
          '/counsellor',
          '/mock-interview',
          '/mail/doubts',
          '/details',
          '/maintenance',
          '/trainers/:id',
          '/resumed',
        ].where(aiOrResumePath),
        isEmpty,
      );
    });
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

/// student_app #4: a route for an ID card, a certificate, placed students or
/// a student's own ID.
bool idCardOrCertificatePath(String path) => RegExp(
  r'(^|[^a-z])(id|identity)[-_]?cards?|certificates?|(^|[^a-z])placed'
  r'|(^|[^a-z])(student|digital|my)[-_]?ids?([^a-z]|$)',
).hasMatch(path.toLowerCase());

/// student_app #5: a segment for private or direct messages, a chat, an
/// inbox or a conversation: alone, as one word of a longer segment
/// ('faculty-chat', 'chat_room'), or before a parameter ('chat:id').
bool privateMessagePath(String path) => segments(path).any(
  RegExp(
    r'^(.*[-_])?(dms?|chats?|inbox|conversations?|(private|direct)[-_]?(messages?|chats?))([-_:].*)?$',
  ).hasMatch,
);

/// student_app #6: a payment segment under a placement, job, proof or
/// referral one ('placement-drives', 'jobs'), or a segment that names
/// paying for a placement or a job. 'payout-account' is no payment.
bool payForPlacementPath(String path) {
  final parts = segments(path);
  final area = parts.indexWhere(
    RegExp(r'^(placement|job|proof|referral)').hasMatch,
  );
  final payment = RegExp(
    r'^(pay|payments?|checkout|payment-orders?|deposits?|fees?)$',
  );
  if (area != -1 && parts.skip(area + 1).any(payment.hasMatch)) return true;
  return parts.any(
    RegExp(
      r'(^|-)(pay-for-(placements?|jobs?)|(placements?|jobs?)-(fees?|payments?|charges?|deposits?))(-|$)',
    ).hasMatch,
  );
}

/// student_app #9: a segment with 'ai', 'resume' or 'cv' among its words, in
/// kebab, snake or camel case ('ask-ai', 'ai_tutor', 'cvBuilder').
/// 'resumed' and 'mail' are other words.
bool aiOrResumePath(String path) => path
    .split('/')
    .expand(words)
    .any(const {'ai', 'resume', 'resumes', 'cv', 'cvs'}.contains);

/// The lower-case words of a route segment.
List<String> words(String segment) => segment
    .replaceAllMapped(RegExp('([a-z0-9])([A-Z])'), (m) => '${m[1]} ${m[2]}')
    .replaceAllMapped(RegExp('([A-Z])([A-Z][a-z])'), (m) => '${m[1]} ${m[2]}')
    .toLowerCase()
    .split(RegExp('[^a-z0-9]+'));

/// The text of one sentence: nothing past a full stop, '!', '?' or '।'.
const _sentence = '[^.!?।]*';

/// One sentence that names [a] and [b], in either order, and none of
/// [unless].
RegExp inOneSentence(String a, String b, {String? unless}) {
  final clean = unless == null ? '' : '(?!$_sentence(?:$unless))';
  return RegExp(
    '(?:^|[.!?।])$clean$_sentence'
    '(?:(?:$a)$_sentence(?:$b)|(?:$b)$_sentence(?:$a))',
  );
}

/// A string that names [a] and [b] anywhere, in either order.
RegExp inOneString(String a, String b) =>
    RegExp('^(?=[\\s\\S]*(?:$a))(?=[\\s\\S]*(?:$b))');

/// [phrase] in Devanagari, as a pattern that matches only where a word
/// starts: never from inside another word.
String hi(String phrase) => '(?<![ऀ-ॿ])(?:$phrase)';

/// [hi] as a [RegExp] of its own.
RegExp hindi(String phrase) => RegExp(hi(phrase));

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
    .replaceAll('़', '')
    .replaceAll('ँ', 'ं')
    .replaceAll(RegExp('[‌‍]'), '')
    .replaceAllMapped(
      RegExp('[क़-य़]'),
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
