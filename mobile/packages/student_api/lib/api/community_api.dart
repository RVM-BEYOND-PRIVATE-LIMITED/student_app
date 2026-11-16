//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class CommunityApi {
  CommunityApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// React to a post (once)
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
  Future<Response> addCommunityReactionWithHttpInfo(String id, String idempotencyKey, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/community/posts/{id}/reaction'
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
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// React to a post (once)
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
  Future<CommunityReaction?> addCommunityReaction(String id, String idempotencyKey, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await addCommunityReactionWithHttpInfo(id, idempotencyKey, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CommunityReaction',) as CommunityReaction;
    
    }
    return null;
  }

  /// Comment on a post
  ///
  /// Up to 1,000 characters, 5 a minute. The post's author gets a notice. A muted member (#296) gets 403 `COMMUNITY_MUTED` with `details.until`. 
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
  /// * [CommunityCommentCreate] communityCommentCreate (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> createCommunityCommentWithHttpInfo(String id, String idempotencyKey, CommunityCommentCreate communityCommentCreate, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/community/posts/{id}/comments'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = communityCommentCreate;

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

  /// Comment on a post
  ///
  /// Up to 1,000 characters, 5 a minute. The post's author gets a notice. A muted member (#296) gets 403 `COMMUNITY_MUTED` with `details.until`. 
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [CommunityCommentCreate] communityCommentCreate (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<CommunityCommentCreated?> createCommunityComment(String id, String idempotencyKey, CommunityCommentCreate communityCommentCreate, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await createCommunityCommentWithHttpInfo(id, idempotencyKey, communityCommentCreate, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CommunityCommentCreated',) as CommunityCommentCreated;
    
    }
    return null;
  }

  /// Post in a group
  ///
  /// Text up to 2,000 characters, with an optional poll of 2 to 6 options. Phone numbers, runs of 10 or more digits, UPI IDs and requests for money are refused with 422 `CONTENT_BLOCKED` and nothing is stored. 10 posts a day. A member muted after repeated upheld reports (#296, off unless the centre sets it) gets 403 `COMMUNITY_MUTED` with `details.until`. 
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
  /// * [CommunityPostCreate] communityPostCreate (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> createCommunityPostWithHttpInfo(String id, String idempotencyKey, CommunityPostCreate communityPostCreate, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/community/groups/{id}/posts'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = communityPostCreate;

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

  /// Post in a group
  ///
  /// Text up to 2,000 characters, with an optional poll of 2 to 6 options. Phone numbers, runs of 10 or more digits, UPI IDs and requests for money are refused with 422 `CONTENT_BLOCKED` and nothing is stored. 10 posts a day. A member muted after repeated upheld reports (#296, off unless the centre sets it) gets 403 `COMMUNITY_MUTED` with `details.until`. 
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [CommunityPostCreate] communityPostCreate (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<CommunityPost?> createCommunityPost(String id, String idempotencyKey, CommunityPostCreate communityPostCreate, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await createCommunityPostWithHttpInfo(id, idempotencyKey, communityPostCreate, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CommunityPost',) as CommunityPost;
    
    }
    return null;
  }

  /// Hide a post (moderators)
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
  /// * [CommunityHide] communityHide (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> hideCommunityPostWithHttpInfo(String id, String idempotencyKey, CommunityHide communityHide, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/community/mod/posts/{id}/hide'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = communityHide;

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

  /// Hide a post (moderators)
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [CommunityHide] communityHide (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<CommunityModerated?> hideCommunityPost(String id, String idempotencyKey, CommunityHide communityHide, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await hideCommunityPostWithHttpInfo(id, idempotencyKey, communityHide, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CommunityModerated',) as CommunityModerated;
    
    }
    return null;
  }

  /// A post's comments
  ///
  /// Oldest first, up to 200. One level: there are no replies to comments. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> listCommunityCommentsWithHttpInfo(String id, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/community/posts/{id}/comments'
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

  /// A post's comments
  ///
  /// Oldest first, up to 200. One level: there are no replies to comments. 
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<CommunityCommentList?> listCommunityComments(String id, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await listCommunityCommentsWithHttpInfo(id, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CommunityCommentList',) as CommunityCommentList;
    
    }
    return null;
  }

  /// My community groups
  ///
  /// The general group, the group of each course on my admission, and my branch's group. Registered, Fully paid and Alumni only; a Visitor gets 403 `STAGE_REQUIRED` on every community route. There are no private messages. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> listCommunityGroupsWithHttpInfo({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/community/groups';

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

  /// My community groups
  ///
  /// The general group, the group of each course on my admission, and my branch's group. Registered, Fully paid and Alumni only; a Visitor gets 403 `STAGE_REQUIRED` on every community route. There are no private messages. 
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<CommunityGroupList?> listCommunityGroups({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await listCommunityGroupsWithHttpInfo(xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CommunityGroupList',) as CommunityGroupList;
    
    }
    return null;
  }

  /// A group's feed
  ///
  /// 20 a page, newest first. Pass `next` back as `before` for the next page. Authors show as first name, course and branch. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] before:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> listCommunityPostsWithHttpInfo(String id, { String? before, String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/community/groups/{id}/posts'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (before != null) {
      queryParams.addAll(_queryParams('', 'before', before));
    }

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

  /// A group's feed
  ///
  /// 20 a page, newest first. Pass `next` back as `before` for the next page. Authors show as first name, course and branch. 
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] before:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<CommunityFeed?> listCommunityPosts(String id, { String? before, String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await listCommunityPostsWithHttpInfo(id, before: before, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CommunityFeed',) as CommunityFeed;
    
    }
    return null;
  }

  /// Review queue (student moderators)
  ///
  /// Posts with open reports in the groups I moderate: the count and the reasons, never who reported. A non-moderator gets 403 `NOT_MODERATOR`. 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> listCommunityReportsWithHttpInfo({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/community/mod/reports';

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

  /// Review queue (student moderators)
  ///
  /// Posts with open reports in the groups I moderate: the count and the reasons, never who reported. A non-moderator gets 403 `NOT_MODERATOR`. 
  ///
  /// Parameters:
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<CommunityReportQueue?> listCommunityReports({ String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await listCommunityReportsWithHttpInfo(xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CommunityReportQueue',) as CommunityReportQueue;
    
    }
    return null;
  }

  /// Take my reaction back
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
  Future<Response> removeCommunityReactionWithHttpInfo(String id, String idempotencyKey, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/community/posts/{id}/reaction'
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
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Take my reaction back
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
  Future<CommunityReaction?> removeCommunityReaction(String id, String idempotencyKey, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await removeCommunityReactionWithHttpInfo(id, idempotencyKey, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CommunityReaction',) as CommunityReaction;
    
    }
    return null;
  }

  /// Report a post
  ///
  /// The post is hidden at once for everyone but the moderators and goes to review. One report per member per post, 5 a day. Moderators never see who reported. 
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
  /// * [CommunityReportCreate] communityReportCreate (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> reportCommunityPostWithHttpInfo(String id, String idempotencyKey, CommunityReportCreate communityReportCreate, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/community/posts/{id}/report'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = communityReportCreate;

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

  /// Report a post
  ///
  /// The post is hidden at once for everyone but the moderators and goes to review. One report per member per post, 5 a day. Moderators never see who reported. 
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [CommunityReportCreate] communityReportCreate (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<CommunityReported?> reportCommunityPost(String id, String idempotencyKey, CommunityReportCreate communityReportCreate, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await reportCommunityPostWithHttpInfo(id, idempotencyKey, communityReportCreate, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CommunityReported',) as CommunityReported;
    
    }
    return null;
  }

  /// Restore a hidden post (moderators)
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
  /// * [CommunityRestore] communityRestore (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> restoreCommunityPostWithHttpInfo(String id, String idempotencyKey, CommunityRestore communityRestore, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/community/mod/posts/{id}/restore'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = communityRestore;

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

  /// Restore a hidden post (moderators)
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [CommunityRestore] communityRestore (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<CommunityModerated?> restoreCommunityPost(String id, String idempotencyKey, CommunityRestore communityRestore, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await restoreCommunityPostWithHttpInfo(id, idempotencyKey, communityRestore, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CommunityModerated',) as CommunityModerated;
    
    }
    return null;
  }

  /// Vote in a poll (once)
  ///
  /// A second vote by the same member answers 409 `ALREADY_VOTED`. 
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
  /// * [CommunityVote] communityVote (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> voteCommunityPollWithHttpInfo(String id, String idempotencyKey, CommunityVote communityVote, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/community/posts/{id}/vote'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = communityVote;

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

  /// Vote in a poll (once)
  ///
  /// A second vote by the same member answers 409 `ALREADY_VOTED`. 
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [CommunityVote] communityVote (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<CommunityPoll?> voteCommunityPoll(String id, String idempotencyKey, CommunityVote communityVote, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await voteCommunityPollWithHttpInfo(id, idempotencyKey, communityVote, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CommunityPoll',) as CommunityPoll;
    
    }
    return null;
  }

  /// Warn a member (moderators)
  ///
  /// `id` is the member's account id (`author_account_id` in the review queue). The member gets a notice with a generic line. 
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
  /// * [CommunityWarn] communityWarn (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<Response> warnCommunityMemberWithHttpInfo(String id, String idempotencyKey, CommunityWarn communityWarn, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/community/mod/members/{id}/warn'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = communityWarn;

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

  /// Warn a member (moderators)
  ///
  /// `id` is the member's account id (`author_account_id` in the review queue). The member gets a notice with a generic line. 
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] idempotencyKey (required):
  ///   A new random value for each action (a UUID is fine), reused only to retry that same action.
  ///
  /// * [CommunityWarn] communityWarn (required):
  ///
  /// * [String] xAppVersion:
  ///   The app's version, for example 1.2.0. The web version sends none.
  Future<CommunityWarned?> warnCommunityMember(String id, String idempotencyKey, CommunityWarn communityWarn, { String? xAppVersion, Future<void>? abortTrigger, }) async {
    final response = await warnCommunityMemberWithHttpInfo(id, idempotencyKey, communityWarn, xAppVersion: xAppVersion, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CommunityWarned',) as CommunityWarned;
    
    }
    return null;
  }
}
