import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/training/colreg_quiz.dart';
import '../../../domain/training/vhf_scenario.dart';

final colregQuestionsProvider =
    FutureProvider<List<ColregQuestion>>((ref) async {
  final raw =
      await rootBundle.loadString('assets/training/colreg_quiz_demo.json');
  return ColregQuestion.parseJson(raw);
});

final vhfScenariosProvider = FutureProvider<List<VhfScenario>>((ref) async {
  final raw =
      await rootBundle.loadString('assets/training/vhf_scenarios_demo.json');
  return VhfScenario.parseJson(raw);
});
