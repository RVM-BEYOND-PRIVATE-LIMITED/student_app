/// The Student API's replies, as `packages/openapi/openapi.yaml` (0.1.0)
/// defines them. Nothing here is private to this app: the contract is the
/// source of truth, and every field is read from the server's reply.
library;

/// A decoded JSON object, or an empty one when the reply is not an object.
Map<String, dynamic> asMap(Object? value) =>
    value is Map<String, dynamic> ? value : <String, dynamic>{};

List<dynamic> asList(Object? value) => value is List<dynamic> ? value : const [];

String asString(Object? value, [String fallback = '']) =>
    value is String ? value : fallback;

String? asStringOrNull(Object? value) => value is String ? value : null;

int asInt(Object? value, [int fallback = 0]) => value is num
    ? value.toInt()
    : int.tryParse('${value ?? ''}') ?? fallback;

bool asBool(Object? value, [bool fallback = false]) =>
    value is bool ? value : fallback;

DateTime? asDateOrNull(Object? value) =>
    value is String ? DateTime.tryParse(value) : null;

/// `/v1/config`.
class StudentConfig {
  const StudentConfig({
    required this.minSupportedVersion,
    required this.latestVersion,
    required this.storeUrl,
    required this.maintenanceActive,
    required this.maintenanceMessage,
    required this.jobsHeader,
  });

  factory StudentConfig.fromJson(Map<String, dynamic> json) {
    final maintenance = asMap(json['maintenance']);
    return StudentConfig(
      minSupportedVersion: asString(json['min_supported_version']),
      latestVersion: asString(json['latest_version']),
      storeUrl: asStringOrNull(json['store_url']),
      maintenanceActive: asBool(maintenance['active']),
      maintenanceMessage: asStringOrNull(maintenance['message']),
      jobsHeader: JobsHeader.fromJson(asMap(json['jobs_header'])),
    );
  }

  final String minSupportedVersion;
  final String latestVersion;
  final String? storeUrl;
  final bool maintenanceActive;
  final String? maintenanceMessage;
  final JobsHeader jobsHeader;
}

/// The strip above the Jobs tab, set on the server.
class JobsHeader {
  const JobsHeader({
    required this.title,
    required this.subtitle,
    required this.logos,
  });

  factory JobsHeader.fromJson(Map<String, dynamic> json) => JobsHeader(
    title: asString(json['title']),
    subtitle: asStringOrNull(json['subtitle']),
    logos: [
      for (final logo in asList(json['logos']))
        JobLogo.fromJson(asMap(logo)),
    ],
  );

  final String title;
  final String? subtitle;
  final List<JobLogo> logos;
}

class JobLogo {
  const JobLogo({required this.key, required this.url});

  factory JobLogo.fromJson(Map<String, dynamic> json) =>
      JobLogo(key: asString(json['key']), url: asString(json['url']));

  final String key;
  final String url;

  Uri? get uri => Uri.tryParse(url);
}

/// `/v1/auth/otp/request` and `/v1/auth/otp/resend`.
class OtpChallenge {
  const OtpChallenge({
    required this.challengeId,
    required this.channel,
    required this.expiresAt,
    required this.resendAvailableAt,
    this.pilot = false,
    this.smsFallbackAt,
  });

  factory OtpChallenge.fromJson(Map<String, dynamic> json) => OtpChallenge(
    challengeId: asString(json['challenge_id']),
    channel: asString(json['channel'], 'sms'),
    expiresAt: asDateOrNull(json['expires_at']),
    resendAvailableAt: asDateOrNull(json['resend_available_at']),
    pilot: asBool(json['pilot']),
    smsFallbackAt: asDateOrNull(json['sms_fallback_at']),
  );

  final String challengeId;
  final String channel;
  final DateTime? expiresAt;
  final DateTime? resendAvailableAt;

  /// Contract 0.30.0 (Scheduler_Backend #570): true while the app is open only
  /// to a pilot list. The reply is then the same for every number, whether a
  /// code was sent or not, so the screen must not say "we sent a code".
  final bool pilot;

  /// Contract 0.30.0 (Scheduler_Backend #203): when the code went on WhatsApp
  /// and the automatic SMS fallback is on, the time the same code goes by SMS
  /// unless WhatsApp has confirmed delivery. Null otherwise.
  final DateTime? smsFallbackAt;

  bool get byWhatsApp => channel == 'whatsapp';
}

/// `/v1/auth/otp/verify`.
class SignedIn {
  const SignedIn({required this.tokens, required this.account, required this.created});

  factory SignedIn.fromJson(Map<String, dynamic> json) => SignedIn(
    tokens: TokenPair.fromJson(asMap(json['tokens'])),
    account: StudentAccount.fromJson(asMap(json['account'])),
    created: asBool(json['created']),
  );

  final TokenPair tokens;
  final StudentAccount account;
  final bool created;
}

class TokenPair {
  const TokenPair({
    required this.accessToken,
    required this.refreshToken,
    required this.sessionId,
  });

  factory TokenPair.fromJson(Map<String, dynamic> json) => TokenPair(
    accessToken: asString(json['access_token']),
    refreshToken: asString(json['refresh_token']),
    sessionId: asString(json['session_id']),
  );

  final String accessToken;
  final String refreshToken;
  final String sessionId;

  bool get hasRefreshToken => refreshToken.isNotEmpty;
}

/// `Me`: the signed-in student.
class StudentAccount {
  const StudentAccount({
    required this.id,
    required this.phoneMasked,
    required this.language,
    required this.stage,
    required this.feeFullyPaid,
    required this.isAlumni,
    required this.linkState,
    required this.ageConfirmed,
    required this.requiredConsentGiven,
    required this.placementPrompts,
    required this.consentRequests,
  });

  factory StudentAccount.fromJson(Map<String, dynamic> json) {
    final onboarding = asMap(json['onboarding']);
    final counts = asMap(json['counts']);
    return StudentAccount(
      id: asString(json['id']),
      phoneMasked: asString(json['phone_masked']),
      language: asString(json['language'], 'en'),
      stage: StudentStage.fromWire(asString(json['stage'])),
      feeFullyPaid: asBool(json['fee_fully_paid']),
      isAlumni: asBool(json['is_alumni']),
      linkState: LinkState.fromWire(asString(json['link_state'])),
      ageConfirmed: asBool(onboarding['age_confirmed']),
      requiredConsentGiven: asBool(onboarding['required_consent_given']),
      placementPrompts: asInt(counts['placement_prompts']),
      consentRequests: asInt(counts['consent_requests']),
    );
  }

  final String id;
  final String phoneMasked;
  final String language;
  final StudentStage stage;
  final bool feeFullyPaid;
  final bool isAlumni;
  final LinkState linkState;
  final bool ageConfirmed;
  final bool requiredConsentGiven;
  final int placementPrompts;
  final int consentRequests;

  bool get onboardingComplete => ageConfirmed && requiredConsentGiven;
}

/// The theme a student picks, or System to follow the phone (Scheduler_Backend #450).
enum ThemeChoice {
  light,
  dark,
  system;

  static ThemeChoice fromWire(String value) => switch (value) {
    'dark' => ThemeChoice.dark,
    'system' => ThemeChoice.system,
    _ => ThemeChoice.light,
  };
}

/// `GET` and `PUT /v1/me/preferences`.
class ThemePreference {
  const ThemePreference({required this.theme, required this.themeOpen});

  factory ThemePreference.fromJson(Map<String, dynamic> json) =>
      ThemePreference(
        theme: ThemeChoice.fromWire(asString(json['theme'], 'light')),
        themeOpen: asBool(json['theme_open']),
      );

  final ThemeChoice theme;

  /// Whether the `theme` switch is open to this student. Closed or unknown
  /// keeps the app on Light.
  final bool themeOpen;
}

enum StudentStage {
  visitor,
  registered,
  fullyPaid,
  alumni;

  static StudentStage fromWire(String value) => switch (value) {
    'registered' => StudentStage.registered,
    'fully_paid' => StudentStage.fullyPaid,
    'alumni' => StudentStage.alumni,
    _ => StudentStage.visitor,
  };
}

enum LinkState {
  unlinked,
  requested,
  linked;

  static LinkState fromWire(String value) => switch (value) {
    'requested' => LinkState.requested,
    'linked' => LinkState.linked,
    _ => LinkState.unlinked,
  };
}

/// `/v1/branches`.
class Branch {
  const Branch({required this.id, required this.name, required this.callNumber});

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    id: asInt(json['id']),
    name: asString(json['name']),
    callNumber: asStringOrNull(json['call_number']),
  );

  final int id;
  final String name;
  final String? callNumber;

  Uri? get phoneUri {
    final number = callNumber;
    if (number == null || number.trim().isEmpty) return null;
    final digits = number.replaceAll(RegExp(r'[^0-9+]'), '');
    return digits.isEmpty ? null : Uri(scheme: 'tel', path: digits);
  }
}

/// `POST /v1/me/link/auto` and `/v1/me/link/request`.
class LinkResult {
  const LinkResult({required this.state, required this.account});

  factory LinkResult.fromJson(Map<String, dynamic> json) => LinkResult(
    state: LinkResultState.fromWire(asString(json['state'])),
    account: StudentAccount.fromJson(asMap(json['account'])),
  );

  final LinkResultState state;
  final StudentAccount account;
}

enum LinkResultState {
  linked,
  needsCentre,
  requested;

  static LinkResultState fromWire(String value) => switch (value) {
    'linked' => LinkResultState.linked,
    'requested' => LinkResultState.requested,
    _ => LinkResultState.needsCentre,
  };
}

/// `/v1/me/admission`.
class Admission {
  const Admission({
    required this.admissionNumber,
    required this.name,
    required this.courses,
    required this.branchId,
    required this.branchName,
    required this.paidFigures,
    required this.totalFeesPaise,
    required this.totalPaidPaise,
    required this.remainingDuePaise,
    required this.plan,
  });

  factory Admission.fromJson(Map<String, dynamic> json) {
    final branch = asMap(json['branch']);
    return Admission(
      admissionNumber: asString(json['admission_number']),
      name: asString(json['name']),
      courses: [for (final course in asList(json['courses'])) '$course'],
      branchId: asInt(branch['id']),
      branchName: asString(branch['name']),
      paidFigures: asString(json['paid_figures'], 'current'),
      totalFeesPaise: asInt(json['total_fees_paise']),
      totalPaidPaise: json['total_paid_paise'] == null
          ? null
          : asInt(json['total_paid_paise']),
      remainingDuePaise: asInt(json['remaining_due_paise']),
      plan: [
        for (final row in asList(json['plan']))
          Installment.fromJson(asMap(row)),
      ],
    );
  }

  final String admissionNumber;
  final String name;
  final List<String> courses;
  final int branchId;
  final String branchName;
  final String paidFigures;
  final int totalFeesPaise;
  final int? totalPaidPaise;
  final int remainingDuePaise;
  final List<Installment> plan;

  bool get figuresAreLegacy => paidFigures == 'legacy';
}

class Installment {
  const Installment({
    required this.dueDate,
    required this.amountPaise,
    required this.balanceDuePaise,
    required this.status,
  });

  factory Installment.fromJson(Map<String, dynamic> json) => Installment(
    dueDate: asDateOrNull(json['due_date']),
    amountPaise: asInt(json['amount_paise']),
    balanceDuePaise: asInt(json['balance_due_paise']),
    status: asString(json['status'], 'pending'),
  );

  final DateTime? dueDate;
  final int amountPaise;
  final int balanceDuePaise;
  final String status;
}

/// `/v1/consent-texts`.
class ConsentText {
  const ConsentText({
    required this.purpose,
    required this.version,
    required this.language,
    required this.text,
    required this.required,
  });

  factory ConsentText.fromJson(Map<String, dynamic> json) => ConsentText(
    purpose: asString(json['purpose']),
    version: asInt(json['version']),
    language: asString(json['language'], 'en'),
    text: asString(json['text']),
    required: asBool(json['required']),
  );

  final String purpose;
  final int version;
  final String language;
  final String text;
  final bool required;
}

/// `/v1/me/consents`.
class ConsentRecord {
  const ConsentRecord({
    required this.purpose,
    required this.granted,
    required this.textVersion,
    required this.grantedAt,
    required this.withdrawnAt,
  });

  factory ConsentRecord.fromJson(Map<String, dynamic> json) => ConsentRecord(
    purpose: asString(json['purpose']),
    granted: asBool(json['granted']),
    textVersion: json['text_version'] == null
        ? null
        : asInt(json['text_version']),
    grantedAt: asDateOrNull(json['granted_at']),
    withdrawnAt: asDateOrNull(json['withdrawn_at']),
  );

  final String purpose;
  final bool granted;
  final int? textVersion;
  final DateTime? grantedAt;
  final DateTime? withdrawnAt;
}

/// `/v1/me/jobs-access`.
class JobsAccess {
  const JobsAccess({
    required this.allowed,
    required this.reason,
    required this.reasons,
    required this.stage,
    required this.checkedAt,
  });

  factory JobsAccess.fromJson(Map<String, dynamic> json) => JobsAccess(
    allowed: asBool(json['allowed']),
    reason: JobsReason.fromWire(asStringOrNull(json['reason'])),
    reasons: [
      for (final reason in asList(json['reasons']))
        ?JobsReason.fromWire(asStringOrNull(reason)),
    ],
    stage: StudentStage.fromWire(asString(json['stage'])),
    checkedAt: asDateOrNull(json['checked_at']),
  );

  final bool allowed;
  final JobsReason? reason;
  final List<JobsReason> reasons;
  final StudentStage stage;
  final DateTime? checkedAt;
}

enum JobsReason {
  notLinked,
  feePending,
  consentMissing,
  ageNotConfirmed,
  accountBlocked,
  notOpenYet;

  static JobsReason? fromWire(String? value) => switch (value) {
    'not_linked' => JobsReason.notLinked,
    'fee_pending' => JobsReason.feePending,
    'consent_missing' => JobsReason.consentMissing,
    'age_not_confirmed' => JobsReason.ageNotConfirmed,
    'account_blocked' => JobsReason.accountBlocked,
    'not_open_yet' => JobsReason.notOpenYet,
    _ => null,
  };
}

/// `POST /v1/me/campus-handoff`.
class CampusHandoff {
  const CampusHandoff({required this.url, required this.expiresAt});

  factory CampusHandoff.fromJson(Map<String, dynamic> json) => CampusHandoff(
    url: asString(json['url']),
    expiresAt: asDateOrNull(json['expires_at']),
  );

  final String url;
  final DateTime? expiresAt;

  Uri? get uri => Uri.tryParse(url);
}

/// `/v1/me/placement-prompts`.
class PlacementPrompt {
  const PlacementPrompt({
    required this.id,
    required this.companyName,
    required this.jobTitle,
    required this.status,
    required this.receivedAt,
  });

  factory PlacementPrompt.fromJson(Map<String, dynamic> json) =>
      PlacementPrompt(
        id: asString(json['id']),
        companyName: asString(json['company_name']),
        jobTitle: asString(json['job_title']),
        status: asString(json['status'], 'open'),
        receivedAt: asDateOrNull(json['received_at']),
      );

  final String id;
  final String companyName;
  final String jobTitle;
  final String status;
  final DateTime? receivedAt;
}

/// `/v1/me/consent-requests`.
class ConsentRequest {
  const ConsentRequest({
    required this.id,
    required this.companyName,
    required this.jobTitle,
    required this.question,
    required this.textVersion,
    required this.status,
    required this.expiresAt,
  });

  factory ConsentRequest.fromJson(Map<String, dynamic> json) => ConsentRequest(
    id: asString(json['id']),
    companyName: asString(json['company_name']),
    jobTitle: asString(json['job_title']),
    question: asString(json['question']),
    textVersion: asInt(json['text_version']),
    status: asString(json['status'], 'pending'),
    expiresAt: asDateOrNull(json['expires_at']),
  );

  final String id;
  final String companyName;
  final String jobTitle;
  final String question;
  final int textVersion;
  final String status;
  final DateTime? expiresAt;
}

/// `/v1/courses` and a registration's courses.
class JoiningCourse {
  const JoiningCourse({
    required this.id,
    required this.name,
    required this.pricePaise,
  });

  factory JoiningCourse.fromJson(Map<String, dynamic> json) => JoiningCourse(
    id: asString(json['id']),
    name: asString(json['name']),
    pricePaise: asInt(json['price_paise']),
  );

  final String id;
  final String name;
  final int pricePaise;
}

/// `/v1/undertaking/current`.
class Undertaking {
  const Undertaking({
    required this.version,
    required this.videoYoutubeId,
    required this.videoSeconds,
    required this.terms,
  });

  factory Undertaking.fromJson(Map<String, dynamic> json) {
    final video = asMap(json['video']);
    return Undertaking(
      version: asInt(json['version']),
      videoYoutubeId: asString(video['youtube_id']),
      videoSeconds: video['seconds'] is num ? asInt(video['seconds']) : null,
      terms: [
        for (final term in asList(json['terms']))
          UndertakingTerm.fromJson(asMap(term)),
      ],
    );
  }

  final int version;
  final String videoYoutubeId;
  final int? videoSeconds;
  final List<UndertakingTerm> terms;

  Uri get videoUri => Uri.parse('https://www.youtube.com/watch?v=$videoYoutubeId');
}

class UndertakingTerm {
  const UndertakingTerm({
    required this.key,
    required this.text,
    required this.required,
  });

  factory UndertakingTerm.fromJson(Map<String, dynamic> json) =>
      UndertakingTerm(
        key: asString(json['key']),
        text: asString(json['text']),
        required: asBool(json['required']),
      );

  final String key;
  final String text;
  final bool required;
}

/// `POST`/`PUT /v1/me/registrations` fields. Only what is set is sent.
class RegistrationFields {
  const RegistrationFields({
    this.branchId,
    this.studentName,
    this.email,
    this.dateOfBirth,
    this.currentAddress,
    this.permanentAddress,
    this.fatherName,
    this.fatherPhone,
    this.idType,
    this.courseIds,
  });

  final int? branchId;
  final String? studentName;
  final String? email;
  final String? dateOfBirth;
  final String? currentAddress;
  final String? permanentAddress;
  final String? fatherName;
  final String? fatherPhone;
  final String? idType;
  final List<String>? courseIds;

  Map<String, dynamic> toJson() => {
    if (branchId != null) 'branch_id': branchId,
    if (studentName != null) 'student_name': studentName,
    if (email != null) 'email': email,
    if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
    if (currentAddress != null) 'current_address': currentAddress,
    if (permanentAddress != null) 'permanent_address': permanentAddress,
    if (fatherName != null) 'father_name': fatherName,
    if (fatherPhone != null) 'father_phone': fatherPhone,
    if (idType != null) 'id_type': idType,
    if (courseIds != null) 'course_ids': courseIds,
  };
}

/// `/v1/me/registrations`.
class Registration {
  const Registration({
    required this.id,
    required this.status,
    required this.branchId,
    required this.studentName,
    required this.email,
    required this.dateOfBirth,
    required this.currentAddress,
    required this.permanentAddress,
    required this.fatherName,
    required this.fatherPhone,
    required this.idType,
    required this.courses,
    required this.totalPaise,
    required this.videoStartedAt,
    required this.videoCompletedAt,
    required this.termsAccepted,
    required this.idDocumentLast4,
    required this.submittedAt,
    required this.missing,
  });

  factory Registration.fromJson(Map<String, dynamic> json) {
    final undertaking = asMap(json['undertaking']);
    final idDocument = json['id_document'] == null
        ? null
        : asMap(json['id_document']);
    return Registration(
      id: asString(json['id']),
      status: asString(json['status'], 'draft'),
      branchId: json['branch_id'] is num ? asInt(json['branch_id']) : null,
      studentName: asStringOrNull(json['student_name']),
      email: asStringOrNull(json['email']),
      dateOfBirth: asStringOrNull(json['date_of_birth']),
      currentAddress: asStringOrNull(json['current_address']),
      permanentAddress: asStringOrNull(json['permanent_address']),
      fatherName: asStringOrNull(json['father_name']),
      fatherPhone: asStringOrNull(json['father_phone']),
      idType: asStringOrNull(json['id_type']),
      courses: [
        for (final course in asList(json['courses']))
          JoiningCourse.fromJson(asMap(course)),
      ],
      totalPaise: asInt(json['total_paise']),
      videoStartedAt: asDateOrNull(undertaking['video_started_at']),
      videoCompletedAt: asDateOrNull(undertaking['video_completed_at']),
      termsAccepted: [
        for (final key in asList(undertaking['terms_accepted']))
          if (key is String) key,
      ],
      idDocumentLast4: idDocument == null
          ? null
          : asStringOrNull(idDocument['last4']),
      submittedAt: asDateOrNull(json['submitted_at']),
      missing: [
        for (final item in asList(json['missing']))
          if (item is String) item,
      ],
    );
  }

  final String id;
  final String status;
  final int? branchId;
  final String? studentName;
  final String? email;
  final String? dateOfBirth;
  final String? currentAddress;
  final String? permanentAddress;
  final String? fatherName;
  final String? fatherPhone;
  final String? idType;
  final List<JoiningCourse> courses;
  final int totalPaise;
  final DateTime? videoStartedAt;
  final DateTime? videoCompletedAt;
  final List<String> termsAccepted;
  final String? idDocumentLast4;
  final DateTime? submittedAt;
  final List<String> missing;

  bool get videoDone => videoCompletedAt != null;
  bool get idUploaded => idDocumentLast4 != null;
  bool get submitted => status == 'submitted' || status == 'admitted';
}

/// `/v1/me/batches`.
class BatchOption {
  const BatchOption({
    required this.batchId,
    required this.courseId,
    required this.courseName,
    required this.startDate,
    required this.endDate,
    required this.daysOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory BatchOption.fromJson(Map<String, dynamic> json) {
    final course = asMap(json['course']);
    return BatchOption(
      batchId: asString(json['batch_id']),
      courseId: asString(course['id']),
      courseName: asString(course['name']),
      startDate: asStringOrNull(json['start_date']),
      endDate: asStringOrNull(json['end_date']),
      daysOfWeek: [
        for (final day in asList(json['days_of_week']))
          if (day is String) day,
      ],
      startTime: asStringOrNull(json['start_time']),
      endTime: asStringOrNull(json['end_time']),
    );
  }

  final String batchId;
  final String courseId;
  final String courseName;
  final String? startDate;
  final String? endDate;
  final List<String> daysOfWeek;
  final String? startTime;
  final String? endTime;
}

/// `POST /v1/me/payment-orders`.
class PaymentOrderCreated {
  const PaymentOrderCreated({
    required this.id,
    required this.purpose,
    required this.amountPaise,
    required this.mode,
    required this.status,
  });

  factory PaymentOrderCreated.fromJson(Map<String, dynamic> json) =>
      PaymentOrderCreated(
        id: asString(json['id']),
        purpose: asString(json['purpose']),
        amountPaise: asInt(json['amount_paise']),
        mode: asString(json['mode'], 'dry_run'),
        status: asString(json['status'], 'created'),
      );

  final String id;
  final String purpose;
  final int amountPaise;
  final String mode;
  final String status;

  bool get isDryRun => mode == 'dry_run';
}
