import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../data/local/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_empty_state.dart';
import '../../widgets/cw_search_bar.dart';
import '../../widgets/cw_segmented_control.dart';
import '../../widgets/cw_split_view.dart';
import 'mooring_detail_sheet.dart';
import 'mooring_list_helpers.dart';
import 'mooring_providers.dart';
import 'widgets/mooring_card.dart';
import 'widgets/mooring_filter_bar.dart';
import 'widgets/mooring_map_panel.dart';

/// Вкладка «Стоянка»: каталог марин и якорных зон (Фаза 6).
class MooringScreen extends ConsumerStatefulWidget {
  const MooringScreen({super.key});

  @override
  ConsumerState<MooringScreen> createState() => _MooringScreenState();
}

class _MooringScreenState extends ConsumerState<MooringScreen> {
  final _search = TextEditingController();
  bool _syncBusy = false;
  bool _showMap = false;
  final Set<String> _kindFilters = {};
  MooringSortMode _sortMode = MooringSortMode.distance;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _toggleKindFilter(String kind) {
    setState(() {
      if (_kindFilters.contains(kind)) {
        _kindFilters.remove(kind);
      } else {
        _kindFilters.add(kind);
      }
    });
  }

  List<MooringPlaceRow> _visiblePlaces(List<MooringPlaceRow> places) {
    final filtered = filterMooringPlaces(
      places: places,
      query: _search.text,
      kindFilters: _kindFilters,
    );
    return sortMooringPlaces(places: filtered, mode: _sortMode);
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

  void _openPlace(MooringPlaceRow place) {
    showMooringDetailSheet(context: context, place: place);
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
        final visible = _visiblePlaces(places);
        final emptyCatalog =
            places.isEmpty && pending.isEmpty && _search.text.trim().isEmpty;

        if (emptyCatalog) {
          return Center(
            child: CwEmptyState(
              icon: Icons.anchor_outlined,
              title: l10n.mooringEmptyCatalog,
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final split = CwSplitView.isSplitWidth(constraints.maxWidth);
            if (split && places.isNotEmpty) {
              return _buildSplitLayout(
                l10n: l10n,
                theme: theme,
                places: places,
                pending: pending,
                visible: visible,
              );
            }
            return _buildPhoneLayout(
              l10n: l10n,
              theme: theme,
              places: places,
              pending: pending,
              visible: visible,
            );
          },
        );
      },
    );
  }

  Widget _buildSplitLayout({
    required AppLocalizations l10n,
    required ThemeData theme,
    required List<MooringPlaceRow> places,
    required List<MooringReviewDraftRow> pending,
    required List<MooringPlaceRow> visible,
  }) {
    final showDistance = _sortMode == MooringSortMode.distance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            l10n.mooringScreenTitle,
            style: theme.textTheme.headlineSmall,
          ),
        ),
        Expanded(
          child: CwSplitView(
            master: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 8, 16),
              child: MooringMapPanel(
                places: visible,
                onPlaceTap: _openPlace,
              ),
            ),
            detail: _buildListPanel(
              l10n: l10n,
              theme: theme,
              places: places,
              pending: pending,
              visible: visible,
              showDistance: showDistance,
              showMapToggle: false,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneLayout({
    required AppLocalizations l10n,
    required ThemeData theme,
    required List<MooringPlaceRow> places,
    required List<MooringReviewDraftRow> pending,
    required List<MooringPlaceRow> visible,
  }) {
    final showDistance = _sortMode == MooringSortMode.distance;

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
            child: CwSegmentedControl.mapList(
              showMap: _showMap,
              mapLabel: l10n.tabMap,
              listLabel: l10n.mooringViewList,
              onChanged: (showMap) => setState(() => _showMap = showMap),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        if (_showMap && places.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 320,
                child: MooringMapPanel(
                  places: visible,
                  onPlaceTap: _openPlace,
                ),
              ),
            ),
          ),
        if (!_showMap)
          SliverToBoxAdapter(
            child: _buildListPanel(
              l10n: l10n,
              theme: theme,
              places: places,
              pending: pending,
              visible: visible,
              showDistance: showDistance,
              showMapToggle: true,
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildListPanel({
    required AppLocalizations l10n,
    required ThemeData theme,
    required List<MooringPlaceRow> places,
    required List<MooringReviewDraftRow> pending,
    required List<MooringPlaceRow> visible,
    required bool showDistance,
    required bool showMapToggle,
  }) {
    final df = DateFormat.yMMMd().add_Hm();

    final listContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, showMapToggle ? 0 : 8, 16, 0),
          child: CwSearchBar(
            controller: _search,
            hintText: l10n.mooringSearchHint,
            onChanged: (_) => setState(() {}),
          ),
        ),
        if (places.isNotEmpty) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MooringFilterBar(
              selectedKinds: _kindFilters,
              onKindToggled: _toggleKindFilter,
              sortMode: _sortMode,
              onSortChanged: (mode) => setState(() => _sortMode = mode),
            ),
          ),
        ],
        const SizedBox(height: 8),
        if (pending.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      onPressed: _syncBusy ? null : () => _syncReviews(l10n),
                      child: _syncBusy
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
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
                            DateTime.fromMillisecondsSinceEpoch(r.createdAtMs),
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
        if (showMapToggle || visible.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.mooringCatalogSectionTitle,
              style: theme.textTheme.titleMedium,
            ),
          ),
        if (places.isNotEmpty && visible.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: CwEmptyState(
              icon: Icons.search_off_outlined,
              title: l10n.mooringSearchNoResults,
              message: _kindFilters.isNotEmpty ? l10n.mooringEmptyFiltered : null,
            ),
          ),
        if (visible.isNotEmpty)
          ...visible.map((p) {
            final distance = showDistance
                ? mooringDistanceNm(
                    p,
                    refLat: kMooringDemoRefLat,
                    refLon: kMooringDemoRefLon,
                  )
                : null;
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: MooringCard(
                place: p,
                distanceNm: distance,
                onTap: () => _openPlace(p),
              ),
            );
          }),
        const SizedBox(height: 24),
      ],
    );

    if (showMapToggle) {
      return listContent;
    }

    return ListView(
      padding: const EdgeInsets.only(top: 8),
      children: listContent.children,
    );
  }
}
