//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PublicApi {
  PublicApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// An enquiry from the website or the app (no sign-in)
  ///
  /// Stored first, then delivered to the CRM (one lead per phone: created or merged, with the page, form type and UTM fields). 202 means it is stored. The same phone, form type and page again within 10 minutes is the same enquiry. 5 an hour per phone, 20 per address. Form type `company` (a company that wants to hire) goes to the placement team, never the CRM. Each form type opens on its own (switch `website_enquiries`, then the setting's list of open forms); a closed one answers 503 `MODULE_OFF`. Leave `company_website` out: it is a trap field for bots. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [EnquiryCreate] enquiryCreate (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> createEnquiryWithHttpInfo(String idempotencyKey, EnquiryCreate enquiryCreate, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/public/enquiries';

    // ignore: prefer_final_locals
    Object? postBody = enquiryCreate;

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

  /// An enquiry from the website or the app (no sign-in)
  ///
  /// Stored first, then delivered to the CRM (one lead per phone: created or merged, with the page, form type and UTM fields). 202 means it is stored. The same phone, form type and page again within 10 minutes is the same enquiry. 5 an hour per phone, 20 per address. Form type `company` (a company that wants to hire) goes to the placement team, never the CRM. Each form type opens on its own (switch `website_enquiries`, then the setting's list of open forms); a closed one answers 503 `MODULE_OFF`. Leave `company_website` out: it is a trap field for bots. 
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [EnquiryCreate] enquiryCreate (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<EnquiryReceived?> createEnquiry(String idempotencyKey, EnquiryCreate enquiryCreate, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await createEnquiryWithHttpInfo(idempotencyKey, enquiryCreate, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EnquiryReceived',) as EnquiryReceived;
    
    }
    return null;
  }

  /// The branches (no sign-in)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> listPublicBranchesWithHttpInfo({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/public/branches';

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

  /// The branches (no sign-in)
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<PublicBranchList?> listPublicBranches({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await listPublicBranchesWithHttpInfo(xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PublicBranchList',) as PublicBranchList;
    
    }
    return null;
  }

  /// Courses, prices and next batches (no sign-in)
  ///
  /// For the website and the app's visitor area. Every course on sale (all of them unless one is hidden), with the price in paise read live from the price list, and the next batches per branch: start date, weekdays (0 = Sunday) and timings only. Never a faculty name or a seat count. Cached 2 minutes. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> listPublicCoursesWithHttpInfo({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/public/courses';

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

  /// Courses, prices and next batches (no sign-in)
  ///
  /// For the website and the app's visitor area. Every course on sale (all of them unless one is hidden), with the price in paise read live from the price list, and the next batches per branch: start date, weekdays (0 = Sunday) and timings only. Never a faculty name or a seat count. Cached 2 minutes. 
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<PublicCourseList?> listPublicCourses({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await listPublicCoursesWithHttpInfo(xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PublicCourseList',) as PublicCourseList;
    
    }
    return null;
  }
}
