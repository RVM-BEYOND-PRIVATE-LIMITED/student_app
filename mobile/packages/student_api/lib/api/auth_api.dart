//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AuthApi {
  AuthApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// End this session
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> logoutWithHttpInfo(String idempotencyKey, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/auth/logout';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    headerParams[r'Idempotency-Key'] = parameterToString(idempotencyKey);
    if (xAppVersion != null) {
      headerParams[r'X-App-Version'] = parameterToString(xAppVersion);
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// End this session
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<void> logout(String idempotencyKey, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await logoutWithHttpInfo(idempotencyKey, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Swap a refresh token for a new pair
  ///
  /// Every refresh token is used once. Sending an old one again ends every session of that sign-in. If the reply to a refresh is lost on a bad network, sending the same token again from the same install shortly afterwards still works once.  The web version sends no body: the cookie carries the token, and the request must come from an allowed origin. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  ///
  /// * [RefreshRequest] refreshRequest:
  Future<Response> refreshSessionWithHttpInfo(String idempotencyKey, { String? xAppVersion, RefreshRequest? refreshRequest, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/auth/refresh';

    // ignore: prefer_final_locals
    Object? postBody = refreshRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    headerParams[r'Idempotency-Key'] = parameterToString(idempotencyKey);
    if (xAppVersion != null) {
      headerParams[r'X-App-Version'] = parameterToString(xAppVersion);
    }

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Swap a refresh token for a new pair
  ///
  /// Every refresh token is used once. Sending an old one again ends every session of that sign-in. If the reply to a refresh is lost on a bad network, sending the same token again from the same install shortly afterwards still works once.  The web version sends no body: the cookie carries the token, and the request must come from an allowed origin. 
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  ///
  /// * [RefreshRequest] refreshRequest:
  Future<TokenPair?> refreshSession(String idempotencyKey, { String? xAppVersion, RefreshRequest? refreshRequest, Future<void>? abortTrigger, }) async {
    final response = await refreshSessionWithHttpInfo(idempotencyKey, xAppVersion: xAppVersion, refreshRequest: refreshRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TokenPair',) as TokenPair;
    
    }
    return null;
  }

  /// Send a sign-in code to a phone
  ///
  /// The code goes on WhatsApp; if that cannot be sent it goes by SMS at once. The reply is the same whether or not the phone already has an account. While the app is open only to a pilot, a phone outside it gets the same reply and no message; every reply then carries `pilot: true`, so the app should not say that a code was sent. When the app is closed to everyone the reply is 503 `MODULE_OFF`. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [OtpRequest] otpRequest (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> requestOtpWithHttpInfo(String idempotencyKey, OtpRequest otpRequest, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/auth/otp/request';

    // ignore: prefer_final_locals
    Object? postBody = otpRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    headerParams[r'Idempotency-Key'] = parameterToString(idempotencyKey);
    if (xAppVersion != null) {
      headerParams[r'X-App-Version'] = parameterToString(xAppVersion);
    }

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Send a sign-in code to a phone
  ///
  /// The code goes on WhatsApp; if that cannot be sent it goes by SMS at once. The reply is the same whether or not the phone already has an account. While the app is open only to a pilot, a phone outside it gets the same reply and no message; every reply then carries `pilot: true`, so the app should not say that a code was sent. When the app is closed to everyone the reply is 503 `MODULE_OFF`. 
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [OtpRequest] otpRequest (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<OtpChallenge?> requestOtp(String idempotencyKey, OtpRequest otpRequest, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await requestOtpWithHttpInfo(idempotencyKey, otpRequest, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OtpChallenge',) as OtpChallenge;
    
    }
    return null;
  }

  /// Send the same code again by SMS
  ///
  /// Once per challenge, after `resend_available_at`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [OtpResend] otpResend (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> resendOtpWithHttpInfo(String idempotencyKey, OtpResend otpResend, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/auth/otp/resend';

    // ignore: prefer_final_locals
    Object? postBody = otpResend;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    headerParams[r'Idempotency-Key'] = parameterToString(idempotencyKey);
    if (xAppVersion != null) {
      headerParams[r'X-App-Version'] = parameterToString(xAppVersion);
    }

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Send the same code again by SMS
  ///
  /// Once per challenge, after `resend_available_at`.
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [OtpResend] otpResend (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<OtpChallenge?> resendOtp(String idempotencyKey, OtpResend otpResend, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await resendOtpWithHttpInfo(idempotencyKey, otpResend, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OtpChallenge',) as OtpChallenge;
    
    }
    return null;
  }

  /// Sign in with the code
  ///
  /// Finds or creates the account, binds this device and opens a session. The app keeps the refresh token in secure storage. The web version gets the refresh token as an httpOnly cookie instead, and `refresh_token` is absent from the reply.  A linked student signing in on a second phone while the first is still active gets 409 `DEVICE_CHANGE_NEEDS_CENTRE`: the centre approves the new phone. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [OtpVerify] otpVerify (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> verifyOtpWithHttpInfo(String idempotencyKey, OtpVerify otpVerify, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/auth/otp/verify';

    // ignore: prefer_final_locals
    Object? postBody = otpVerify;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    headerParams[r'Idempotency-Key'] = parameterToString(idempotencyKey);
    if (xAppVersion != null) {
      headerParams[r'X-App-Version'] = parameterToString(xAppVersion);
    }

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Sign in with the code
  ///
  /// Finds or creates the account, binds this device and opens a session. The app keeps the refresh token in secure storage. The web version gets the refresh token as an httpOnly cookie instead, and `refresh_token` is absent from the reply.  A linked student signing in on a second phone while the first is still active gets 409 `DEVICE_CHANGE_NEEDS_CENTRE`: the centre approves the new phone. 
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [OtpVerify] otpVerify (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<SignedIn?> verifyOtp(String idempotencyKey, OtpVerify otpVerify, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await verifyOtpWithHttpInfo(idempotencyKey, otpVerify, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SignedIn',) as SignedIn;
    
    }
    return null;
  }
}
