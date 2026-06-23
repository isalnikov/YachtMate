import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';

class LayerThumbnailOption {
  const LayerThumbnailOption({
    required this.id,
    required this.label,
    required this.thumbnail,
  });

  final String id;
  final String label;
  final Widget thumbnail;
}

/// Four-column grid of 72×72 thumbnails with labels (Navionics Map Options).
class LayerThumbnailGrid extends StatelessWidget {
  const LayerThumbnailGrid({
    super.key,
    required this.options,
    required this.selectedId,
    required this.onSelected,
    this.crossAxisCount = 4,
    this.thumbnailSize = 72,
  });

  final List<LayerThumbnailOption> options;
  final String selectedId;
  final ValueChanged<String> onSelected;
  final int crossAxisCount;
  final double thumbnailSize;

  static const double _labelHeight = 32;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final labelStyle = Theme.of(context).textTheme.bodySmall;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: CwSpacing.s,
        crossAxisSpacing: CwSpacing.s,
        childAspectRatio: thumbnailSize / (thumbnailSize + _labelHeight),
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        final selected = option.id == selectedId;

        return Semantics(
          button: true,
          selected: selected,
          label: option.label,
          child: InkWell(
            key: Key('layer_thumbnail_${option.id}'),
            onTap: () => onSelected(option.id),
            borderRadius: BorderRadius.circular(CwRadius.sm),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: thumbnailSize,
                  height: thumbnailSize,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(CwRadius.sm),
                      border: Border.all(
                        color: selected
                            ? colors.accentTeal
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(CwRadius.sm - 2),
                      child: option.thumbnail,
                    ),
                  ),
                ),
                const SizedBox(height: CwSpacing.xs),
                SizedBox(
                  height: _labelHeight,
                  child: Text(
                    option.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: labelStyle?.copyWith(
                      color: selected ? colors.accentTeal : colors.textMuted,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
