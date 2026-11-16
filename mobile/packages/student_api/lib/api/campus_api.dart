//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class CampusApi {
  CampusApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Say yes or no to one company
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [ConsentAnswer] consentAnswer (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> answerConsentRequestWithHttpInfo(String id, String idempotencyKey, ConsentAnswer consentAnswer, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/consent-requests/{id}/answer'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = consentAnswer;

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

  /// Say yes or no to one company
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [ConsentAnswer] consentAnswer (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<ConsentRequest?> answerConsentRequest(String id, String idempotencyKey, ConsentAnswer consentAnswer, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await answerConsentRequestWithHttpInfo(id, idempotencyKey, consentAnswer, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ConsentRequest',) as ConsentRequest;
    
    }
    return null;
  }

  /// A one-minute link that opens Campus signed in
  ///
  /// Open `url` in the Jobs tab web view straight away; it works once and expires at `expires_at`. Never store it. Refused with 403 `JOBS_CLOSED` (with `details.reasons`) when Jobs access is not allowed. A retry with the same Idempotency-Key gets a NEW link (the link is never stored). At most 10 links a minute per account. 
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
  Future<Response> createCampusHandoffWithHttpInfo(String idempotencyKey, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/campus-handoff';

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

  /// A one-minute link that opens Campus signed in
  ///
  /// Open `url` in the Jobs tab web view straight away; it works once and expires at `expires_at`. Never store it. Refused with 403 `JOBS_CLOSED` (with `details.reasons`) when Jobs access is not allowed. A retry with the same Idempotency-Key gets a NEW link (the link is never stored). At most 10 links a minute per account. 
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<CampusHandoff?> createCampusHandoff(String idempotencyKey, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await createCampusHandoffWithHttpInfo(idempotencyKey, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CampusHandoff',) as CampusHandoff;
    
    }
    return null;
  }

  /// Hide a placement prompt
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> dismissPlacementPromptWithHttpInfo(String id, String idempotencyKey, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/placement-prompts/{id}/dismiss'
      .replaceAll('{id}', id);

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

  /// Hide a placement prompt
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<PlacementPrompt?> dismissPlacementPrompt(String id, String idempotencyKey, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await dismissPlacementPromptWithHttpInfo(id, idempotencyKey, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PlacementPrompt',) as PlacementPrompt;
    
    }
    return null;
  }

  /// Companies asking to see my profile
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> listConsentRequestsWithHttpInfo({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/consent-requests';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (xAppVersion != null) {
      headerParams[r'X-App-Version'] = parameterToString(xAppVersion);
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Companies asking to see my profile
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<ListConsentRequests200Response?> listConsentRequests({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await listConsentRequestsWithHttpInfo(xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ListConsentRequests200Response',) as ListConsentRequests200Response;
    
    }
    return null;
  }

  /// \"You were selected: upload your proof\" prompts
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> listPlacementPromptsWithHttpInfo({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/placement-prompts';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (xAppVersion != null) {
      headerParams[r'X-App-Version'] = parameterToString(xAppVersion);
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// \"You were selected: upload your proof\" prompts
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<ListPlacementPrompts200Response?> listPlacementPrompts({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await listPlacementPromptsWithHttpInfo(xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ListPlacementPrompts200Response',) as ListPlacementPrompts200Response;
    
    }
    return null;
  }
}
