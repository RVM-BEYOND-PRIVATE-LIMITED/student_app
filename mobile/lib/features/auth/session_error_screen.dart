import 'package:core_network/core_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/l10n.dart';
import '../../widgets/states.dart';
import 'bloc/auth_bloc.dart';

/// The session is still there but the account could not be read (student_app
/// #2, a weak network on launch). Nothing is signed out: the student may try
/// again, and the session stays on the phone.
class SessionErrorScreen extends StatelessWidget {
  const SessionErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final failure = context.select(
      (AuthBloc bloc) => bloc.state.failure ?? const UnknownFailure(),
    );
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.appTitle)),
      body: StudentErrorState(
        failure: failure,
        onRetry: () => context.read<AuthBloc>().add(const AuthRetried()),
      ),
    );
  }
}
