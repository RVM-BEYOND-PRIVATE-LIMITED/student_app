import 'dart:async';

import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/l10n.dart';
import '../../router/app_router.dart';
import '../../theme/student_tokens.dart';
import '../../widgets/states.dart';
import '../auth/bloc/auth_bloc.dart';

/// The six-digit code (student_app #2, item 1). The server sets the wait
/// before a resend and the wait after too many tries; this screen shows the
/// wait and sends nothing early.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _code = TextEditingController();
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (p, c) => p.status != AuthStatus.signedIn &&
          c.status == AuthStatus.signedIn,
      listener: (context, state) {
        // The router sends an onboarded student Home and a new one to
        // Consent; nothing is pushed here.
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final challenge = state.challenge;
          if (challenge == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) context.go(Routes.signIn);
            });
            return const SizedBox.shrink();
          }
          final verifying = state.phase == AuthPhase.verifying;
          final wait = _secondsUntil(challenge.resendAvailableAt);
          final fallbackWait = _secondsUntil(challenge.smsFallbackAt);
          final deviceChange =
              state.failure?.code == 'DEVICE_CHANGE_NEEDS_CENTRE';
          return Scaffold(
            appBar: AppBar(title: Text(l10n.otpTitle)),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(RvmSpacing.lg),
                children: [
                  Text(
                    // Scheduler_Backend #570: in pilot the reply is the same
                    // whether or not a code was sent, so say only what is true.
                    challenge.pilot
                        ? l10n.otpSentPilot(maskPhone(state.phone ?? ''))
                        : challenge.byWhatsApp
                        ? l10n.otpSentWhatsApp(maskPhone(state.phone ?? ''))
                        : l10n.otpSentSms(maskPhone(state.phone ?? '')),
                    style: text.titleMedium,
                  ),
                  // Scheduler_Backend #203: the server sends the same code by
                  // SMS if WhatsApp has not delivered it by this time.
                  if (challenge.byWhatsApp &&
                      !challenge.pilot &&
                      challenge.smsFallbackAt != null) ...[
                    const SizedBox(height: RvmSpacing.sm),
                    Text(
                      fallbackWait > 0
                          ? l10n.otpSmsFallbackIn(_clock(fallbackWait))
                          : l10n.otpSmsFallbackSent,
                      style: text.bodyMedium,
                    ),
                  ],
                  const SizedBox(height: RvmSpacing.lg),
                  TextField(
                    controller: _code,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: text.headlineSmall?.copyWith(letterSpacing: 8),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: l10n.otpCodeLabel,
                      counterText: '',
                    ),
                    onChanged: (value) {
                      if (value.length == 6 && !verifying) {
                        context.read<AuthBloc>().add(AuthOtpSubmitted(value));
                      }
                    },
                  ),
                  if (state.failure != null)
                    Padding(
                      padding: const EdgeInsets.only(top: RvmSpacing.sm),
                      child: Text(
                        deviceChange
                            ? l10n.otpDeviceChange
                            : failureLine(state.failure!, l10n),
                        style: text.bodyMedium?.copyWith(
                          color: context.palette.danger,
                        ),
                      ),
                    ),
                  const SizedBox(height: RvmSpacing.lg),
                  FilledButton(
                    onPressed: verifying
                        ? null
                        : () {
                            if (_code.text.length == 6) {
                              context.read<AuthBloc>().add(
                                AuthOtpSubmitted(_code.text),
                              );
                            }
                          },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                    child: verifying
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.otpVerify),
                  ),
                  const SizedBox(height: RvmSpacing.md),
                  Center(
                    child: TextButton(
                      onPressed: (wait > 0 || state.resending)
                          ? null
                          : () => context.read<AuthBloc>().add(
                              const AuthOtpResent(),
                            ),
                      child: Text(
                        wait > 0
                            ? l10n.otpResendIn(_clock(wait))
                            : state.resending
                            ? l10n.otpResending
                            : l10n.otpResend,
                      ),
                    ),
                  ),
                  if (deviceChange) ...[
                    const SizedBox(height: RvmSpacing.md),
                    OutlinedButton(
                      onPressed: () => context.go(Routes.alreadyPaid),
                      child: Text(l10n.otpAskCentre),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static int _secondsUntil(DateTime? at) {
    if (at == null) return 0;
    final seconds = at.difference(DateTime.now()).inSeconds;
    return seconds > 0 ? seconds : 0;
  }

  static String _clock(int seconds) =>
      '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
}

/// `••••••1234`, the last four digits only.
String maskPhone(String phone) {
  final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.length <= 4) return digits;
  return '${'•' * (digits.length - 4)}${digits.substring(digits.length - 4)}';
}
