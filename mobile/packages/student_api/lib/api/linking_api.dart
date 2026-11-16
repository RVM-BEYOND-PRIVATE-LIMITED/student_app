//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class LinkingApi {
  LinkingApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// My admission and fee plan
  ///
  /// Read live on every call. An admission carried over from the old portal shows `paid_figures: legacy` and leaves out `total_paid_paise`, because its paid figures are not reliable. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> getAdmissionWithHttpInfo({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/admission';

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

  /// My admission and fee plan
  ///
  /// Read live on every call. An admission carried over from the old portal shows `paid_figures: legacy` and leaves out `total_paid_paise`, because its paid figures are not reliable. 
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Admission?> getAdmission({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await getAdmissionWithHttpInfo(xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Admission',) as Admission;
    
    }
    return null;
  }

  /// My fees, plan and fee hold
  ///
  /// Read live from the centre's records; nothing is stored. `plan_pending` is true until the centre enters the instalment plan. `fee_hold.on_hold` true means classes are closed until the overdue instalment is paid (the app shows the pay screen); fees and payment stay open. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> getFeesWithHttpInfo({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/fees';

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

  /// My fees, plan and fee hold
  ///
  /// Read live from the centre's records; nothing is stored. `plan_pending` is true until the centre enters the instalment plan. `fee_hold.on_hold` true means classes are closed until the overdue instalment is paid (the app shows the pay screen); fees and payment stay open. 
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Fees?> getFees({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await getFeesWithHttpInfo(xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Fees',) as Fees;
    
    }
    return null;
  }

  /// \"I have already paid\": find my admission by my phone
  ///
  /// Uses only the phone the student signed in with. One clear match links the account. No match, or more than one, answers `needs_centre` and says nothing about any admission. While the centre asks for a second proof (#211, off unless set), one clear match also needs the student's admission number: none sent, or a wrong one, answers `needs_admission_number` (after 3 wrong numbers in 24 hours, `needs_centre`). Letters and digits only are compared, in any case. The body is optional. 
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
  /// * [LinkAutomaticallyRequest] linkAutomaticallyRequest:
  Future<Response> linkAutomaticallyWithHttpInfo(String idempotencyKey, { String? xAppVersion, LinkAutomaticallyRequest? linkAutomaticallyRequest, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/link/auto';

    // ignore: prefer_final_locals
    Object? postBody = linkAutomaticallyRequest;

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

  /// \"I have already paid\": find my admission by my phone
  ///
  /// Uses only the phone the student signed in with. One clear match links the account. No match, or more than one, answers `needs_centre` and says nothing about any admission. While the centre asks for a second proof (#211, off unless set), one clear match also needs the student's admission number: none sent, or a wrong one, answers `needs_admission_number` (after 3 wrong numbers in 24 hours, `needs_centre`). Letters and digits only are compared, in any case. The body is optional. 
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  ///
  /// * [LinkAutomaticallyRequest] linkAutomaticallyRequest:
  Future<LinkResult?> linkAutomatically(String idempotencyKey, { String? xAppVersion, LinkAutomaticallyRequest? linkAutomaticallyRequest, Future<void>? abortTrigger, }) async {
    final response = await linkAutomaticallyWithHttpInfo(idempotencyKey, xAppVersion: xAppVersion, linkAutomaticallyRequest: linkAutomaticallyRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'LinkResult',) as LinkResult;
    
    }
    return null;
  }

  /// Centres and the number to call
  ///
  /// For the \"Ask your centre\" screen.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> listBranchesWithHttpInfo({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/branches';

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

  /// Centres and the number to call
  ///
  /// For the \"Ask your centre\" screen.
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<ListBranches200Response?> listBranches({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await listBranchesWithHttpInfo(xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ListBranches200Response',) as ListBranches200Response;
    
    }
    return null;
  }

  /// Ask the centre to link my admission
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [LinkRequest] linkRequest (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> requestLinkWithHttpInfo(String idempotencyKey, LinkRequest linkRequest, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/link/request';

    // ignore: prefer_final_locals
    Object? postBody = linkRequest;

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

  /// Ask the centre to link my admission
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [LinkRequest] linkRequest (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<LinkResult?> requestLink(String idempotencyKey, LinkRequest linkRequest, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await requestLinkWithHttpInfo(idempotencyKey, linkRequest, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'LinkResult',) as LinkResult;
    
    }
    return null;
  }
}
