//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ApiClient {
  ApiClient({this.basePath = 'http://127.0.0.1:4010', this.authentication,});

  final String basePath;
  final Authentication? authentication;

  var _client = Client();
  final _defaultHeaderMap = <String, String>{};

  /// Returns the current HTTP [Client] instance to use in this class.
  ///
  /// The return value is guaranteed to never be null.
  Client get client => _client;

  /// Requests to use a new HTTP [Client] in this class.
  set client(Client newClient) {
    _client = newClient;
  }

  Map<String, String> get defaultHeaderMap => _defaultHeaderMap;

  void addDefaultHeader(String key, String value) {
     _defaultHeaderMap[key] = value;
  }

  // We don't use a Map<String, String> for queryParams.
  // If collectionFormat is 'multi', a key might appear multiple times.
  Future<Response> invokeAPI(
    String path,
    String method,
    List<QueryParam> queryParams,
    Object? body,
    Map<String, String> headerParams,
    Map<String, String> formParams,
    String? contentType, {
    Future<void>? abortTrigger,
  }) async {
    await authentication?.applyToParams(queryParams, headerParams);

    headerParams.addAll(_defaultHeaderMap);
    if (contentType != null) {
      headerParams['Content-Type'] = contentType;
    }

    final urlEncodedQueryParams = queryParams.map((param) => '$param');
    final queryString = urlEncodedQueryParams.isNotEmpty ? '?${urlEncodedQueryParams.join('&')}' : '';
    final uri = Uri.parse('$basePath$path$queryString');

    try {
      // Special case for uploading a single file which isn't a 'multipart/form-data'.
      if (
        body is MultipartFile && (contentType == null ||
        !contentType.toLowerCase().startsWith('multipart/form-data'))
      ) {
        final request = AbortableStreamedRequest(method, uri, abortTrigger: abortTrigger);
        request.headers.addAll(headerParams);
        request.contentLength = body.length;
        body.finalize().listen(
          request.sink.add,
          onDone: request.sink.close,
          // ignore: avoid_types_on_closure_parameters
          onError: (Object error, StackTrace trace) => request.sink.close(),
          cancelOnError: true,
        );
        final response = await _client.send(request);
        return Response.fromStream(response);
      }

      if (body is MultipartRequest) {
        final request = AbortableMultipartRequest(method, uri, abortTrigger: abortTrigger);
        request.fields.addAll(body.fields);
        request.files.addAll(body.files);
        request.headers.addAll(body.headers);
        request.headers.addAll(headerParams);
        final response = await _client.send(request);
        return Response.fromStream(response);
      }

      final msgBody = contentType == 'application/x-www-form-urlencoded'
        ? formParams
        : await serializeAsync(body);
      final nullableHeaderParams = headerParams.isEmpty ? null : headerParams;

      final request = AbortableRequest(method, uri, abortTrigger: abortTrigger);
      if (nullableHeaderParams != null) {
        request.headers.addAll(nullableHeaderParams);
      }
      if (msgBody is String && msgBody.isNotEmpty) {
        request.body = msgBody;
      } else if (msgBody is List<int> && msgBody.isNotEmpty) {
        request.bodyBytes = msgBody;
      } else if (msgBody is Map<String, String>) {
        request.bodyFields = msgBody;
      }
      final response = await _client.send(request);
      return Response.fromStream(response);
    } on SocketException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'Socket operation failed: $method $path',
        error,
        trace,
      );
    } on TlsException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'TLS/SSL communication failed: $method $path',
        error,
        trace,
      );
    } on IOException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'I/O operation failed: $method $path',
        error,
        trace,
      );
    } on ClientException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'HTTP connection failed: $method $path',
        error,
        trace,
      );
    } on Exception catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'Exception occurred: $method $path',
        error,
        trace,
      );
    }
  }

  Future<dynamic> deserializeAsync(String value, String targetType, {bool growable = false,}) async =>
    // ignore: deprecated_member_use_from_same_package
    deserialize(value, targetType, growable: growable);

  @Deprecated('Scheduled for removal in OpenAPI Generator 6.x. Use deserializeAsync() instead.')
  dynamic deserialize(String value, String targetType, {bool growable = false,}) {
    // Remove all spaces. Necessary for regular expressions as well.
    targetType = targetType.replaceAll(' ', ''); // ignore: parameter_assignments

    // If the expected target type is String, nothing to do...
    return targetType == 'String'
      ? value
      : fromJson(json.decode(value), targetType, growable: growable);
  }

  // ignore: deprecated_member_use_from_same_package
  Future<String> serializeAsync(Object? value) async => serialize(value);

  @Deprecated('Scheduled for removal in OpenAPI Generator 6.x. Use serializeAsync() instead.')
  String serialize(Object? value) => value == null ? '' : json.encode(value);

  /// Returns a native instance of an OpenAPI class matching the [specified type][targetType].
  static dynamic fromJson(dynamic value, String targetType, {bool growable = false,}) {
    try {
      switch (targetType) {
        case 'String':
          return value is String ? value : value.toString();
        case 'int':
          return value is int ? value : int.parse('$value');
        case 'double':
          return value is double ? value : double.parse('$value');
        case 'bool':
          if (value is bool) {
            return value;
          }
          final valueString = '$value'.toLowerCase();
          return valueString == 'true' || valueString == '1';
        case 'DateTime':
          return value is DateTime ? value : DateTime.tryParse(value);
        case 'Admission':
          return Admission.fromJson(value);
        case 'AdmissionBranch':
          return AdmissionBranch.fromJson(value);
        case 'AdmissionPlanInner':
          return AdmissionPlanInner.fromJson(value);
        case 'AnnouncementList':
          return AnnouncementList.fromJson(value);
        case 'AnnouncementListAnnouncementsInner':
          return AnnouncementListAnnouncementsInner.fromJson(value);
        case 'Attendance':
          return Attendance.fromJson(value);
        case 'AttendanceSessionsInner':
          return AttendanceSessionsInner.fromJson(value);
        case 'AttendanceSummary':
          return AttendanceSummary.fromJson(value);
        case 'BatchChoice':
          return BatchChoice.fromJson(value);
        case 'BatchChosen':
          return BatchChosen.fromJson(value);
        case 'BatchOption':
          return BatchOption.fromJson(value);
        case 'BatchOptionCourse':
          return BatchOptionCourse.fromJson(value);
        case 'Branch':
          return Branch.fromJson(value);
        case 'CampusHandoff':
          return CampusHandoff.fromJson(value);
        case 'ClassItem':
          return ClassItem.fromJson(value);
        case 'CommunityComment':
          return CommunityComment.fromJson(value);
        case 'CommunityCommentCreate':
          return CommunityCommentCreate.fromJson(value);
        case 'CommunityCommentCreated':
          return CommunityCommentCreated.fromJson(value);
        case 'CommunityCommentList':
          return CommunityCommentList.fromJson(value);
        case 'CommunityCommentReportQueue':
          return CommunityCommentReportQueue.fromJson(value);
        case 'CommunityCommentReportQueueReportsInner':
          return CommunityCommentReportQueueReportsInner.fromJson(value);
        case 'CommunityFeed':
          return CommunityFeed.fromJson(value);
        case 'CommunityGroup':
          return CommunityGroup.fromJson(value);
        case 'CommunityGroupList':
          return CommunityGroupList.fromJson(value);
        case 'CommunityHide':
          return CommunityHide.fromJson(value);
        case 'CommunityModerated':
          return CommunityModerated.fromJson(value);
        case 'CommunityPoll':
          return CommunityPoll.fromJson(value);
        case 'CommunityPollOption':
          return CommunityPollOption.fromJson(value);
        case 'CommunityPost':
          return CommunityPost.fromJson(value);
        case 'CommunityPostCreate':
          return CommunityPostCreate.fromJson(value);
        case 'CommunityReaction':
          return CommunityReaction.fromJson(value);
        case 'CommunityReportCreate':
          return CommunityReportCreate.fromJson(value);
        case 'CommunityReportQueue':
          return CommunityReportQueue.fromJson(value);
        case 'CommunityReportQueueReportsInner':
          return CommunityReportQueueReportsInner.fromJson(value);
        case 'CommunityReported':
          return CommunityReported.fromJson(value);
        case 'CommunityRestore':
          return CommunityRestore.fromJson(value);
        case 'CommunityVote':
          return CommunityVote.fromJson(value);
        case 'CommunityWarn':
          return CommunityWarn.fromJson(value);
        case 'CommunityWarned':
          return CommunityWarned.fromJson(value);
        case 'Complaint':
          return Complaint.fromJson(value);
        case 'ComplaintCategory':
          return ComplaintCategory.fromJson(value);
        case 'ComplaintCategoryList':
          return ComplaintCategoryList.fromJson(value);
        case 'ComplaintList':
          return ComplaintList.fromJson(value);
        case 'ComplaintMessage':
          return ComplaintMessage.fromJson(value);
        case 'ComplaintMessageBody':
          return ComplaintMessageBody.fromJson(value);
        case 'ComplaintRaise':
          return ComplaintRaise.fromJson(value);
        case 'ComplaintReopen':
          return ComplaintReopen.fromJson(value);
        case 'ComplaintThread':
          return ComplaintThread.fromJson(value);
        case 'Config':
          return Config.fromJson(value);
        case 'ConfigMaintenance':
          return ConfigMaintenance.fromJson(value);
        case 'ConsentAnswer':
          return ConsentAnswer.fromJson(value);
        case 'ConsentChoice':
          return ConsentChoice.fromJson(value);
        case 'ConsentChoiceTextVersions':
          return ConsentChoiceTextVersions.fromJson(value);
        case 'ConsentPurpose':
          return ConsentPurposeTypeTransformer().decode(value);
        case 'ConsentRequest':
          return ConsentRequest.fromJson(value);
        case 'ConsentText':
          return ConsentText.fromJson(value);
        case 'Consents':
          return Consents.fromJson(value);
        case 'ConsentsConsentsInner':
          return ConsentsConsentsInner.fromJson(value);
        case 'Correction':
          return Correction.fromJson(value);
        case 'CorrectionList':
          return CorrectionList.fromJson(value);
        case 'CorrectionRequest':
          return CorrectionRequest.fromJson(value);
        case 'Course':
          return Course.fromJson(value);
        case 'DailyQuiz':
          return DailyQuiz.fromJson(value);
        case 'DailyQuizQuestionsInner':
          return DailyQuizQuestionsInner.fromJson(value);
        case 'DailyQuizQuestionsInnerOptionsInner':
          return DailyQuizQuestionsInnerOptionsInner.fromJson(value);
        case 'DeletionRequested':
          return DeletionRequested.fromJson(value);
        case 'Device':
          return Device.fromJson(value);
        case 'EnquiryCreate':
          return EnquiryCreate.fromJson(value);
        case 'EnquiryReceived':
          return EnquiryReceived.fromJson(value);
        case 'Error':
          return Error.fromJson(value);
        case 'ExtraViewRequest':
          return ExtraViewRequest.fromJson(value);
        case 'ExtraViewRequested':
          return ExtraViewRequested.fromJson(value);
        case 'Fees':
          return Fees.fromJson(value);
        case 'FreeLectureList':
          return FreeLectureList.fromJson(value);
        case 'FreeLectureListLecturesInner':
          return FreeLectureListLecturesInner.fromJson(value);
        case 'InterviewPackLink':
          return InterviewPackLink.fromJson(value);
        case 'InterviewPacks':
          return InterviewPacks.fromJson(value);
        case 'InterviewPacksRolesInner':
          return InterviewPacksRolesInner.fromJson(value);
        case 'InterviewPacksRolesInnerPacksInner':
          return InterviewPacksRolesInnerPacksInner.fromJson(value);
        case 'JobsAccess':
          return JobsAccess.fromJson(value);
        case 'JobsHeader':
          return JobsHeader.fromJson(value);
        case 'JobsHeaderLogosInner':
          return JobsHeaderLogosInner.fromJson(value);
        case 'JobsReason':
          return JobsReasonTypeTransformer().decode(value);
        case 'LanguageChoice':
          return LanguageChoice.fromJson(value);
        case 'LectureWatched':
          return LectureWatched.fromJson(value);
        case 'LinkAutomaticallyRequest':
          return LinkAutomaticallyRequest.fromJson(value);
        case 'LinkRequest':
          return LinkRequest.fromJson(value);
        case 'LinkResult':
          return LinkResult.fromJson(value);
        case 'ListBatches200Response':
          return ListBatches200Response.fromJson(value);
        case 'ListBranches200Response':
          return ListBranches200Response.fromJson(value);
        case 'ListConsentRequests200Response':
          return ListConsentRequests200Response.fromJson(value);
        case 'ListConsentTexts200Response':
          return ListConsentTexts200Response.fromJson(value);
        case 'ListCourses200Response':
          return ListCourses200Response.fromJson(value);
        case 'ListPlacementPrompts200Response':
          return ListPlacementPrompts200Response.fromJson(value);
        case 'ListPracticeSlots200Response':
          return ListPracticeSlots200Response.fromJson(value);
        case 'ListSessions200Response':
          return ListSessions200Response.fromJson(value);
        case 'MarkNotificationsReadRequest':
          return MarkNotificationsReadRequest.fromJson(value);
        case 'Me':
          return Me.fromJson(value);
        case 'MeCounts':
          return MeCounts.fromJson(value);
        case 'MeOnboarding':
          return MeOnboarding.fromJson(value);
        case 'MockRoles':
          return MockRoles.fromJson(value);
        case 'MockStart':
          return MockStart.fromJson(value);
        case 'MockStarted':
          return MockStarted.fromJson(value);
        case 'NotificationList':
          return NotificationList.fromJson(value);
        case 'NotificationListNotificationsInner':
          return NotificationListNotificationsInner.fromJson(value);
        case 'Ok':
          return Ok.fromJson(value);
        case 'OnlineClasses':
          return OnlineClasses.fromJson(value);
        case 'OnlineClassesClassesInner':
          return OnlineClassesClassesInner.fromJson(value);
        case 'OtpChallenge':
          return OtpChallenge.fromJson(value);
        case 'OtpRequest':
          return OtpRequest.fromJson(value);
        case 'OtpResend':
          return OtpResend.fromJson(value);
        case 'OtpVerify':
          return OtpVerify.fromJson(value);
        case 'PaymentOrder':
          return PaymentOrder.fromJson(value);
        case 'PaymentOrderCreate':
          return PaymentOrderCreate.fromJson(value);
        case 'PaymentOrderCreated':
          return PaymentOrderCreated.fromJson(value);
        case 'PaymentOrderCreatedCheckout':
          return PaymentOrderCreatedCheckout.fromJson(value);
        case 'PayoutAccountReply':
          return PayoutAccountReply.fromJson(value);
        case 'PayoutAccountReplyAccount':
          return PayoutAccountReplyAccount.fromJson(value);
        case 'PayoutAccountSet':
          return PayoutAccountSet.fromJson(value);
        case 'PlacementPrompt':
          return PlacementPrompt.fromJson(value);
        case 'PlacementProofCreated':
          return PlacementProofCreated.fromJson(value);
        case 'PlacementProofList':
          return PlacementProofList.fromJson(value);
        case 'PlacementProofListProofsInner':
          return PlacementProofListProofsInner.fromJson(value);
        case 'PlacementProofListProofsInnerReward':
          return PlacementProofListProofsInnerReward.fromJson(value);
        case 'PlaybackBeat':
          return PlaybackBeat.fromJson(value);
        case 'PlaybackBeatReply':
          return PlaybackBeatReply.fromJson(value);
        case 'PlaybackEnded':
          return PlaybackEnded.fromJson(value);
        case 'PlaybackStart':
          return PlaybackStart.fromJson(value);
        case 'PlaybackStarted':
          return PlaybackStarted.fromJson(value);
        case 'PracticeSlot':
          return PracticeSlot.fromJson(value);
        case 'PracticeSlotBranch':
          return PracticeSlotBranch.fromJson(value);
        case 'Profile':
          return Profile.fromJson(value);
        case 'ProfileContactPreferences':
          return ProfileContactPreferences.fromJson(value);
        case 'ProfilePatch':
          return ProfilePatch.fromJson(value);
        case 'PublicBranchList':
          return PublicBranchList.fromJson(value);
        case 'PublicCourseList':
          return PublicCourseList.fromJson(value);
        case 'PublicCourseListCoursesInner':
          return PublicCourseListCoursesInner.fromJson(value);
        case 'PublicCourseListCoursesInnerNextBatchesInner':
          return PublicCourseListCoursesInnerNextBatchesInner.fromJson(value);
        case 'Quiz':
          return Quiz.fromJson(value);
        case 'QuizAnswers':
          return QuizAnswers.fromJson(value);
        case 'QuizAttemptCreate':
          return QuizAttemptCreate.fromJson(value);
        case 'QuizAttemptResult':
          return QuizAttemptResult.fromJson(value);
        case 'QuizAttemptResultSuggestedCourse':
          return QuizAttemptResultSuggestedCourse.fromJson(value);
        case 'QuizList':
          return QuizList.fromJson(value);
        case 'QuizListQuizzesInner':
          return QuizListQuizzesInner.fromJson(value);
        case 'QuizQuestionsInner':
          return QuizQuestionsInner.fromJson(value);
        case 'QuizQuestionsInnerOptionsInner':
          return QuizQuestionsInnerOptionsInner.fromJson(value);
        case 'QuizResult':
          return QuizResult.fromJson(value);
        case 'ReceiptList':
          return ReceiptList.fromJson(value);
        case 'ReceiptListReceiptsInner':
          return ReceiptListReceiptsInner.fromJson(value);
        case 'ReceiptPdf':
          return ReceiptPdf.fromJson(value);
        case 'Referral':
          return Referral.fromJson(value);
        case 'ReferralApplied':
          return ReferralApplied.fromJson(value);
        case 'ReferralApply':
          return ReferralApply.fromJson(value);
        case 'ReferralReferrals':
          return ReferralReferrals.fromJson(value);
        case 'RefreshRequest':
          return RefreshRequest.fromJson(value);
        case 'Registration':
          return Registration.fromJson(value);
        case 'RegistrationFields':
          return RegistrationFields.fromJson(value);
        case 'RegistrationIdDocument':
          return RegistrationIdDocument.fromJson(value);
        case 'RegistrationUndertaking':
          return RegistrationUndertaking.fromJson(value);
        case 'RequestDeletionRequest':
          return RequestDeletionRequest.fromJson(value);
        case 'Session':
          return Session.fromJson(value);
        case 'SetPushTokenRequest':
          return SetPushTokenRequest.fromJson(value);
        case 'SignedIn':
          return SignedIn.fromJson(value);
        case 'Stage':
          return StageTypeTransformer().decode(value);
        case 'TermsAccepted':
          return TermsAccepted.fromJson(value);
        case 'TestScores':
          return TestScores.fromJson(value);
        case 'TestScoresCoursesInner':
          return TestScoresCoursesInner.fromJson(value);
        case 'TestScoresTestsInner':
          return TestScoresTestsInner.fromJson(value);
        case 'ThemeChoice':
          return ThemeChoice.fromJson(value);
        case 'ThemePreference':
          return ThemePreference.fromJson(value);
        case 'Timetable':
          return Timetable.fromJson(value);
        case 'Today':
          return Today.fromJson(value);
        case 'TodayFeeHold':
          return TodayFeeHold.fromJson(value);
        case 'TokenPair':
          return TokenPair.fromJson(value);
        case 'Undertaking':
          return Undertaking.fromJson(value);
        case 'UndertakingTermsInner':
          return UndertakingTermsInner.fromJson(value);
        case 'UndertakingVideo':
          return UndertakingVideo.fromJson(value);
        case 'VideoLibrary':
          return VideoLibrary.fromJson(value);
        case 'VideoLibraryVideosInner':
          return VideoLibraryVideosInner.fromJson(value);
        case 'VideoLibraryVideosInnerCourse':
          return VideoLibraryVideosInnerCourse.fromJson(value);
        case 'Visit':
          return Visit.fromJson(value);
        case 'VisitCreate':
          return VisitCreate.fromJson(value);
        case 'VisitList':
          return VisitList.fromJson(value);
        case 'VisitorEventCreate':
          return VisitorEventCreate.fromJson(value);
        default:
          dynamic match;
          if (value is List && (match = _regList.firstMatch(targetType)?.group(1)) != null) {
            return value
              .map<dynamic>((dynamic v) => fromJson(v, match, growable: growable,))
              .toList(growable: growable);
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)?.group(1)) != null) {
            return value
              .map<dynamic>((dynamic v) => fromJson(v, match, growable: growable,))
              .toSet();
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)?.group(1)) != null) {
            return Map<String, dynamic>.fromIterables(
              value.keys.cast<String>(),
              value.values.map<dynamic>((dynamic v) => fromJson(v, match, growable: growable,)),
            );
          }
      }
    } on Exception catch (error, trace) {
      throw ApiException.withInner(HttpStatus.internalServerError, 'Exception during deserialization.', error, trace,);
    }
    throw ApiException(HttpStatus.internalServerError, 'Could not find a suitable class for deserialization',);
  }
}

/// Primarily intended for use in an isolate.
class DeserializationMessage {
  const DeserializationMessage({
    required this.json,
    required this.targetType,
    this.growable = false,
  });

  /// The JSON value to deserialize.
  final String json;

  /// Target type to deserialize to.
  final String targetType;

  /// Whether to make deserialized lists or maps growable.
  final bool growable;
}

/// Primarily intended for use in an isolate.
Future<dynamic> decodeAsync(DeserializationMessage message) async {
  // Remove all spaces. Necessary for regular expressions as well.
  final targetType = message.targetType.replaceAll(' ', '');

  // If the expected target type is String, nothing to do...
  return targetType == 'String'
    ? message.json
    : json.decode(message.json);
}

/// Primarily intended for use in an isolate.
Future<dynamic> deserializeAsync(DeserializationMessage message) async {
  // Remove all spaces. Necessary for regular expressions as well.
  final targetType = message.targetType.replaceAll(' ', '');

  // If the expected target type is String, nothing to do...
  return targetType == 'String'
    ? message.json
    : ApiClient.fromJson(
        json.decode(message.json),
        targetType,
        growable: message.growable,
      );
}

/// Primarily intended for use in an isolate.
Future<String> serializeAsync(Object? value) async => value == null ? '' : json.encode(value);
