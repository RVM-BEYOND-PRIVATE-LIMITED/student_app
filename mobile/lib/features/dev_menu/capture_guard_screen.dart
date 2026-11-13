import 'package:flutter/material.dart';

import '../../core/security/secure_screen.dart';
import '../../l10n/l10n.dart';
import '../../widgets/states.dart';

/// A marked screen in the Developer menu, so the capture guard can be proved
/// on a phone before the real marked screens exist (student_app #8, check 1;
/// the ID document preview #3, the payout account entry #6 and the video
/// player #9 come later). Screenshots and recordings of it come out black;
/// the Developer menu behind it stays capturable.
class CaptureGuardScreen extends StatelessWidget {
  const CaptureGuardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SecureScreen(
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.devCaptureGuard)),
        body: StudentEmptyState(
          icon: Icons.no_photography_outlined,
          title: l10n.devCaptureGuardTitle,
          message: l10n.devCaptureGuardBody,
        ),
      ),
    );
  }
}
