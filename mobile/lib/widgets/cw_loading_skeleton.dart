import 'package:flutter/material.dart';

import '../core/theme/cw_theme_extensions.dart';
import '../core/theme/cw_tokens.dart';
import 'cw_card.dart';

/// Shimmer placeholder mimicking a vertical list of cards.
class CwLoadingSkeleton extends StatelessWidget {
  const CwLoadingSkeleton({
    super.key,
    this.itemCount = 3,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(CwSpacing.m),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: CwSpacing.m),
      itemBuilder: (_, __) => const _CwSkeletonCard(),
    );
  }
}

class _CwSkeletonCard extends StatelessWidget {
  const _CwSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return const CwCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CwShimmerBox(width: double.infinity, height: 16),
          SizedBox(height: CwSpacing.s),
          _CwShimmerBox(width: 200, height: 12),
          SizedBox(height: CwSpacing.s),
          _CwShimmerBox(width: 120, height: 12),
        ],
      ),
    );
  }
}

class _CwShimmerBox extends StatefulWidget {
  const _CwShimmerBox({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  State<_CwShimmerBox> createState() => _CwShimmerBoxState();
}

class _CwShimmerBoxState extends State<_CwShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final base = colors.textMuted.withValues(alpha: 0.15);
    final highlight = colors.textMuted.withValues(alpha: 0.35);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CwRadius.sm),
            gradient: LinearGradient(
              begin: Alignment(-1 + 2 * _controller.value, 0),
              end: Alignment(1 + 2 * _controller.value, 0),
              colors: [base, highlight, base],
            ),
          ),
        );
      },
    );
  }
}
