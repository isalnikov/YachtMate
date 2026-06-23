import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'widgets/colreg_quiz_tab.dart';
import 'widgets/vhf_scenarios_tab.dart';

/// VHF trainer: scenario practice + COLREG quiz (F12).
class VhfTrainingScreen extends StatelessWidget {
  const VhfTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: l10n.vhfTabScenarios),
              Tab(text: l10n.vhfTabQuiz),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                VhfScenariosTab(),
                ColregQuizTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
