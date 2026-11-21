import 'package:core_network/core_network.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/api/models.dart';
import '../../core/api/student_api.dart';
import '../../core/format/display_format.dart';
import '../../injection.dart';
import '../../l10n/l10n.dart';
import '../../theme/student_tokens.dart';
import '../../widgets/states.dart';
import '../auth/bloc/auth_bloc.dart';

/// "I have already paid" (student_app #2, item 5). The server matches the
/// sign-in phone to a Scheduler admission; nothing is worked out on the phone.
/// No match, or more than one, sends the student to "Ask your centre", where
/// he picks his branch and asks it to link the admission.
class AlreadyPaidScreen extends StatefulWidget {
  const AlreadyPaidScreen({super.key});

  @override
  State<AlreadyPaidScreen> createState() => _AlreadyPaidScreenState();
}

class _AlreadyPaidScreenState extends State<AlreadyPaidScreen> {
  final _name = TextEditingController();
  final _admissionNumber = TextEditingController();
  bool _loading = true;
  bool _requesting = false;
  Admission? _admission;
  List<Branch> _branches = const [];
  int? _branchId;
  Failure? _failure;
  String? _requestMessage;

  @override
  void initState() {
    super.initState();
    _check();
  }

  @override
  void dispose() {
    _name.dispose();
    _admissionNumber.dispose();
    super.dispose();
  }

  /// The linked admission, or null when this account is not linked yet.
  /// Any other refusal is rethrown, so the screen shows its real failure.
  Future<Admission?> _admissionIfLinked() async {
    try {
      return await getIt<StudentApi>().admission();
    } on Failure catch (failure) {
      if (failure.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<void> _showAdmission(Admission admission, StudentAccount? account) async {
    if (!mounted) return;
    if (account != null) {
      context.read<AuthBloc>().add(AuthAccountUpdated(account));
    }
    setState(() {
      _admission = admission;
      _failure = null;
      _loading = false;
    });
  }

  Future<void> _check() async {
    setState(() {
      _loading = true;
      _failure = null;
      _requestMessage = null;
    });
    final api = getIt<StudentApi>();
    try {
      // An account already linked at sign-in (or by a previous tap, or by the
      // centre) must show its admission at once. Before this, link/auto
      // answered 409 ALREADY_LINKED and the screen showed "Request not
      // completed", even though the admission was there to read.
      final already = await _admissionIfLinked();
      if (already != null) {
        await _showAdmission(already, null);
        return;
      }

      final result = await api.linkAutomatically();
      if (result.state == LinkResultState.linked) {
        final admission = await api.admission();
        await _showAdmission(admission, result.account);
        return;
      }
      final branches = await api.branches();
      if (!mounted) return;
      setState(() {
        _branches = branches;
        _branchId ??= branches.isEmpty ? null : branches.first.id;
        _loading = false;
      });
    } on Failure catch (failure) {
      // A race or an older server can still answer 409 ALREADY_LINKED; the
      // admission is the right screen in that case, never an error.
      if (failure.statusCode == 409 && failure.code == 'ALREADY_LINKED') {
        try {
          final admission = await api.admission();
          await _showAdmission(admission, null);
          return;
        } on Failure catch (again) {
          if (!mounted) return;
          setState(() {
            _failure = again;
            _loading = false;
          });
          return;
        }
      }
      if (!mounted) return;
      setState(() {
        _failure = failure;
        _loading = false;
      });
    }
  }

  Future<void> _requestLink() async {
    final branchId = _branchId;
    final name = _name.text.trim();
    if (branchId == null || name.length < 2 || _requesting) return;
    setState(() {
      _requesting = true;
      _failure = null;
    });
    try {
      final result = await getIt<StudentApi>().requestLink(
        branchId: branchId,
        name: name,
        admissionNumber: _admissionNumber.text.trim(),
      );
      if (!mounted) return;
      context.read<AuthBloc>().add(AuthAccountUpdated(result.account));
      setState(() {
        _requesting = false;
        _requestMessage = context.l10n.alreadyPaidRequested;
      });
    } on Failure catch (failure) {
      if (!mounted) return;
      setState(() {
        _requesting = false;
        _failure = failure;
      });
    }
  }

  Future<void> _call(String? number) async {
    if (number == null || number.trim().isEmpty) return;
    final uri = Uri(scheme: 'tel', path: number.replaceAll(RegExp(r'[^0-9+]'), ''));
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.alreadyPaidTitle)),
      body: _loading
          ? const SkeletonList(count: 3)
          : _failure != null
          ? StudentErrorState(failure: _failure!, onRetry: _check)
          : _admission != null
          ? _AdmissionView(admission: _admission!)
          : _AskCentre(
              branches: _branches,
              branchId: _branchId,
              name: _name,
              admissionNumber: _admissionNumber,
              requesting: _requesting,
              requestMessage: _requestMessage,
              onBranch: (id) => setState(() => _branchId = id),
              onRequest: _requestLink,
              onCall: _call,
              onCheckAgain: _check,
            ),
    );
  }
}

class _AdmissionView extends StatelessWidget {
  const _AdmissionView({required this.admission});

  final Admission admission;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(RvmSpacing.lg),
      children: [
        Text(l10n.alreadyPaidFound, style: text.headlineSmall),
        const SizedBox(height: RvmSpacing.sm),
        Text(
          admission.admissionNumber,
          style: text.titleMedium?.copyWith(color: context.palette.fg2),
        ),
        const SizedBox(height: RvmSpacing.lg),
        _Money(
          label: l10n.alreadyPaidTotal,
          value: MoneyText.fromPaise(admission.totalFeesPaise),
        ),
        if (admission.totalPaidPaise != null)
          _Money(
            label: l10n.alreadyPaidPaid,
            value: MoneyText.fromPaise(admission.totalPaidPaise!),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              l10n.alreadyPaidLegacy,
              style: text.bodyMedium?.copyWith(color: context.palette.fg2),
            ),
          ),
        _Money(
          label: l10n.alreadyPaidDue,
          value: MoneyText.fromPaise(admission.remainingDuePaise),
        ),
        const SizedBox(height: RvmSpacing.lg),
        Text(l10n.alreadyPaidPlan, style: text.titleSmall),
        const SizedBox(height: RvmSpacing.sm),
        for (final row in admission.plan)
          Container(
            margin: const EdgeInsets.only(bottom: RvmSpacing.sm),
            padding: const EdgeInsets.all(RvmSpacing.sm + 2),
            decoration: BoxDecoration(
              color: context.palette.surface,
              borderRadius: BorderRadius.circular(RvmRadii.sm),
              border: Border.all(color: context.palette.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    row.dueDate == null
                        ? ''
                        : MaterialLocalizations.of(
                            context,
                          ).formatMediumDate(row.dueDate!),
                    style: text.bodyMedium,
                  ),
                ),
                Text(
                  MoneyText.fromPaise(row.amountPaise),
                  style: text.bodyMedium,
                ),
                const SizedBox(width: RvmSpacing.sm),
                Text(
                  row.status,
                  style: text.labelMedium?.copyWith(
                    color: context.palette.fg2,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Money extends StatelessWidget {
  const _Money({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: text.bodyMedium?.copyWith(color: context.palette.fg2),
            ),
          ),
          Text(value, style: text.titleMedium),
        ],
      ),
    );
  }
}

class _AskCentre extends StatelessWidget {
  const _AskCentre({
    required this.branches,
    required this.branchId,
    required this.name,
    required this.admissionNumber,
    required this.requesting,
    required this.requestMessage,
    required this.onBranch,
    required this.onRequest,
    required this.onCall,
    required this.onCheckAgain,
  });

  final List<Branch> branches;
  final int? branchId;
  final TextEditingController name;
  final TextEditingController admissionNumber;
  final bool requesting;
  final String? requestMessage;
  final ValueChanged<int> onBranch;
  final VoidCallback onRequest;
  final Future<void> Function(String?) onCall;
  final VoidCallback onCheckAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final selected = branches
        .where((branch) => branch.id == branchId)
        .cast<Branch?>()
        .firstWhere((branch) => true, orElse: () => null);
    return ListView(
      padding: const EdgeInsets.all(RvmSpacing.lg),
      children: [
        Text(l10n.alreadyPaidNotFound, style: text.headlineSmall),
        const SizedBox(height: RvmSpacing.sm),
        Text(
          l10n.alreadyPaidNotFoundBody,
          style: text.bodyMedium?.copyWith(color: context.palette.fg2),
        ),
        const SizedBox(height: RvmSpacing.lg),
        if (requestMessage != null) ...[
          Container(
            padding: const EdgeInsets.all(RvmSpacing.md),
            decoration: BoxDecoration(
              color: context.palette.surface2,
              borderRadius: BorderRadius.circular(RvmRadii.md),
            ),
            child: Text(requestMessage!, style: text.bodyMedium),
          ),
          const SizedBox(height: RvmSpacing.lg),
        ],
        Text(l10n.alreadyPaidBranch, style: text.titleSmall),
        const SizedBox(height: RvmSpacing.sm),
        DropdownButtonFormField<int>(
          initialValue: branchId,
          items: [
            for (final branch in branches)
              DropdownMenuItem(value: branch.id, child: Text(branch.name)),
          ],
          onChanged: (value) {
            if (value != null) onBranch(value);
          },
        ),
        const SizedBox(height: RvmSpacing.md),
        TextField(
          controller: name,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l10n.alreadyPaidName),
        ),
        const SizedBox(height: RvmSpacing.md),
        TextField(
          controller: admissionNumber,
          decoration: InputDecoration(
            labelText: l10n.alreadyPaidAdmissionNumber,
          ),
        ),
        if (selected?.callNumber != null) ...[
          const SizedBox(height: RvmSpacing.md),
          OutlinedButton.icon(
            onPressed: () => onCall(selected?.callNumber),
            icon: const Icon(Icons.call_rounded),
            label: Text(l10n.alreadyPaidCall),
          ),
        ],
        const SizedBox(height: RvmSpacing.lg),
        FilledButton(
          onPressed: requesting ? null : onRequest,
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          child: requesting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.alreadyPaidRequest),
        ),
        const SizedBox(height: RvmSpacing.sm),
        TextButton(
          onPressed: onCheckAgain,
          child: Text(l10n.jobsCheckAgain),
        ),
      ],
    );
  }
}
