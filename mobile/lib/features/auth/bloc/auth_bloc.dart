import 'dart:async';

import 'package:core_network/core_network.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/models.dart';
import '../../../core/api/student_api.dart';
import '../../../core/push/push_service.dart';
import '../../../core/session/student_session.dart';

sealed class AuthEvent {
  const AuthEvent();
}

/// The app opened: restore the session and read the account.
final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

/// "Send code" on the phone screen.
final class AuthOtpRequested extends AuthEvent {
  const AuthOtpRequested(this.phone);

  final String phone;
}

/// "Send again" on the code screen.
final class AuthOtpResent extends AuthEvent {
  const AuthOtpResent();
}

/// The six-digit code was submitted.
final class AuthOtpSubmitted extends AuthEvent {
  const AuthOtpSubmitted(this.code);

  final String code;
}

/// Another screen changed the account (a consent, a language, a link).
final class AuthAccountUpdated extends AuthEvent {
  const AuthAccountUpdated(this.account);

  final StudentAccount account;
}

/// "Sign out" in Profile.
final class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// "Try again" after the account could not be read.
final class AuthRetried extends AuthEvent {
  const AuthRetried();
}

enum AuthStatus {
  /// The session and the account are being restored.
  checking,

  /// No session: sign in.
  signedOut,

  /// A session with an account.
  signedIn,

  /// A session exists but the account could not be read.
  failure,
}

enum AuthPhase {
  idle,
  sendingCode,
  codeSent,
  verifying,
}

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.checking,
    this.phase = AuthPhase.idle,
    this.account,
    this.challenge,
    this.phone,
    this.failure,
    this.resending = false,
  });

  final AuthStatus status;
  final AuthPhase phase;
  final StudentAccount? account;

  /// The challenge a code was sent for, once the request succeeds.
  final OtpChallenge? challenge;

  /// The number the code was sent to, as typed.
  final String? phone;
  final Failure? failure;
  final bool resending;

  bool get signedIn => status == AuthStatus.signedIn && account != null;

  AuthState copyWith({
    AuthStatus? status,
    AuthPhase? phase,
    StudentAccount? account,
    OtpChallenge? challenge,
    String? phone,
    Failure? failure,
    bool clearFailure = false,
    bool? resending,
  }) => AuthState(
    status: status ?? this.status,
    phase: phase ?? this.phase,
    account: account ?? this.account,
    challenge: challenge ?? this.challenge,
    phone: phone ?? this.phone,
    failure: clearFailure ? null : (failure ?? this.failure),
    resending: resending ?? this.resending,
  );

  @override
  List<Object?> get props => [
    status,
    phase,
    account,
    challenge,
    phone,
    failure,
    resending,
  ];
}

/// Sign-in, onboarding and the signed-in account (student_app #2).
///
/// The server decides everything: the code, the wait before a resend, the
/// account, whether onboarding is done and which stage the student is in.
/// This bloc only carries the replies and the session.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required StudentApi api,
    required StudentSession session,
    required String? appVersion,
  }) : _api = api,
       _session = session,
       _appVersion = appVersion,
       super(const AuthState()) {
    on<AuthStarted>(_onStarted);
    on<AuthOtpRequested>(_onOtpRequested);
    on<AuthOtpResent>(_onOtpResent);
    on<AuthOtpSubmitted>(_onOtpSubmitted);
    on<AuthAccountUpdated>((event, emit) => emit(
      state.copyWith(
        status: AuthStatus.signedIn,
        account: event.account,
        clearFailure: true,
      ),
    ));
    on<AuthSignOutRequested>(_onSignOut);
    on<AuthRetried>(_onStarted);
  }

  final StudentApi _api;
  final StudentSession _session;
  final String? _appVersion;

  Future<void> _onStarted(AuthEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.checking, clearFailure: true));
    try {
      await _session.load();
      if (!await _session.hasSession()) {
        emit(
          state.copyWith(status: AuthStatus.signedOut, phase: AuthPhase.idle),
        );
        return;
      }
      final account = await _api.me();
      emit(
        state.copyWith(
          status: AuthStatus.signedIn,
          account: account,
          clearFailure: true,
        ),
      );
      unawaited(_registerPush());
    } on UnauthorizedFailure {
      await _session.endSession();
      emit(
        state.copyWith(
          status: AuthStatus.signedOut,
          phase: AuthPhase.idle,
          clearFailure: true,
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(status: AuthStatus.failure, failure: failure));
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          failure: const UnknownFailure(),
        ),
      );
    }
  }

  Future<void> _onOtpRequested(
    AuthOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.phase == AuthPhase.sendingCode) return;
    emit(
      state.copyWith(
        phase: AuthPhase.sendingCode,
        phone: event.phone,
        clearFailure: true,
      ),
    );
    try {
      final challenge = await _api.requestOtp(event.phone);
      emit(
        state.copyWith(
          phase: AuthPhase.codeSent,
          challenge: challenge,
          clearFailure: true,
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(phase: AuthPhase.idle, failure: failure));
    }
  }

  Future<void> _onOtpResent(AuthEvent event, Emitter<AuthState> emit) async {
    final challenge = state.challenge;
    if (challenge == null || state.resending) return;
    emit(state.copyWith(resending: true, clearFailure: true));
    try {
      final resent = await _api.resendOtp(challenge.challengeId);
      emit(
        state.copyWith(
          challenge: resent,
          resending: false,
          clearFailure: true,
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(resending: false, failure: failure));
    }
  }

  Future<void> _onOtpSubmitted(
    AuthOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final challenge = state.challenge;
    if (challenge == null || state.phase == AuthPhase.verifying) return;
    emit(state.copyWith(phase: AuthPhase.verifying, clearFailure: true));
    try {
      final installId = await _session.installId();
      final signedIn = await _api.verifyOtp(
        challengeId: challenge.challengeId,
        code: event.code,
        installId: installId,
        appVersion: _appVersion,
      );
      await _session.saveTokens(
        accessToken: signedIn.tokens.accessToken,
        refreshToken: signedIn.tokens.refreshToken,
      );
      emit(
        state.copyWith(
          status: AuthStatus.signedIn,
          phase: AuthPhase.idle,
          account: signedIn.account,
          clearFailure: true,
        ),
      );
      unawaited(_registerPush());
    } on Failure catch (failure) {
      emit(state.copyWith(phase: AuthPhase.codeSent, failure: failure));
    }
  }

  /// Best effort: a phone without Firebase, or a token the server does not
  /// take, must never keep a student out of the app.
  Future<void> _registerPush() async {
    try {
      await PushService.instance.init();
      final token = PushService.instance.token;
      if (token == null || token.isEmpty) return;
      await _api.setPushToken(
        installId: await _session.installId(),
        token: token,
      );
    } catch (_) {
      // Push is optional; the next sign-in tries again.
    }
  }

  Future<void> _onSignOut(AuthEvent event, Emitter<AuthState> emit) async {
    try {
      await _api.logout();
    } catch (_) {
      // The local session ends even when the server cannot be told.
    }
    await _session.endSession();
    emit(
      AuthState(status: AuthStatus.signedOut, phase: AuthPhase.idle),
    );
  }
}
