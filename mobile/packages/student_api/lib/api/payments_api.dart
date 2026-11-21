//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PaymentsApi {
  PaymentsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Start a payment
  ///
  /// The server decides every amount: a joining payment from Rs 1,000 to the course fee; an instalment is the balance due up to `due_date` (any amount sent is ignored); `balance` is everything still due. The non-refundable tick of the current text version is required: `text_version` is the `version` of `GET /v1/me/payment-terms`. The joining limits, with any referral discount already taken off, are the registration's `joining_payment`. Until payments go live the order is a dry run: `mode: dry_run` and `checkout: null`, and no money can be taken. A live order's `checkout` opens Razorpay; only the signed webhook makes the receipt. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [PaymentOrderCreate] paymentOrderCreate (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> createPaymentOrderWithHttpInfo(String idempotencyKey, PaymentOrderCreate paymentOrderCreate, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/payment-orders';

    // ignore: prefer_final_locals
    Object? postBody = paymentOrderCreate;

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

  /// Start a payment
  ///
  /// The server decides every amount: a joining payment from Rs 1,000 to the course fee; an instalment is the balance due up to `due_date` (any amount sent is ignored); `balance` is everything still due. The non-refundable tick of the current text version is required: `text_version` is the `version` of `GET /v1/me/payment-terms`. The joining limits, with any referral discount already taken off, are the registration's `joining_payment`. Until payments go live the order is a dry run: `mode: dry_run` and `checkout: null`, and no money can be taken. A live order's `checkout` opens Razorpay; only the signed webhook makes the receipt. 
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [PaymentOrderCreate] paymentOrderCreate (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<PaymentOrderCreated?> createPaymentOrder(String idempotencyKey, PaymentOrderCreate paymentOrderCreate, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await createPaymentOrderWithHttpInfo(idempotencyKey, paymentOrderCreate, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PaymentOrderCreated',) as PaymentOrderCreated;
    
    }
    return null;
  }

  /// A payment's status
  ///
  /// `paid` turns true only when the signed webhook has made the receipt. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> getPaymentOrderWithHttpInfo(String id, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/payment-orders/{id}'
      .replaceAll('{id}', id);

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

  /// A payment's status
  ///
  /// `paid` turns true only when the signed webhook has made the receipt. 
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<PaymentOrder?> getPaymentOrder(String id, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await getPaymentOrderWithHttpInfo(id, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PaymentOrder',) as PaymentOrder;
    
    }
    return null;
  }

  /// The payment terms to show with the non-refundable tick
  ///
  /// Show `text` next to the tick before every payment and send `version` as the order's `text_version`. Read it each time the payment screen opens; when the text changes, the version goes up and an order with the old version is refused `ACCEPTANCE_REQUIRED`. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> getPaymentTermsWithHttpInfo({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/payment-terms';

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

  /// The payment terms to show with the non-refundable tick
  ///
  /// Show `text` next to the tick before every payment and send `version` as the order's `text_version`. Read it each time the payment screen opens; when the text changes, the version goes up and an order with the old version is refused `ACCEPTANCE_REQUIRED`. 
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<PaymentTerms?> getPaymentTerms({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await getPaymentTermsWithHttpInfo(xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PaymentTerms',) as PaymentTerms;
    
    }
    return null;
  }

  /// One receipt as a PDF
  ///
  /// The same facts as the centre's receipt, as a PDF in base64 (the app saves or shares it). Another student's receipt answers 404. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> getReceiptPdfWithHttpInfo(String id, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/receipts/{id}/pdf'
      .replaceAll('{id}', id);

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

  /// One receipt as a PDF
  ///
  /// The same facts as the centre's receipt, as a PDF in base64 (the app saves or shares it). Another student's receipt answers 404. 
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<ReceiptPdf?> getReceiptPdf(String id, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await getReceiptPdfWithHttpInfo(id, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ReceiptPdf',) as ReceiptPdf;
    
    }
    return null;
  }

  /// My receipts
  ///
  /// Every receipt of my admission, from the centre's desk and from the app, newest first. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> listReceiptsWithHttpInfo({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/receipts';

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

  /// My receipts
  ///
  /// Every receipt of my admission, from the centre's desk and from the app, newest first. 
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<ReceiptList?> listReceipts({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await listReceiptsWithHttpInfo(xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ReceiptList',) as ReceiptList;
    
    }
    return null;
  }
}
