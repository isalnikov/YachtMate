import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../domain/reference/knot_entry.dart';
import '../../l10n/app_localizations.dart';
import 'knot_category_title.dart';
import 'knot_detail_screen.dart';

/// Список узлов по категориям и поиск по названию (Фаза 9 / F08).
class KnotsHubScreen extends ConsumerStatefulWidget {
  const KnotsHubScreen({super.key});

  @override
  ConsumerState<KnotsHubScreen> createState() => _KnotsHubScreenState();
}

class _KnotsHubScreenState extends ConsumerState<KnotsHubScreen> {
  final _controller = TextEditingController();
  String _query = '';

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

  List<KnotEntry> _filter(List<KnotEntry> all, String lang) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all.where((k) {
      final t = k.titleForLang(lang).toLowerCase();
      return t.contains(q);
    }).toList();
  }

  Map<String, List<KnotEntry>> _group(List<KnotEntry> knots) {
    final m = <String, List<KnotEntry>>{};
    for (final k in knots) {
      m.putIfAbsent(k.category, () => []).add(k);
    }
    for (final list in m.values) {
      list.sort((a, b) => a.titleForLang('en').compareTo(b.titleForLang('en')));
    }
    return m;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = ref.watch(localeControllerProvider).languageCode;
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
        final filtered = _filter(all, lang);
        if (filtered.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.knotsNoMatch, textAlign: TextAlign.center),
            ),
          );
        }
        final groups = _group(filtered);
        final keys = groups.keys.toList()
          ..sort((a, b) {
            final ia = _categoryOrder.indexOf(a);
            final ib = _categoryOrder.indexOf(b);
            if (ia == -1 && ib == -1) return a.compareTo(b);
            if (ia == -1) return 1;
            if (ib == -1) return -1;
            return ia.compareTo(ib);
          });

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: l10n.knotsSearchHint,
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: keys.length,
                itemBuilder: (ctx, i) {
                  final cat = keys[i];
                  final rows = groups[cat]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Text(
                          knotCategoryTitle(l10n, cat),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      for (final k in rows)
                        ListTile(
                          title: Text(k.titleForLang(lang)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => KnotDetailScreen(entry: k),
                              ),
                            );
                          },
                        ),
                    ],
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
