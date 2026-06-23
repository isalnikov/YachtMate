import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/cw_tokens.dart';
import '../../domain/reference/medical_entry.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_chip.dart';
import '../../widgets/cw_empty_state.dart';
import '../../widgets/cw_search_bar.dart';
import 'widgets/medical_term_card.dart';

final medicalEntriesProvider = FutureProvider<List<MedicalEntry>>((ref) async {
  final raw =
      await rootBundle.loadString('assets/reference/medical_glossary_demo.json');
  final root = jsonDecode(raw) as Map<String, dynamic>;
  return parseMedicalCatalogJson(root);
});

List<MedicalEntry> filterMedicalEntries({
  required List<MedicalEntry> entries,
  required String lang,
  required String query,
  required String? letter,
}) {
  final q = query.trim().toLowerCase();
  Iterable<MedicalEntry> rows = entries;

  if (letter != null && letter.isNotEmpty) {
    final target = letter.toUpperCase();
    rows = rows.where((e) {
      final title = e.titleFor(lang).trim();
      if (title.isEmpty) return false;
      return title[0].toUpperCase() == target;
    });
  }

  if (q.isNotEmpty) {
    rows = rows.where((e) {
      final title = e.titleFor(lang).toLowerCase();
      final body = e.bodyFor(lang).toLowerCase();
      return title.contains(q) || body.contains(q);
    });
  }

  final list = rows.toList(growable: false)
    ..sort((a, b) => a.titleFor(lang).compareTo(b.titleFor(lang)));
  return list;
}

List<String> medicalIndexLetters(List<MedicalEntry> entries, String lang) {
  final letters = <String>{};
  for (final entry in entries) {
    final title = entry.titleFor(lang).trim();
    if (title.isEmpty) continue;
    letters.add(title[0].toUpperCase());
  }
  final list = letters.toList(growable: false)..sort();
  return list;
}

/// Медицинский справочник (F13 — не замена скорой помощи).
class MedicalGlossaryScreen extends ConsumerStatefulWidget {
  const MedicalGlossaryScreen({super.key});

  @override
  ConsumerState<MedicalGlossaryScreen> createState() =>
      _MedicalGlossaryScreenState();
}

class _MedicalGlossaryScreenState extends ConsumerState<MedicalGlossaryScreen> {
  final _searchController = TextEditingController();
  String? _letter;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() => setState(() {});

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = ref.watch(localeControllerProvider).languageCode;
    final async = ref.watch(medicalEntriesProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, st) => Center(child: Text(l10n.medicalLoadError)),
      data: (entries) => _MedicalGlossaryBody(
        entries: entries,
        lang: lang,
        l10n: l10n,
        searchController: _searchController,
        query: _searchController.text,
        letter: _letter,
        onQueryChanged: (_) => setState(() {}),
        onLetterSelected: (value) => setState(() {
          _letter = _letter == value ? null : value;
        }),
      ),
    );
  }
}

class _MedicalGlossaryBody extends StatelessWidget {
  const _MedicalGlossaryBody({
    required this.entries,
    required this.lang,
    required this.l10n,
    required this.searchController,
    required this.query,
    required this.letter,
    required this.onQueryChanged,
    required this.onLetterSelected,
  });

  final List<MedicalEntry> entries;
  final String lang;
  final AppLocalizations l10n;
  final TextEditingController searchController;
  final String query;
  final String? letter;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onLetterSelected;

  @override
  Widget build(BuildContext context) {
    final letters = medicalIndexLetters(entries, lang);
    final filtered = filterMedicalEntries(
      entries: entries,
      lang: lang,
      query: query,
      letter: letter,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            CwSpacing.m,
            CwSpacing.s,
            CwSpacing.m,
            CwSpacing.s,
          ),
          child: Text(
            l10n.medicalDisclaimer,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            CwSpacing.m,
            0,
            CwSpacing.m,
            CwSpacing.s,
          ),
          child: CwSearchBar(
            key: const Key('medical_search_bar'),
            controller: searchController,
            hintText: l10n.mooringSearchHint,
            onChanged: onQueryChanged,
          ),
        ),
        if (letters.length > 1)
          _MedicalLetterIndex(
            letters: letters,
            selected: letter,
            onSelected: onLetterSelected,
          ),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: CwEmptyState(
                    icon: Icons.search_off_outlined,
                    title: l10n.mooringSearchNoResults,
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
                  itemBuilder: (context, index) {
                    final entry = filtered[index];
                    return MedicalTermCard(entry: entry, lang: lang);
                  },
                ),
        ),
      ],
    );
  }
}

class _MedicalLetterIndex extends StatelessWidget {
  const _MedicalLetterIndex({
    required this.letters,
    required this.selected,
    required this.onSelected,
  });

  final List<String> letters;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        CwSpacing.m,
        0,
        CwSpacing.m,
        CwSpacing.s,
      ),
      child: Row(
        children: [
          for (final letter in letters) ...[
            Padding(
              padding: const EdgeInsets.only(right: CwSpacing.s),
              child: CwChip(
                key: Key('medical_letter_$letter'),
                label: letter,
                selected: selected == letter,
                onSelected: (_) => onSelected(letter),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
