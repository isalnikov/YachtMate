import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../widgets/cw_list_tile.dart';

/// Numbered knot-tying steps using [CwListTile].
class KnotStepList extends StatelessWidget {
  const KnotStepList({
    super.key,
    required this.steps,
    this.heading,
  });

  final List<String> steps;
  final String? heading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading != null) ...[
          Text(heading!, style: theme.textTheme.titleMedium),
          const SizedBox(height: CwSpacing.m),
        ],
        for (var i = 0; i < steps.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == steps.length - 1 ? 0 : CwSpacing.s,
            ),
            child: CwListTile(
              title: steps[i],
              leading: _StepNumber(index: i + 1),
              trailing: null,
            ),
          ),
      ],
    );
  }
}

class _StepNumber extends StatelessWidget {
  const _StepNumber({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final theme = Theme.of(context);

    return SizedBox(
      width: 28,
      height: 28,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.accentTeal.withValues(alpha: 0.15),
        ),
        child: Center(
          child: Text(
            '$index',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
