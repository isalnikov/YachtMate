import 'package:flutter/material.dart';

import '../../core/theme/cw_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_badge.dart';
import '../../widgets/cw_card.dart';
import '../../widgets/cw_empty_state.dart';
import '../../widgets/cw_section_header.dart';
import 'community_demo_data.dart';

/// Community reviews & events demo feed (step 49, M10).
class CommunityHubScreen extends StatelessWidget {
  const CommunityHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(CwSpacing.m),
      children: [
        Text(l10n.communityHubLead, style: theme.textTheme.bodyMedium),
        const SizedBox(height: CwSpacing.m),
        CwSectionHeader(label: l10n.communitySectionReviews),
        if (kDemoCommunityReviews.isEmpty)
          CwEmptyState(
            icon: Icons.rate_review_outlined,
            title: l10n.communityEmptyReviews,
          )
        else
          ...kDemoCommunityReviews.map((r) => _ReviewCard(review: r)),
        CwSectionHeader(label: l10n.communitySectionEvents),
        if (kDemoCommunityEvents.isEmpty)
          CwEmptyState(
            icon: Icons.event_outlined,
            title: l10n.communityEmptyEvents,
          )
        else
          ...kDemoCommunityEvents.map((e) => _EventCard(event: e)),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final CommunityReview review;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: CwSpacing.s),
      child: CwCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    review.place,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                CwBadge(label: l10n.communityBadgeDemo, variant: CwBadgeVariant.info),
              ],
            ),
            const SizedBox(height: CwSpacing.xs),
            Text(
              '${review.author} · ${'★' * review.rating}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: CwSpacing.s),
            Text(review.excerpt, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final CommunityEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: CwSpacing.s),
      child: CwCard(
        child: Row(
          children: [
            const Icon(Icons.event, size: 28),
            const SizedBox(width: CwSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title, style: theme.textTheme.titleSmall),
                  Text(event.location, style: theme.textTheme.bodySmall),
                  Text(event.dateLabel, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            CwBadge(label: l10n.communityBadgeDemo, variant: CwBadgeVariant.info),
          ],
        ),
      ),
    );
  }
}
