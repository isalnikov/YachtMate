import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../data/local/app_database.dart';
import '../../l10n/app_localizations.dart';
import 'mooring_detail_sheet.dart';
import 'mooring_providers.dart';

/// Вкладка «Стоянка»: каталог марин и якорных зон (Фаза 6).
class MooringScreen extends ConsumerStatefulWidget {
  const MooringScreen({super.key});

  @override
  ConsumerState<MooringScreen> createState() => _MooringScreenState();
}

class _MooringScreenState extends ConsumerState<MooringScreen> {
  final _search = TextEditingController();
  bool _syncBusy = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _syncReviews(AppLocalizations l10n) async {
    if (_syncBusy) return;
    setState(() => _syncBusy = true);
    final messenger = ScaffoldMessenger.maybeOf(context);
    try {
      final stats = await ref
          .read(mooringRepositoryProvider)
          .syncPendingReviews(ref.read(mooringReviewOutboundClientProvider));
      await ref
          .read(auditRepositoryProvider)
          .record(
            sessionId: ref.read(sessionIdProvider),
            module: 'M6',
            action: 'mooring_review_sync',
            contextJson:
                '{"submitted":${stats.submitted},"failed":${stats.failed}}',
          );
      ref.invalidate(mooringPendingReviewsProvider);
      if (!mounted) return;
      if (stats.failed == 0) {
        messenger?.showSnackBar(
          SnackBar(content: Text(l10n.mooringSyncDone(stats.submitted))),
        );
      } else {
        messenger?.showSnackBar(
          SnackBar(content: Text(l10n.mooringSyncFailed(stats.failed))),
        );
      }
    } finally {
      if (mounted) setState(() => _syncBusy = false);
    }
  }

  List<MooringPlaceRow> _filterPlaces(
    List<MooringPlaceRow> places,
    String query,
  ) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return places;
    return places
        .where((p) => p.name.toLowerCase().contains(q))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final placesAsync = ref.watch(mooringPlacesProvider);
    final pendingAsync = ref.watch(mooringPendingReviewsProvider);

    return placesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (places) {
        final pending = pendingAsync.valueOrNull ?? [];
        final filtered = _filterPlaces(places, _search.text);
        final emptyBody =
            places.isEmpty && pending.isEmpty && _search.text.trim().isEmpty;

        if (emptyBody) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                l10n.mooringEmptyCatalog,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final df = DateFormat.yMMMd().add_Hm();

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  l10n.mooringScreenTitle,
                  style: theme.textTheme.headlineSmall,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: l10n.mooringSearchHint,
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            if (pending.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.mooringPendingSectionTitle,
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                          FilledButton.tonal(
                            onPressed: _syncBusy
                                ? null
                                : () => _syncReviews(l10n),
                            child: _syncBusy
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(l10n.mooringSyncPending),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...pending.map((r) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            dense: true,
                            title: Text(
                              l10n.mooringPendingReviewLine(
                                r.placeId,
                                r.stars,
                                df.format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    r.createdAtMs,
                                  ),
                                ),
                              ),
                            ),
                            subtitle: (r.comment ?? '').isEmpty
                                ? null
                                : Text(
                                    r.comment!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            if (places.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    l10n.mooringCatalogSectionTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
            if (places.isNotEmpty && filtered.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    l10n.mooringSearchNoResults,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (filtered.isNotEmpty)
              SliverList.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, index) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  final p = filtered[i];
                  final kind = p.kind == 'marina'
                      ? l10n.mooringKindMarina
                      : l10n.mooringKindAnchorage;
                  return ListTile(
                    title: Text(p.name),
                    subtitle: Text(
                      '$kind · ${p.lat.toStringAsFixed(3)}°, ${p.lon.toStringAsFixed(3)}°',
                      style: theme.textTheme.bodySmall,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        showMooringDetailSheet(context: context, place: p),
                  );
                },
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      },
    );
  }
}
