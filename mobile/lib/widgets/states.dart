import 'package:core_network/core_network.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../theme/student_tokens.dart';
import 'data_text.dart';

/// Centres [child] in the space it has, and scrolls when that space is too
/// short (a small phone, the keyboard open, large text), so a message never
/// overflows. Inside a parent that already scrolls it just centres.
class ScrollableCenter extends StatelessWidget {
  const ScrollableCenter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedHeight) return Center(child: child);
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: child),
          ),
        );
      },
    );
  }
}

/// A grey block that shimmers while content loads. It stands still when the
/// phone asks for less motion.
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.radius = 6,
  });

  final double width;
  final double height;
  final double radius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value * 2 - 1;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1 + t, 0),
              end: Alignment(1 + t, 0),
              colors: const [
                StudentColors.surface2,
                StudentColors.surface,
                StudentColors.surface2,
              ],
              stops: const [0.25, 0.5, 0.75],
            ),
          ),
        );
      },
    );
  }
}

/// A card-shaped placeholder: a tile, two lines and two chips.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(RvmSpacing.md - 1),
      decoration: BoxDecoration(
        color: StudentColors.surface,
        borderRadius: BorderRadius.circular(RvmRadii.md),
        border: Border.all(color: StudentColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerBox(width: 46, height: 46, radius: 12),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FractionallySizedBox(
                      alignment: AlignmentDirectional.centerStart,
                      widthFactor: 0.75,
                      child: ShimmerBox(height: 14),
                    ),
                    SizedBox(height: 8),
                    FractionallySizedBox(
                      alignment: AlignmentDirectional.centerStart,
                      widthFactor: 0.5,
                      child: ShimmerBox(height: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          FractionallySizedBox(
            alignment: AlignmentDirectional.centerStart,
            widthFactor: 0.6,
            child: ShimmerBox(height: 12),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              ShimmerBox(width: 60, height: 22, radius: 7),
              SizedBox(width: 6),
              ShimmerBox(width: 60, height: 22, radius: 7),
            ],
          ),
        ],
      ),
    );
  }
}

/// The loading state of a list: [count] card placeholders, read out as
/// "Loading".
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.count = 4});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.loading,
      liveRegion: true,
      child: ExcludeSemantics(
        child: ListView.separated(
          padding: const EdgeInsets.all(RvmSpacing.md),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: count,
          separatorBuilder: (_, _) => const SizedBox(height: RvmSpacing.sm + 4),
          itemBuilder: (_, _) => const SkeletonCard(),
        ),
      ),
    );
  }
}

/// A list with nothing in it.
class StudentEmptyState extends StatelessWidget {
  const StudentEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return ScrollableCenter(
      child: Padding(
        padding: const EdgeInsets.all(RvmSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: StudentColors.surface2,
                  borderRadius: BorderRadius.circular(RvmRadii.lg),
                ),
                child: Icon(icon, color: StudentColors.fg3, size: 28),
              ),
              const SizedBox(height: RvmSpacing.md),
              Text(title, textAlign: TextAlign.center, style: text.titleMedium),
              if (message != null) ...[
                const SizedBox(height: RvmSpacing.sm),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: text.bodyMedium?.copyWith(color: StudentColors.fg2),
                ),
              ],
              if (action != null) ...[
                const SizedBox(height: RvmSpacing.lg - 4),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The words and icon for a [Failure], in the student's language.
///
/// Every failure type has its own wording, so the screen says the real cause
/// (no internet, a slow network, a server fault) instead of a generic line.
/// The app's own words are used rather than [Failure.message], which
/// core_network writes in English.
class FailureCopy {
  const FailureCopy({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  static FailureCopy of(Failure failure, AppLocalizations l10n) =>
      switch (failure) {
        NoConnectionFailure() => FailureCopy(
          icon: Icons.wifi_off_rounded,
          title: l10n.errorNoConnectionTitle,
          body: l10n.errorNoConnectionBody,
        ),
        TimeoutFailure() => FailureCopy(
          icon: Icons.hourglass_bottom_rounded,
          title: l10n.errorTimeoutTitle,
          body: l10n.errorTimeoutBody,
        ),
        UnauthorizedFailure() => FailureCopy(
          icon: Icons.lock_outline_rounded,
          title: l10n.errorSessionTitle,
          body: l10n.errorSessionBody,
        ),
        ForbiddenFailure() => FailureCopy(
          icon: Icons.block_rounded,
          title: l10n.errorForbiddenTitle,
          body: l10n.errorForbiddenBody,
        ),
        NotFoundFailure() => FailureCopy(
          icon: Icons.search_off_rounded,
          title: l10n.errorNotFoundTitle,
          body: l10n.errorNotFoundBody,
        ),
        TooManyRequestsFailure() => FailureCopy(
          icon: Icons.schedule_rounded,
          title: l10n.errorTooManyTitle,
          body: l10n.errorTooManyBody,
        ),
        ServerFailure() => FailureCopy(
          icon: Icons.cloud_off_rounded,
          title: l10n.errorServerTitle,
          body: l10n.errorServerBody,
        ),
        BadResponseFailure() => FailureCopy(
          icon: Icons.error_outline_rounded,
          title: l10n.errorRequestTitle,
          body: l10n.errorRequestBody,
        ),
        ParseFailure() => FailureCopy(
          icon: Icons.help_outline_rounded,
          title: l10n.errorParseTitle,
          body: l10n.errorParseBody,
        ),
        UnknownFailure() => FailureCopy(
          icon: Icons.error_outline_rounded,
          title: l10n.errorUnknownTitle,
          body: l10n.errorUnknownBody,
        ),
      };
}

/// A load that failed (student_app #1, item 7): the real cause, a retry,
/// and the server's request id when the reply carried one, so the student
/// can read it out to support.
class StudentErrorState extends StatelessWidget {
  const StudentErrorState({super.key, required this.failure, this.onRetry});

  final Failure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final copy = FailureCopy.of(failure, l10n);
    final requestId = failure.requestId;
    return ScrollableCenter(
      child: Padding(
        padding: const EdgeInsets.all(RvmSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: StudentColors.danger.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(RvmRadii.lg - 2),
                ),
                child: Icon(copy.icon, color: StudentColors.danger, size: 26),
              ),
              const SizedBox(height: RvmSpacing.md),
              Semantics(
                liveRegion: true,
                child: Text(
                  copy.title,
                  textAlign: TextAlign.center,
                  style: text.titleMedium,
                ),
              ),
              const SizedBox(height: RvmSpacing.sm),
              Text(
                copy.body,
                textAlign: TextAlign.center,
                style: text.bodyMedium?.copyWith(color: StudentColors.fg2),
              ),
              if (requestId != null) ...[
                const SizedBox(height: RvmSpacing.md),
                RequestIdBox(requestId: requestId),
              ],
              if (onRetry != null) ...[
                const SizedBox(height: RvmSpacing.lg - 4),
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(l10n.retry),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(160, 48),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The server's id for a failed request, with a button to copy it.
class RequestIdBox extends StatelessWidget {
  const RequestIdBox({super.key, required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(RvmSpacing.md - 2, 10, 4, 10),
      decoration: BoxDecoration(
        color: StudentColors.surface2,
        borderRadius: BorderRadius.circular(RvmRadii.sm),
        border: Border.all(color: StudentColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.requestIdLabel,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 2),
                DataText(requestId),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.copyRequestId,
            icon: const Icon(Icons.copy_rounded, size: 20),
            color: StudentColors.fg2,
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: requestId));
              if (!context.mounted) return;
              ScaffoldMessenger.maybeOf(context)
                ?..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(l10n.copied)));
            },
          ),
        ],
      ),
    );
  }
}
