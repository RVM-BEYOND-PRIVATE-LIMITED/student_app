//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class RewardsApi {
  RewardsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Apply a friend's referral code
  ///
  /// Before joining and before any payment. Refused for my own code, a second code, a phone that already has an admission or has paid, or a phone that was in touch with RVM before the code was made. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [ReferralApply] referralApply (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> applyReferralCodeWithHttpInfo(String idempotencyKey, ReferralApply referralApply, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/referral-code';

    // ignore: prefer_final_locals
    Object? postBody = referralApply;

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

  /// Apply a friend's referral code
  ///
  /// Before joining and before any payment. Refused for my own code, a second code, a phone that already has an admission or has paid, or a phone that was in touch with RVM before the code was made. 
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [ReferralApply] referralApply (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<ReferralApplied?> applyReferralCode(String idempotencyKey, ReferralApply referralApply, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await applyReferralCodeWithHttpInfo(idempotencyKey, referralApply, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ReferralApplied',) as ReferralApplied;
    
    }
    return null;
  }

  /// Where my rewards go
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> getPayoutAccountWithHttpInfo({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/payout-account';

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

  /// Where my rewards go
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<PayoutAccountReply?> getPayoutAccount({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await getPayoutAccountWithHttpInfo(xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PayoutAccountReply',) as PayoutAccountReply;
    
    }
    return null;
  }

  /// My referral code and how it is doing
  ///
  /// The code and link come once the account is linked to an admission. A friend who joins with it gets the referral discount; I get the referral reward once the friend's fee is fully received. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> getReferralWithHttpInfo({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/referral';

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

  /// My referral code and how it is doing
  ///
  /// The code and link come once the account is linked to an admission. A friend who joins with it gets the referral discount; I get the referral reward once the friend's fee is fully received. 
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Referral?> getReferral({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await getReferralWithHttpInfo(xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Referral',) as Referral;
    
    }
    return null;
  }

  /// My placement proofs
  ///
  /// Statuses: submitted, being_verified, approved, paid, rejected (with the reason). `reward` is the Rs 1,000 payout once a proof is approved. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> listPlacementProofsWithHttpInfo({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/placement-proofs';

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

  /// My placement proofs
  ///
  /// Statuses: submitted, being_verified, approved, paid, rejected (with the reason). `reward` is the Rs 1,000 payout once a proof is approved. 
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<PlacementProofList?> listPlacementProofs({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await listPlacementProofsWithHttpInfo(xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PlacementProofList',) as PlacementProofList;
    
    }
    return null;
  }

  /// Set my UPI ID or bank account
  ///
  /// Only the holder name and the last 4 characters are kept. While rewards are a dry run the account is kept `pending` and nothing is checked. Once rewards are live it is checked with RazorpayX first and saved only when the check passes (`status: verified`, or `pending` while the check is still running); an account that fails the check is not saved and an earlier verified one stays. Checks are capped per account and per day. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [PayoutAccountSet] payoutAccountSet (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> setPayoutAccountWithHttpInfo(String idempotencyKey, PayoutAccountSet payoutAccountSet, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/payout-account';

    // ignore: prefer_final_locals
    Object? postBody = payoutAccountSet;

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
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Set my UPI ID or bank account
  ///
  /// Only the holder name and the last 4 characters are kept. While rewards are a dry run the account is kept `pending` and nothing is checked. Once rewards are live it is checked with RazorpayX first and saved only when the check passes (`status: verified`, or `pending` while the check is still running); an account that fails the check is not saved and an earlier verified one stays. Checks are capped per account and per day. 
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [PayoutAccountSet] payoutAccountSet (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<PayoutAccountReply?> setPayoutAccount(String idempotencyKey, PayoutAccountSet payoutAccountSet, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await setPayoutAccountWithHttpInfo(idempotencyKey, payoutAccountSet, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PayoutAccountReply',) as PayoutAccountReply;
    
    }
    return null;
  }

  /// Send proof of a job
  ///
  /// multipart/form-data: `company_name`, `role`, `salary_paise` (monthly), `joining_date` and `file` (the offer or joining letter: JPEG, PNG or PDF, at most 5 MB). All are required. The placement team verifies it within 14 days. For a student linked to an admission. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [String] companyName (required):
  ///
  /// * [String] role (required):
  ///
  /// * [int] salaryPaise (required):
  ///
  /// * [DateTime] joiningDate (required):
  ///
  /// * [MultipartFile] file (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> submitPlacementProofWithHttpInfo(String idempotencyKey, String companyName, String role, int salaryPaise, DateTime joiningDate, MultipartFile file, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/placement-proofs';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    headerParams[r'Idempotency-Key'] = parameterToString(idempotencyKey);
    if (xAppVersion != null) {
      headerParams[r'X-App-Version'] = parameterToString(xAppVersion);
    }

    const contentTypes = <String>['multipart/form-data'];

    bool hasFields = false;
    final mp = MultipartRequest('POST', Uri.parse(path));
    if (companyName != null) {
      hasFields = true;
      mp.fields[r'company_name'] = parameterToString(companyName);
    }
    if (role != null) {
      hasFields = true;
      mp.fields[r'role'] = parameterToString(role);
    }
    if (salaryPaise != null) {
      hasFields = true;
      mp.fields[r'salary_paise'] = parameterToString(salaryPaise);
    }
    if (joiningDate != null) {
      hasFields = true;
      mp.fields[r'joining_date'] = parameterToString(joiningDate);
    }
    if (file != null) {
      hasFields = true;
      mp.fields[r'file'] = file.field;
      mp.files.add(file);
    }
    if (hasFields) {
      postBody = mp;
    }

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

  /// Send proof of a job
  ///
  /// multipart/form-data: `company_name`, `role`, `salary_paise` (monthly), `joining_date` and `file` (the offer or joining letter: JPEG, PNG or PDF, at most 5 MB). All are required. The placement team verifies it within 14 days. For a student linked to an admission. 
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [String] companyName (required):
  ///
  /// * [String] role (required):
  ///
  /// * [int] salaryPaise (required):
  ///
  /// * [DateTime] joiningDate (required):
  ///
  /// * [MultipartFile] file (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<PlacementProofCreated?> submitPlacementProof(String idempotencyKey, String companyName, String role, int salaryPaise, DateTime joiningDate, MultipartFile file, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await submitPlacementProofWithHttpInfo(idempotencyKey, companyName, role, salaryPaise, joiningDate, file, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PlacementProofCreated',) as PlacementProofCreated;
    
    }
    return null;
  }
}
