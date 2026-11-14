import 'package:core_bloc/core_bloc.dart';
import 'package:core_network/core_network.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import 'states.dart';

/// Draws one of core_bloc's [LoadState]s with the shared states: the
/// skeleton while the first load runs, the error (cause, retry, request id)
/// when it fails, the empty state when there is nothing, and [builder]'s
/// content otherwise.
///
/// When a refresh fails but data is already on screen, the data stays: a
/// failed pull-to-refresh never wipes a good list into a full-screen error.
class LoadStateView<T> extends StatelessWidget {
  const LoadStateView({
    super.key,
    required this.state,
    required this.builder,
    required this.onRetry,
    this.skeleton,
    this.empty,
  });

  final LoadState<T> state;
  final Widget Function(BuildContext context, T data) builder;
  final VoidCallback onRetry;

  /// The loading placeholder; a [SkeletonList] when left out.
  final Widget? skeleton;

  /// The empty state; a generic one when left out.
  final WidgetBuilder? empty;

  @override
  Widget build(BuildContext context) {
    final data = state.data;
    switch (state.status) {
      case LoadStatus.empty:
        return empty?.call(context) ??
            StudentEmptyState(
              icon: Icons.inbox_outlined,
              title: context.l10n.emptyTitle,
              message: context.l10n.emptyBody,
            );
      case LoadStatus.failure when data == null:
        return StudentErrorState(
          failure: state.failure ?? const UnknownFailure(),
          onRetry: onRetry,
        );
      case LoadStatus.initial:
      case LoadStatus.loading:
      case LoadStatus.success:
      case LoadStatus.failure:
        if (data == null) return skeleton ?? const SkeletonList();
        return builder(context, data);
    }
  }
}
