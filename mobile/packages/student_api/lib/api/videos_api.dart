//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class VideosApi {
  VideosApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Close a playback
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
  Future<Response> endPlaybackWithHttpInfo(String id, String idempotencyKey, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/playback/sessions/{id}/end'
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

  /// Close a playback
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
  Future<PlaybackEnded?> endPlayback(String id, String idempotencyKey, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await endPlaybackWithHttpInfo(id, idempotencyKey, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PlaybackEnded',) as PlaybackEnded;
    
    }
    return null;
  }

  /// My video library
  ///
  /// Course videos of my courses, by course and module, and the recordings of my own batches. Each one has `views_left` and, when it cannot be played now, `locked_reason` (`FEE_PENDING`, `NOT_YOUR_COURSE`, `ACCESS_ENDED`, `NO_VIEWS_LEFT`). 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> listMyVideosWithHttpInfo({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/videos';

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

  /// My video library
  ///
  /// Course videos of my courses, by course and module, and the recordings of my own batches. Each one has `views_left` and, when it cannot be played now, `locked_reason` (`FEE_PENDING`, `NOT_YOUR_COURSE`, `ACCESS_ENDED`, `NO_VIEWS_LEFT`). 
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<VideoLibrary?> listMyVideos({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await listMyVideosWithHttpInfo(xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'VideoLibrary',) as VideoLibrary;
    
    }
    return null;
  }

  /// Report the position every 15 seconds
  ///
  /// `position_s` is the furthest second reached, `elapsed_s` the seconds played since the last beat. The answer can carry `stop: true` with a reason (`closed`, `replaced`, `revoked`): the player stops. 
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
  /// * [PlaybackBeat] playbackBeat (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> playbackHeartbeatWithHttpInfo(String id, String idempotencyKey, PlaybackBeat playbackBeat, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/playback/sessions/{id}/heartbeat'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = playbackBeat;

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

  /// Report the position every 15 seconds
  ///
  /// `position_s` is the furthest second reached, `elapsed_s` the seconds played since the last beat. The answer can carry `stop: true` with a reason (`closed`, `replaced`, `revoked`): the player stops. 
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [PlaybackBeat] playbackBeat (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<PlaybackBeatReply?> playbackHeartbeat(String id, String idempotencyKey, PlaybackBeat playbackBeat, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await playbackHeartbeatWithHttpInfo(id, idempotencyKey, playbackBeat, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PlaybackBeatReply',) as PlaybackBeatReply;
    
    }
    return null;
  }

  /// Ask my centre for another view of a video
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
  ///
  /// * [ExtraViewRequest] extraViewRequest:
  Future<Response> requestExtraViewWithHttpInfo(String id, String idempotencyKey, { String? xAppVersion, ExtraViewRequest? extraViewRequest, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/videos/{id}/extra-view-requests'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = extraViewRequest;

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

  /// Ask my centre for another view of a video
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
  ///
  /// * [ExtraViewRequest] extraViewRequest:
  Future<ExtraViewRequested?> requestExtraView(String id, String idempotencyKey, { String? xAppVersion, ExtraViewRequest? extraViewRequest, Future<void>? abortTrigger, }) async {
    final response = await requestExtraViewWithHttpInfo(id, idempotencyKey, xAppVersion: xAppVersion, extraViewRequest: extraViewRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ExtraViewRequested',) as ExtraViewRequested;
    
    }
    return null;
  }

  /// Start playing a video
  ///
  /// Checks access in this order: linked admission, full fee paid, the course is mine (or the recording is my batch's), access not ended (6 months after the course end), a view left. Then the device (the bound phone, or my one web session) and one open playback at a time. Returns how to play for this session only (see PlaybackStarted: a signed link to RVM's own storage by default, with the watermark text set by the server; or a VdoCipher token). A view is counted once 5% is watched; reopening within 60 minutes of a counted session does not count again. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [PlaybackStart] playbackStart (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> startPlaybackWithHttpInfo(String idempotencyKey, PlaybackStart playbackStart, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/playback/sessions';

    // ignore: prefer_final_locals
    Object? postBody = playbackStart;

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

  /// Start playing a video
  ///
  /// Checks access in this order: linked admission, full fee paid, the course is mine (or the recording is my batch's), access not ended (6 months after the course end), a view left. Then the device (the bound phone, or my one web session) and one open playback at a time. Returns how to play for this session only (see PlaybackStarted: a signed link to RVM's own storage by default, with the watermark text set by the server; or a VdoCipher token). A view is counted once 5% is watched; reopening within 60 minutes of a counted session does not count again. 
  ///
  /// Parameters:
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [PlaybackStart] playbackStart (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<PlaybackStarted?> startPlayback(String idempotencyKey, PlaybackStart playbackStart, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await startPlaybackWithHttpInfo(idempotencyKey, playbackStart, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PlaybackStarted',) as PlaybackStarted;
    
    }
    return null;
  }

  /// The video of an open playback, range by range (own storage)
  ///
  /// The `stream_url` of PlaybackStarted when `provider` is `self`. No sign-in header (a video element cannot send one): the `t` token is bound to this session and expires with it. Works only while the session is open: once it ends, is replaced or revoked, the answer is 410 `SESSION_ENDED`. Send `Range` as players do; the answer is 206 with `Content-Range`. Never a download: `Content-Disposition: inline`, `Cache-Control: no-store`. The app shows no download button and blocks screen recording on the player screen. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] t (required):
  ///
  /// * [String] range:
  Future<Response> streamPlaybackWithHttpInfo(String id, String t, { String? range, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/playback/sessions/{id}/stream'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 't', t));

    if (range != null) {
      headerParams[r'Range'] = parameterToString(range);
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

  /// The video of an open playback, range by range (own storage)
  ///
  /// The `stream_url` of PlaybackStarted when `provider` is `self`. No sign-in header (a video element cannot send one): the `t` token is bound to this session and expires with it. Works only while the session is open: once it ends, is replaced or revoked, the answer is 410 `SESSION_ENDED`. Send `Range` as players do; the answer is 206 with `Content-Range`. Never a download: `Content-Disposition: inline`, `Cache-Control: no-store`. The app shows no download button and blocks screen recording on the player screen. 
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] t (required):
  ///
  /// * [String] range:
  Future<MultipartFile?> streamPlayback(String id, String t, { String? range, Future<void>? abortTrigger, }) async {
    final response = await streamPlaybackWithHttpInfo(id, t, range: range, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MultipartFile',) as MultipartFile;
    
    }
    return null;
  }
}
