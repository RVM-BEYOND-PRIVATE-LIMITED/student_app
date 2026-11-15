import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/l10n.dart';
import '../../theme/student_tokens.dart';
import '../auth/bloc/auth_bloc.dart';
import '../jobs/jobs_tab.dart';
import '../profile/profile_tab.dart';
import 'home_tab.dart';

/// The signed-in shell (student_app #2, item 6): Home, Jobs and Profile.
/// The server's stage decides what each tab says; the Alumni label comes
/// from `Me.is_alumni`.
///
/// Only the selected tab is built, so the Jobs gate runs again every time
/// the tab opens, as the contract asks.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final alumni = context.select(
      (AuthBloc bloc) => bloc.state.account?.isAlumni ?? false,
    );
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(l10n.appTitle),
            if (alumni) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: context.palette.surface2,
                  borderRadius: BorderRadius.circular(RvmRadii.sm),
                ),
                child: Text(
                  l10n.alumniLabel,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          ],
        ),
      ),
      body: switch (_index) {
        1 => const JobsTab(),
        2 => const ProfileTab(),
        _ => const HomeTab(),
      },
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: l10n.tabHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.work_outline_rounded),
            selectedIcon: const Icon(Icons.work_rounded),
            label: l10n.tabJobs,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: l10n.tabProfile,
          ),
        ],
      ),
    );
  }
}
