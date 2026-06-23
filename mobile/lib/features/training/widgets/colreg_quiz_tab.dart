import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../domain/training/colreg_quiz.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_card.dart';
import '../vhf_training_providers.dart';

/// COLREG quiz tab — question card and selectable answer options.
class ColregQuizTab extends ConsumerStatefulWidget {
  const ColregQuizTab({super.key});

  @override
  ConsumerState<ColregQuizTab> createState() => _ColregQuizTabState();
}

class _ColregQuizTabState extends ConsumerState<ColregQuizTab> {
  int _qi = 0;
  String? _picked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = ref.watch(localeControllerProvider).languageCode;
    final async = ref.watch(colregQuestionsProvider);
    final colors = context.cwColors;

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, st) => Center(child: Text(l10n.vhfQuizLoadError)),
      data: (qs) {
        if (qs.isEmpty) return Center(child: Text(l10n.vhfQuizEmpty));
        final q = qs[_qi.clamp(0, qs.length - 1)];
        return Padding(
          padding: const EdgeInsets.all(CwSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.vhfQuizProgress(_qi + 1, qs.length),
                style: CwTypography.caption(color: colors.textMuted),
              ),
              const SizedBox(height: CwSpacing.s),
              CwCard(
                child: Text(
                  q.promptFor(lang),
                  style: CwTypography.h2(color: colors.textPrimary),
                ),
              ),
              const SizedBox(height: CwSpacing.m),
              Expanded(
                child: ListView(
                  children: [
                    for (final c in q.choices)
                      _QuizOptionTile(
                        choice: c,
                        lang: lang,
                        selected: _picked == c.key,
                        onTap: () => setState(() => _picked = c.key),
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: _qi > 0
                        ? () => setState(() {
                              _qi--;
                              _picked = null;
                            })
                        : null,
                    child: Text(l10n.vhfQuizPrev),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () => _submit(context, l10n, q, qs.length),
                    child: Text(
                      _qi >= qs.length - 1 ? l10n.vhfQuizDone : l10n.vhfQuizNext,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _submit(
    BuildContext context,
    AppLocalizations l10n,
    ColregQuestion q,
    int total,
  ) {
    if (_picked == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.vhfQuizPickAnswer)),
      );
      return;
    }
    if (_picked != q.correctKey) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.vhfQuizWrong)),
      );
      return;
    }
    if (_qi < total - 1) {
      setState(() {
        _qi++;
        _picked = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.vhfQuizComplete)),
      );
    }
  }
}

class _QuizOptionTile extends StatelessWidget {
  const _QuizOptionTile({
    required this.choice,
    required this.lang,
    required this.selected,
    required this.onTap,
  });

  final ColregChoice choice;
  final String lang;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: CwSpacing.s),
      child: CwCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(
          horizontal: CwSpacing.m,
          vertical: CwSpacing.s,
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selected ? colors.accentTeal : colors.textMuted,
            ),
            const SizedBox(width: CwSpacing.m),
            Expanded(
              child: Text(
                choice.labelFor(lang),
                style: CwTypography.body(
                  color: selected ? colors.accentTeal : colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
