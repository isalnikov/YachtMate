import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/cw_tokens.dart';
import '../../domain/reference/knot_entry.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_badge.dart';
import '../../widgets/cw_card.dart';
import 'knot_detail_screen.dart';
import 'knot_difficulty.dart';
import 'knot_favorites_preferences.dart';
import 'widgets/knot_category_chips.dart';

/// Список узлов: поиск, фильтр по категориям, избранное (Фаза 9 / F08).
class KnotsHubScreen extends ConsumerStatefulWidget {
  const KnotsHubScreen({super.key});

  @override
  ConsumerState<KnotsHubScreen> createState() => _KnotsHubScreenState();
}

class _KnotsHubScreenState extends ConsumerState<KnotsHubScreen> {
  final _controller = TextEditingController();
  String _query = '';
  String? _categoryFilter;

  static const _categoryOrder = [
    'loops',
    'bends',
    'hitches',
    'stoppers',
    'emergency',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<KnotEntry> _filter(
    List<KnotEntry> all,
    String lang,
    Set<String> favorites,
  ) {
    final q = _query.trim().toLowerCase();
    Iterable<KnotEntry> rows = all;

    if (_categoryFilter == KnotCategoryChips.favoritesKey) {
      rows = rows.where((k) => favorites.contains(k.id));
    } else if (_categoryFilter != null) {
      rows = rows.where((k) => k.category == _categoryFilter);
    }

    if (q.isNotEmpty) {
      rows = rows.where((k) {
        final title = k.titleForLang(lang).toLowerCase();
        final useCase = k.useCaseForLang(lang).toLowerCase();
        return title.contains(q) || useCase.contains(q);
      });
    }

    final list = rows.toList(growable: false)
      ..sort((a, b) => a.titleForLang('en').compareTo(b.titleForLang('en')));
    return list;
  }

  List<String> _orderedCategories(Set<String> present) {
    final keys = present.toList()
      ..sort((a, b) {
        final ia = _categoryOrder.indexOf(a);
        final ib = _categoryOrder.indexOf(b);
        if (ia == -1 && ib == -1) return a.compareTo(b);
        if (ia == -1) return 1;
        if (ib == -1) return -1;
        return ia.compareTo(ib);
      });
    return keys;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = ref.watch(localeControllerProvider).languageCode;
    final favorites = ref.watch(knotFavoritesProvider);
    final async = ref.watch(knotsCatalogProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (Object error, StackTrace stackTrace) =>
          Center(child: Text(l10n.knotsLoadError)),
      data: (all) {
        if (all.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.knotsEmpty, textAlign: TextAlign.center),
            ),
          );
        }

        final categories = _orderedCategories(all.map((k) => k.category).toSet());
        final filtered = _filter(all, lang, favorites);
        if (filtered.isEmpty) {
          return Column(
            children: [
              _SearchField(
                controller: _controller,
                hint: l10n.knotsSearchHint,
                onChanged: (v) => setState(() => _query = v),
              ),
              KnotCategoryChips(
                selected: _categoryFilter,
                categories: categories,
                onSelected: (value) => setState(() => _categoryFilter = value),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(l10n.knotsNoMatch, textAlign: TextAlign.center),
                  ),
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            _SearchField(
              controller: _controller,
              hint: l10n.knotsSearchHint,
              onChanged: (v) => setState(() => _query = v),
            ),
            KnotCategoryChips(
              selected: _categoryFilter,
              categories: categories,
              onSelected: (value) => setState(() => _categoryFilter = value),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  CwSpacing.m,
                  0,
                  CwSpacing.m,
                  CwSpacing.l,
                ),
                itemCount: filtered.length,
                itemBuilder: (ctx, i) {
                  final entry = filtered[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: CwSpacing.s),
                    child: _KnotCard(
                      entry: entry,
                      lang: lang,
                      isFavorite: favorites.contains(entry.id),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => KnotDetailScreen(entry: entry),
                          ),
                        );
                      },
                    ),
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

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(CwSpacing.m, 0, CwSpacing.m, CwSpacing.s),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _KnotCard extends StatelessWidget {
  const _KnotCard({
    required this.entry,
    required this.lang,
    required this.isFavorite,
    required this.onTap,
  });

  final KnotEntry entry;
  final String lang;
  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = entry.titleForLang(lang);
    final useCase = entry.useCaseForLang(lang);

    return CwCard(
      onTap: onTap,
      padding: const EdgeInsets.all(CwSpacing.m),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.link,
            size: 28,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: CwSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    if (isFavorite)
                      const Padding(
                        padding: EdgeInsets.only(left: CwSpacing.xs),
                        child: Icon(Icons.star, size: 18, color: Colors.amber),
                      ),
                  ],
                ),
                const SizedBox(height: CwSpacing.xs),
                CwBadge(
                  label: knotDifficultyLabel(l10n, entry.difficulty),
                  variant: knotDifficultyBadgeVariant(entry.difficulty),
                ),
                if (useCase.isNotEmpty) ...[
                  const SizedBox(height: CwSpacing.s),
                  Text(
                    useCase,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
