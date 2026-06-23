import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../data/local/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_card.dart';
import '../mooring_list_helpers.dart';
import '../mooring_rating_aggregator.dart';

/// Navily-style mooring list card: 16:9 photo, name, stars, depth chip.
class MooringCard extends StatelessWidget {
  const MooringCard({
    super.key,
    required this.place,
    required this.onTap,
    this.distanceNm,
    this.reviews = const [],
  });

  final MooringPlaceRow place;
  final VoidCallback onTap;
  final double? distanceNm;
  final List<MooringReviewDraftRow> reviews;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final rating = mooringAggregatedRatingStars(place: place, reviews: reviews);
    final depthText = mooringDepthChipText(place) ?? l10n.mooringDepthUnknown;
    final kindLabel = _kindLabel(l10n, place.kind);
    final photoUrl = mooringPhotoUrl(place);

    return CwCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: CwSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _MooringPhoto(
              photoUrl: photoUrl,
              kind: place.kind,
              colors: colors,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(CwSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        place.name,
                        style: CwTypography.h2(color: colors.textPrimary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (distanceNm != null) ...[
                      const SizedBox(width: CwSpacing.s),
                      Text(
                        l10n.mooringDistanceNm(distanceNm!.toStringAsFixed(1)),
                        style: CwTypography.caption(color: colors.textMuted),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: CwSpacing.xs),
                Row(
                  children: [
                    _StarRating(rating: rating, colors: colors),
                    const SizedBox(width: CwSpacing.s),
                    Text(
                      rating.toStringAsFixed(1),
                      style: CwTypography.caption(color: colors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: CwSpacing.s),
                Wrap(
                  spacing: CwSpacing.xs,
                  runSpacing: CwSpacing.xs,
                  children: [
                    _InfoChip(
                      label: kindLabel,
                      icon: _kindIcon(place.kind),
                      colors: colors,
                    ),
                    _InfoChip(
                      label: depthText,
                      icon: Icons.vertical_align_bottom_outlined,
                      colors: colors,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _kindLabel(AppLocalizations l10n, String kind) {
    return switch (kind) {
      kMooringKindMarina => l10n.mooringKindMarina,
      kMooringKindAnchorage => l10n.mooringKindAnchorage,
      kMooringKindBuoy => l10n.mooringKindBuoy,
      _ => kind,
    };
  }

  IconData _kindIcon(String kind) {
    return switch (kind) {
      kMooringKindMarina => Icons.dock_outlined,
      kMooringKindAnchorage => Icons.anchor_outlined,
      kMooringKindBuoy => Icons.place_outlined,
      _ => Icons.location_on_outlined,
    };
  }
}

class _MooringPhoto extends StatelessWidget {
  const _MooringPhoto({
    required this.photoUrl,
    required this.kind,
    required this.colors,
  });

  final String? photoUrl;
  final String kind;
  final CwColors colors;

  @override
  Widget build(BuildContext context) {
    final url = photoUrl;
    if (url != null) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) =>
            _PhotoPlaceholder(kind: kind, colors: colors),
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return _PhotoPlaceholder(kind: kind, colors: colors);
        },
      );
    }
    return _PhotoPlaceholder(kind: kind, colors: colors);
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder({required this.kind, required this.colors});

  final String kind;
  final CwColors colors;

  @override
  Widget build(BuildContext context) {
    final gradient = switch (kind) {
      kMooringKindMarina => [
          colors.deckBlue,
          const Color(0xFF1565C0).withValues(alpha: 0.85),
        ],
      kMooringKindAnchorage => [
          colors.deckBlue,
          const Color(0xFF2E7D32).withValues(alpha: 0.75),
        ],
      _ => [colors.deckBlue, colors.panelBlue],
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
      ),
      child: Center(
        child: Icon(
          kind == kMooringKindMarina
              ? Icons.sailing_outlined
              : Icons.anchor_outlined,
          size: 48,
          color: colors.textMuted.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  const _StarRating({required this.rating, required this.colors});

  final double rating;
  final CwColors colors;

  @override
  Widget build(BuildContext context) {
    final full = rating.floor().clamp(0, 5);
    final half = (rating - full) >= 0.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        IconData icon;
        if (i < full) {
          icon = Icons.star_rounded;
        } else if (i == full && half) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }
        return Icon(icon, size: 16, color: colors.accentOrange);
      }),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.icon,
    required this.colors,
  });

  final String label;
  final IconData icon;
  final CwColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.deckBlue.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(CwRadius.full),
        border: Border.all(color: colors.accentTeal.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.textMuted),
          const SizedBox(width: 4),
          Text(
            label,
            style: CwTypography.caption(color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}
