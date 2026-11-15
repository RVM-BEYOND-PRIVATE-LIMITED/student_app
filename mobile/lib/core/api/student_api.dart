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

  /// The paths this client calls, for the contract drift test.
  static const paths = {
    configPath,
    otpRequestPath,
    otpResendPath,
    otpVerifyPath,
    refreshPath,
    logoutPath,
    mePath,
    languagePath,
    preferencesPath,
    sessionsPath,
    branchesPath,
    linkAutoPath,
    linkRequestPath,
    admissionPath,
    consentTextsPath,
    consentsPath,
    ageConfirmationPath,
    jobsAccessPath,
    campusHandoffPath,
    placementPromptsPath,
    consentRequestsPath,
    '$placementPromptsPath/{id}/dismiss',
    '$consentRequestsPath/{id}/answer',
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
