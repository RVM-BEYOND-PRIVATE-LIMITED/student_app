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

/// Phone sign-in (student_app #2, item 1): the student's own number, one
/// code, no password, no email and no parent step.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (p, c) =>
          p.phase != AuthPhase.codeSent && c.phase == AuthPhase.codeSent,
      listener: (context, state) {
        if (state.challenge != null) context.go(Routes.otp);
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final sending = state.phase == AuthPhase.sendingCode;
          return Scaffold(
            appBar: AppBar(title: Text(l10n.signInTitle)),
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(RvmSpacing.lg),
                  children: [
                    Text(l10n.signInPhoneTitle, style: text.headlineSmall),
                    const SizedBox(height: RvmSpacing.sm),
                    Text(
                      l10n.signInOwnNumber,
                      style: text.bodyMedium?.copyWith(
                        color: context.palette.fg2,
                      ),
                    ),
                    const SizedBox(height: RvmSpacing.lg),
                    TextFormField(
                      controller: _phone,
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      maxLength: 16,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
                      ],
                      decoration: InputDecoration(
                        labelText: l10n.signInPhoneLabel,
                        prefixText: '+91 ',
                        counterText: '',
                      ),
                      validator: (value) => normalizePhone(value ?? '') == null
                          ? l10n.signInPhoneInvalid
                          : null,
                      onFieldSubmitted: (_) => _submit(context),
                    ),
                    if (state.failure != null) ...[
                      const SizedBox(height: RvmSpacing.md),
                      Text(
                        failureLine(state.failure!, l10n),
                        style: text.bodyMedium?.copyWith(
                          color: context.palette.danger,
                        ),
                      ),
                    ],
                    const SizedBox(height: RvmSpacing.xl),
                    FilledButton(
                      onPressed: sending ? null : () => _submit(context),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      child: sending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.signInSendCode),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final phone = normalizePhone(_phone.text);
    if (phone == null) return;
    context.read<AuthBloc>().add(AuthOtpRequested(phone));
  }
}

/// The contract's phone rule: spaces, dashes and a leading +91 or 0 are
/// removed; what is left must be 10 digits starting with 6 to 9.
String? normalizePhone(String raw) {
  var value = raw.replaceAll(RegExp(r'[\s-]'), '');
  if (value.startsWith('+91')) value = value.substring(3);
  if (value.startsWith('0') && value.length == 11) value = value.substring(1);
  if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(value)) return null;
  return value;
}
