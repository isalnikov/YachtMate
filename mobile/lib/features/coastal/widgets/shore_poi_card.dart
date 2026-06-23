import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../domain/coastal/shore_poi.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_badge.dart';
import '../../../widgets/cw_card.dart';
import '../shore_poi_category.dart';

/// Expandable coastal POI row: title, category badge, body, coordinates.
class ShorePoiCard extends StatelessWidget {
  const ShorePoiCard({
    super.key,
    required this.poi,
    required this.lang,
    required this.expanded,
    required this.onTap,
  });

  final ShorePoi poi;
  final String lang;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final title = poi.titleFor(lang);
    final body = poi.bodyFor(lang);
    final categoryLabel = shorePoiCategoryLabel(l10n, poi.category);

    return CwCard(
      key: Key('shore_poi_${poi.id}'),
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: CwSpacing.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: CwTypography.h2(color: colors.textPrimary),
                  maxLines: expanded ? null : 2,
                  overflow: expanded ? null : TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: CwSpacing.s),
              CwBadge(label: categoryLabel),
              const SizedBox(width: CwSpacing.xs),
              Icon(
                expanded ? Icons.expand_less : Icons.expand_more,
                color: colors.textMuted,
              ),
            ],
          ),
          if (body.isNotEmpty) ...[
            const SizedBox(height: CwSpacing.s),
            Text(
              body,
              style: CwTypography.body(color: colors.textMuted),
              maxLines: expanded ? null : 3,
              overflow: expanded ? null : TextOverflow.ellipsis,
            ),
          ],
          if (expanded) ...[
            const SizedBox(height: CwSpacing.s),
            Text(
              l10n.coastalCoordinates(
                poi.lat.toStringAsFixed(4),
                poi.lon.toStringAsFixed(4),
              ),
              style: CwTypography.caption(color: colors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}
