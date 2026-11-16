import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';

import '../network/student_auth_interceptor.dart';
import 'models.dart';

/// The Stage 1A Student API (`packages/openapi/openapi.yaml` 0.1.0), called
/// through the one client [StudentDio] builds: the host guard, the
/// Idempotency-Key, the app version and language headers, retries, the session
/// token and its renewal, and the typed [Failure] all live there, so nothing
/// is rebuilt here.
///
/// Paths and bodies mirror the contract exactly. `test/core/api/
/// student_api_contract_test.dart` reads the published contract and fails when
/// this class and the contract drift apart.
class StudentApi {
  StudentApi(this._dio);

  final Dio _dio;

  static const configPath = '/v1/config';
  static const otpRequestPath = '/v1/auth/otp/request';
  static const otpResendPath = '/v1/auth/otp/resend';
  static const otpVerifyPath = '/v1/auth/otp/verify';
  static const refreshPath = '/v1/auth/refresh';
  static const logoutPath = '/v1/auth/logout';
  static const mePath = '/v1/me';
  static const languagePath = '/v1/me/language';
  static const preferencesPath = '/v1/me/preferences';
  static const sessionsPath = '/v1/me/sessions';
  static const branchesPath = '/v1/branches';
  static const linkAutoPath = '/v1/me/link/auto';
  static const linkRequestPath = '/v1/me/link/request';
  static const admissionPath = '/v1/me/admission';
  static const consentTextsPath = '/v1/consent-texts';
  static const consentsPath = '/v1/me/consents';
  static const ageConfirmationPath = '/v1/me/age-confirmation';
  static const jobsAccessPath = '/v1/me/jobs-access';
  static const campusHandoffPath = '/v1/me/campus-handoff';
  static const placementPromptsPath = '/v1/me/placement-prompts';
  static const consentRequestsPath = '/v1/me/consent-requests';
  static const pushTokenPath = '/v1/me/push-token';

  /// The paths this client calls, for the contract drift test.
  static const paths = {
    '/v1/auth/logout',
    '/v1/auth/otp/request',
    '/v1/auth/otp/resend',
    '/v1/auth/otp/verify',
    '/v1/auth/refresh',
    '/v1/branches',
    '/v1/community/groups',
    '/v1/community/groups/{id}/posts',
    '/v1/community/mod/members/{id}/warn',
    '/v1/community/mod/posts/{id}/hide',
    '/v1/community/mod/posts/{id}/restore',
    '/v1/community/mod/reports',
    '/v1/community/posts/{id}/comments',
    '/v1/community/posts/{id}/reaction',
    '/v1/community/posts/{id}/report',
    '/v1/community/posts/{id}/vote',
    '/v1/complaint-categories',
    '/v1/config',
    '/v1/consent-texts',
    '/v1/courses',
    '/v1/interview-packs',
    '/v1/interview-packs/{id}/file',
    '/v1/me',
    '/v1/me/admission',
    '/v1/me/age-confirmation',
    '/v1/me/announcements',
    '/v1/me/attendance',
    '/v1/me/attendance-corrections',
    '/v1/me/batch-choices',
    '/v1/me/batches',
    '/v1/me/campus-handoff',
    '/v1/me/complaints',
    '/v1/me/complaints/{id}',
    '/v1/me/complaints/{id}/messages',
    '/v1/me/complaints/{id}/reopen',
    '/v1/me/consent-requests',
    '/v1/me/consent-requests/{id}/answer',
    '/v1/me/consents',
    '/v1/me/deletion-request',
    '/v1/me/fees',
    '/v1/me/jobs-access',
    '/v1/me/language',
    '/v1/me/link/auto',
    '/v1/me/link/request',
    '/v1/me/notifications',
    '/v1/me/notifications/read',
    '/v1/me/online-classes',
    '/v1/me/payment-orders',
    '/v1/me/payment-orders/{id}',
    '/v1/me/payout-account',
    '/v1/me/placement-prompts',
    '/v1/me/placement-prompts/{id}/dismiss',
    '/v1/me/placement-proofs',
    '/v1/me/practice-slots',
    '/v1/me/preferences',
    '/v1/me/profile',
    '/v1/me/push-token',
    '/v1/me/receipts',
    '/v1/me/receipts/{id}/pdf',
    '/v1/me/referral',
    '/v1/me/referral-code',
    '/v1/me/registrations',
    '/v1/me/registrations/{id}',
    '/v1/me/registrations/{id}/id-document',
    '/v1/me/registrations/{id}/submit',
    '/v1/me/registrations/{id}/terms',
    '/v1/me/registrations/{id}/undertaking',
    '/v1/me/registrations/{id}/video-complete',
    '/v1/me/registrations/{id}/video-start',
    '/v1/me/sessions',
    '/v1/me/test-scores',
    '/v1/me/timetable',
    '/v1/me/today',
    '/v1/me/videos',
    '/v1/playback/sessions',
    '/v1/playback/sessions/{id}/end',
    '/v1/playback/sessions/{id}/heartbeat',
    '/v1/public/branches',
    '/v1/public/courses',
    '/v1/public/enquiries',
    '/v1/quizzes/attempts/{id}/submit',
    '/v1/quizzes/daily',
    '/v1/quizzes/daily/submit',
    '/v1/quizzes/mock/attempts',
    '/v1/quizzes/mock/roles',
    '/v1/undertaking/current',
    '/v1/videos/{id}/extra-view-requests',
    '/v1/visitor/events',
    '/v1/visitor/lectures',
    '/v1/visitor/lectures/{id}/watched',
    '/v1/visitor/quizzes',
    '/v1/visitor/quizzes/{id}',
    '/v1/visitor/quizzes/{id}/attempts',
    '/v1/visitor/visits',
  };

  /// A sign-in step carries no session token, and its 401 is about what it
  /// sent (a wrong code), so it never ends the session.
  static Options get _anonymous =>
      Options(extra: {StudentAuthInterceptor.skipAuthKey: true});

  Future<StudentConfig> config() async => StudentConfig.fromJson(
    asMap(await _get<dynamic>(configPath, options: _anonymous)),
  );

  Future<OtpChallenge> requestOtp(String phone) async =>
      OtpChallenge.fromJson(
        asMap(
          await _post<dynamic>(
            otpRequestPath,
            body: {'phone': phone},
            options: _anonymous,
          ),
        ),
      );

  Future<OtpChallenge> resendOtp(String challengeId) async =>
      OtpChallenge.fromJson(
        asMap(
          await _post<dynamic>(
            otpResendPath,
            body: {'challenge_id': challengeId},
            options: _anonymous,
          ),
        ),
      );

  Future<SignedIn> verifyOtp({
    required String challengeId,
    required String code,
    required String installId,
    String? appVersion,
  }) async => SignedIn.fromJson(
    asMap(
      await _post<dynamic>(
        otpVerifyPath,
        body: {
          'challenge_id': challengeId,
          'code': code,
          'device': {
            'install_id': installId,
            'platform': 'android',
            if (appVersion != null) 'app_version': appVersion,
          },
        },
        options: _anonymous,
      ),
    ),
  );

  Future<TokenPair> refreshSession({
    required String refreshToken,
    required String installId,
  }) async => TokenPair.fromJson(
    asMap(
      await _post<dynamic>(
        refreshPath,
        body: {'refresh_token': refreshToken, 'install_id': installId},
        options: _anonymous,
      ),
    ),
  );

  Future<void> logout() => _post<void>(logoutPath);

  Future<StudentAccount> me() async =>
      StudentAccount.fromJson(asMap(await _get<dynamic>(mePath)));

  Future<StudentAccount> setLanguage(String language) async =>
      StudentAccount.fromJson(
        asMap(
          await _put<dynamic>(languagePath, body: {'language': language}),
        ),
      );

  Future<ThemePreference> preferences() async => ThemePreference.fromJson(
    asMap(await _get<dynamic>(preferencesPath)),
  );

  Future<ThemePreference> setPreferences(ThemeChoice theme) async =>
      ThemePreference.fromJson(
        asMap(
          await _put<dynamic>(preferencesPath, body: {'theme': theme.name}),
        ),
      );

  /// Registers this handset's FCM token for the install that signed in
  /// (`PUT /v1/me/push-token`).
  Future<void> setPushToken({
    required String installId,
    required String token,
  }) => _put<void>(
    pushTokenPath,
    body: {'install_id': installId, 'token': token},
  );

  Future<List<Branch>> branches() async {
    final json = asMap(await _get<dynamic>(branchesPath));
    return [
      for (final branch in asList(json['branches']))
        Branch.fromJson(asMap(branch)),
    ];
  }

  Future<LinkResult> linkAutomatically() async =>
      LinkResult.fromJson(asMap(await _post<dynamic>(linkAutoPath)));

  Future<LinkResult> requestLink({
    required int branchId,
    required String name,
    String? admissionNumber,
  }) async => LinkResult.fromJson(
    asMap(
      await _post<dynamic>(
        linkRequestPath,
        body: {
          'branch_id': branchId,
          'name': name,
          if (admissionNumber != null && admissionNumber.isNotEmpty)
            'admission_number': admissionNumber,
        },
      ),
    ),
  );

  Future<Admission> admission() async =>
      Admission.fromJson(asMap(await _get<dynamic>(admissionPath)));

  Future<List<ConsentText>> consentTexts() async {
    final json = asMap(await _get<dynamic>(consentTextsPath));
    return [
      for (final text in asList(json['texts']))
        ConsentText.fromJson(asMap(text)),
    ];
  }

  Future<List<ConsentRecord>> consents() async {
    final json = asMap(await _get<dynamic>(consentsPath));
    return [
      for (final record in asList(json['consents']))
        ConsentRecord.fromJson(asMap(record)),
    ];
  }

  Future<List<ConsentRecord>> setConsents({
    required bool shareProfile,
    required bool marketingStory,
    required int shareProfileVersion,
    required int marketingStoryVersion,
  }) async {
    final json = asMap(
      await _put<dynamic>(
        consentsPath,
        body: {
          'share_profile': shareProfile,
          'marketing_story': marketingStory,
          'text_versions': {
            'share_profile': shareProfileVersion,
            'marketing_story': marketingStoryVersion,
          },
        },
      ),
    );
    return [
      for (final record in asList(json['consents']))
        ConsentRecord.fromJson(asMap(record)),
    ];
  }

  Future<StudentAccount> confirmAge() async => StudentAccount.fromJson(
    asMap(await _post<dynamic>(ageConfirmationPath)),
  );

  Future<JobsAccess> jobsAccess() async =>
      JobsAccess.fromJson(asMap(await _get<dynamic>(jobsAccessPath)));

  Future<CampusHandoff> campusHandoff() async =>
      CampusHandoff.fromJson(asMap(await _post<dynamic>(campusHandoffPath)));

  Future<List<PlacementPrompt>> placementPrompts() async {
    final json = asMap(await _get<dynamic>(placementPromptsPath));
    return [
      for (final prompt in asList(json['prompts']))
        PlacementPrompt.fromJson(asMap(prompt)),
    ];
  }

  Future<PlacementPrompt> dismissPlacementPrompt(String id) async =>
      PlacementPrompt.fromJson(
        asMap(await _post<dynamic>('$placementPromptsPath/$id/dismiss')),
      );

  Future<List<ConsentRequest>> consentRequests() async {
    final json = asMap(await _get<dynamic>(consentRequestsPath));
    return [
      for (final request in asList(json['requests']))
        ConsentRequest.fromJson(asMap(request)),
    ];
  }

  Future<ConsentRequest> answerConsentRequest({
    required String id,
    required bool yes,
  }) async => ConsentRequest.fromJson(
    asMap(
      await _post<dynamic>(
        '$consentRequestsPath/$id/answer',
        body: {'answer': yes ? 'yes' : 'no'},
      ),
    ),
  );

  // ── The Stage 3/4 modules (#3-#6, #9) ─────────────────────────────────
  // These use the same transport as everything else (host guard, headers,
  // Idempotency-Key, session, renewer and typed Failure). They return the
  // contract's JSON shapes; screens read the keys they show.

  Future<Map<String, dynamic>> getJson(String path) async =>
      asMap(await _get<dynamic>(path));

  Future<Map<String, dynamic>> postJson(String path, [Object? body]) async =>
      asMap(await _post<dynamic>(path, body: body));

  Future<Map<String, dynamic>> putJson(String path, [Object? body]) async =>
      asMap(await _put<dynamic>(path, body: body));

  Future<Map<String, dynamic>> patchJson(String path, [Object? body]) async =>
      asMap(await _send<dynamic>(() => _dio.patch<dynamic>(path, data: body)));

  Future<void> deletePath(String path) async {
    await _send<dynamic>(() => _dio.delete<dynamic>(path));
  }

  /// A multipart write with one file (the ID document, a placement proof).
  Future<Map<String, dynamic>> uploadMultipart({
    required String path,
    required Map<String, String> fields,
    required String filePath,
    String fileField = 'file',
  }) async {
    final form = FormData.fromMap({
      ...fields,
      fileField: await MultipartFile.fromFile(filePath),
    });
    return asMap(
      await _send<dynamic>(() => _dio.post<dynamic>(path, data: form)),
    );
  }

  /// The ID document upload: JPEG, PNG or PDF, at most 5 MB; only the last
  /// four characters of the number are sent (contract, `/id-document`).
  Future<Map<String, dynamic>> uploadIdDocument({
    required String registrationId,
    required String filePath,
    required String idType,
    required String idLast4,
  }) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
      'id_type': idType,
      'id_last4': idLast4,
    });
    return asMap(
      await _send<dynamic>(
        () => _dio.post<dynamic>(
          '/v1/me/registrations/$registrationId/id-document',
          data: form,
        ),
      ),
    );
  }

  Future<T> _get<T>(String path, {Options? options}) => _send<T>(
    () => _dio.get<T>(path, options: options),
  );

  Future<T> _post<T>(String path, {Object? body, Options? options}) => _send<T>(
    () => _dio.post<T>(path, data: body, options: options),
  );

  Future<T> _put<T>(String path, {Object? body, Options? options}) => _send<T>(
    () => _dio.put<T>(path, data: body, options: options),
  );

  Future<T> _send<T>(Future<Response<T>> Function() call) async {
    try {
      return (await call()).data as T;
    } on DioException catch (error) {
      throw error.asFailure;
    }
  }
}
