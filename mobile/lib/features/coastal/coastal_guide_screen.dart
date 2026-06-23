import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/cw_tokens.dart';
import '../../domain/coastal/shore_poi.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_empty_state.dart';
import '../../widgets/cw_search_bar.dart';
import 'widgets/coastal_category_chips.dart';
import 'widgets/shore_poi_card.dart';

final shorePoisProvider = FutureProvider<List<ShorePoi>>((ref) async {
  final raw =
      await rootBundle.loadString('assets/coastal/shore_poi_demo.geojson');
  final root = jsonDecode(raw) as Map<String, dynamic>;
  return ShorePoi.parseGeoJson(root);
});

/// Прибрежные POI (F11 MVP — демо GeoJSON).
class CoastalGuideScreen extends ConsumerStatefulWidget {
  const CoastalGuideScreen({super.key});

  @override
  ConsumerState<CoastalGuideScreen> createState() => _CoastalGuideScreenState();
}

class _CoastalGuideScreenState extends ConsumerState<CoastalGuideScreen> {
  final _search = TextEditingController();
  String _query = '';
  String? _categoryFilter;
  final Set<String> _expandedIds = {};

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<ShorePoi> _filter(List<ShorePoi> all, String lang) {
    final q = _query.trim().toLowerCase();
    Iterable<ShorePoi> rows = all;

    if (_categoryFilter != null) {
      rows = rows.where((p) => p.category == _categoryFilter);
    }

    if (q.isNotEmpty) {
      rows = rows.where((p) {
        final title = p.titleFor(lang).toLowerCase();
        final body = p.bodyFor(lang).toLowerCase();
        return title.contains(q) || body.contains(q);
      });
    }

    final list = rows.toList(growable: false)
      ..sort((a, b) => a.titleFor('en').compareTo(b.titleFor('en')));
    return list;
  }

  List<String> _orderedCategories(Set<String> present) {
    const order = ['beach', 'fuel', 'marina', 'restaurant', 'attraction'];
    final keys = present.toList()
      ..sort((a, b) {
        final ia = order.indexOf(a);
        final ib = order.indexOf(b);
        if (ia == -1 && ib == -1) return a.compareTo(b);
        if (ia == -1) return 1;
        if (ib == -1) return -1;
        return ia.compareTo(ib);
      });
    return keys;
  }

  void _toggleExpanded(String id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = ref.watch(localeControllerProvider).languageCode;
    final async = ref.watch(shorePoisProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, st) => Center(child: Text(l10n.coastalLoadError)),
      data: (pois) {
        if (pois.isEmpty) {
          return Center(
            child: CwEmptyState(
              icon: Icons.beach_access_outlined,
              title: l10n.coastalEmpty,
            ),
          );
        }

        final categories = _orderedCategories(pois.map((p) => p.category).toSet());
        final filtered = _filter(pois, lang);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                CwSpacing.m,
                CwSpacing.s,
                CwSpacing.m,
                0,
              ),
              child: CwSearchBar(
                controller: _search,
                hintText: l10n.coastalSearchHint,
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            CoastalCategoryChips(
              selected: _categoryFilter,
              categories: categories,
              onSelected: (value) => setState(() => _categoryFilter = value),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(CwSpacing.xl),
                        child: Text(
                          l10n.coastalNoMatch,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        CwSpacing.m,
                        0,
                        CwSpacing.m,
                        CwSpacing.l,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) {
                        final poi = filtered[i];
                        return ShorePoiCard(
                          poi: poi,
                          lang: lang,
                          expanded: _expandedIds.contains(poi.id),
                          onTap: () => _toggleExpanded(poi.id),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
