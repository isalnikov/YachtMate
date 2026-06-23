import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';

/// Wind-speed color for [kn] on the 0–[maxKn] scale using [CwColors.windScale].
Color windColorForKn(double kn, List<Color> scale, {double maxKn = 45}) {
  if (kn.isNaN) return scale.first;
  final t = (kn / maxKn).clamp(0.0, 1.0);
  final segments = scale.length - 1;
  final pos = t * segments;
  final i = pos.floor().clamp(0, segments - 1);
  return Color.lerp(scale[i], scale[i + 1], pos - i)!;
}

/// 0–45 kn gradient legend (Windy-style) using [CwColors.windScale].
class WindLegendBar extends StatelessWidget {
  const WindLegendBar({super.key, this.maxKn = 45});

  final double maxKn;

  static const _ticks = [0, 10, 20, 30, 40, 45];

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      color: colors.textMuted,
      fontSize: 10,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(CwRadius.sm),
          child: SizedBox(
            height: 10,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors.windScale,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: CwSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final tick in _ticks)
              Text('$tick', style: labelStyle),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text('kn', style: labelStyle),
        ),
      ],
    );
  }
}
