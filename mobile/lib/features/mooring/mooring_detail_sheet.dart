import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/cw_theme_extensions.dart';
import '../../core/theme/cw_tokens.dart';
import '../../core/theme/cw_typography.dart';
import '../../data/local/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_button.dart';
import '../shell/shell_tab_provider.dart';
import 'mooring_list_helpers.dart';
import 'mooring_map_navigation.dart';
import 'mooring_place_links.dart';
import 'widgets/mooring_review_section.dart';
import 'widgets/mooring_service_chips.dart';

Future<void> showMooringDetailSheet({
  required BuildContext context,
  required MooringPlaceRow place,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) => _MooringDetailBody(
        place: place,
        scrollController: scrollController,
      ),
    ),
  );
}

class _MooringDetailBody extends ConsumerWidget {
  const _MooringDetailBody({
    required this.place,
    required this.scrollController,
  });

  final MooringPlaceRow place;
  final ScrollController scrollController;

  void _navigateToMap(WidgetRef ref, BuildContext context) {
    ref.read(mapCameraTargetProvider.notifier).focusOn(place.lat, place.lon);
    ref.read(shellTabIndexProvider.notifier).selectTab(0);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final p = place;
    final theme = Theme.of(context);
    final colors = context.cwColors;
    final rating = mooringDemoRatingStars(p.id);

    final kindLabel = p.kind == kMooringKindMarina
        ? l10n.mooringKindMarina
        : p.kind == kMooringKindAnchorage
        ? l10n.mooringKindAnchorage
        : p.kind;

    return ListView(
      controller: scrollController,
      padding: EdgeInsets.only(
        left: CwSpacing.m,
        right: CwSpacing.m,
        bottom: MediaQuery.of(context).viewInsets.bottom + CwSpacing.l,
      ),
      children: [
        _MooringHeroPhoto(kind: p.kind, colors: colors),
        const SizedBox(height: CwSpacing.m),
        Text(p.name, style: CwTypography.h2(color: colors.textPrimary)),
        const SizedBox(height: CwSpacing.xs),
        Text(
          '$kindLabel · ${p.lat.toStringAsFixed(4)}°, ${p.lon.toStringAsFixed(4)}°',
          style: CwTypography.caption(color: colors.textMuted),
        ),
        const SizedBox(height: CwSpacing.s),
        Row(
          children: [
            Icon(Icons.star_rounded, size: 18, color: colors.accentOrange),
            const SizedBox(width: 4),
            Text(
              rating.toStringAsFixed(1),
              style: CwTypography.caption(color: colors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: CwSpacing.m),
        Text(l10n.mooringServices, style: theme.textTheme.titleSmall),
        const SizedBox(height: CwSpacing.xs),
        MooringServiceChips(place: p),
        if ((p.vhf ?? '').isNotEmpty) ...[
          const SizedBox(height: CwSpacing.m),
          Text('${l10n.mooringVhf}: ${p.vhf}'),
        ],
        if ((p.phone ?? '').isNotEmpty)
          Text('${l10n.mooringPhone}: ${p.phone}'),
        if ((p.email ?? '').isNotEmpty)
          Text('${l10n.mooringEmail}: ${p.email}'),
        if ((p.notes ?? '').isNotEmpty) ...[
          const SizedBox(height: CwSpacing.s),
          Text(p.notes!, style: theme.textTheme.bodyMedium),
        ],
        const SizedBox(height: CwSpacing.s),
        Wrap(
          spacing: CwSpacing.xs,
          runSpacing: CwSpacing.xs,
          children: [
            if ((p.phone ?? '').isNotEmpty)
              TextButton.icon(
                icon: const Icon(Icons.call_outlined),
                label: Text(l10n.mooringCall),
                onPressed: () => dialPhoneNumber(p.phone!),
              ),
            if ((p.email ?? '').isNotEmpty)
              TextButton.icon(
                icon: const Icon(Icons.mail_outline),
                label: Text(l10n.mooringEmail),
                onPressed: () => openEmail(p.email!),
              ),
            if (parseHttpish(p.websiteUrl) != null)
              TextButton.icon(
                icon: const Icon(Icons.language),
                label: Text(l10n.mooringWebsite),
                onPressed: () =>
                    openExternalUri(parseHttpish(p.websiteUrl)!),
              ),
            if (parseHttpish(p.bookingUrl) != null)
              TextButton.icon(
                icon: const Icon(Icons.event_available_outlined),
                label: Text(l10n.mooringBook),
                onPressed: () =>
                    openExternalUri(parseHttpish(p.bookingUrl)!),
              ),
          ],
        ),
        const SizedBox(height: CwSpacing.m),
        CwButton(
          key: const Key('mooring_navigate_map'),
          label: l10n.mapNavigateHere,
          icon: Icons.navigation_outlined,
          onPressed: () => _navigateToMap(ref, context),
        ),
        const SizedBox(height: CwSpacing.l),
        MooringReviewSection(
          placeId: p.id,
          onQueued: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _MooringHeroPhoto extends StatelessWidget {
  const _MooringHeroPhoto({required this.kind, required this.colors});

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

    return ClipRRect(
      borderRadius: BorderRadius.circular(CwRadius.md),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: DecoratedBox(
          key: const Key('mooring_detail_hero'),
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
              size: 56,
              color: colors.textMuted.withValues(alpha: 0.45),
            ),
          ),
        ),
      ),
    );
  }
}
