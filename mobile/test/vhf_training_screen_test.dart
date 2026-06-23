import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/audit_repository.dart';
import 'package:captain_wrongel/data/repositories/vhf_recording_repository.dart';
import 'package:captain_wrongel/domain/training/colreg_quiz.dart';
import 'package:captain_wrongel/domain/training/vhf_scenario.dart';
import 'package:captain_wrongel/features/training/vhf_training_screen.dart';
import 'package:captain_wrongel/features/training/widgets/colreg_quiz_tab.dart';
import 'package:captain_wrongel/features/training/widgets/vhf_dialogue_bubble.dart';
import 'package:captain_wrongel/features/training/widgets/vhf_record_button.dart';
import 'package:captain_wrongel/features/training/widgets/vhf_scenario_card.dart';
import 'package:captain_wrongel/features/training/vhf_training_providers.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final demoScenarios = [
    VhfScenario(
      id: 'test_marina',
      title: const {'en': 'Test marina'},
      summary: const {'en': 'Practice berth request'},
      difficulty: VhfScenarioDifficulty.beginner,
      lines: [
        VhfDialogueLine(
          speaker: VhfDialogueSpeaker.shore,
          text: const {'en': 'Sea Breeze, proceed to pontoon A.'},
        ),
        VhfDialogueLine(
          speaker: VhfDialogueSpeaker.you,
          text: const {'en': 'Roger, Sea Breeze out.'},
        ),
      ],
    ),
  ];

  final demoQuestions = [
    ColregQuestion(
      id: 'q1',
      prompt: const {'en': 'Overtaking vessel keeps clear?'},
      choices: [
        ColregChoice(key: 'a', text: const {'en': 'True'}),
        ColregChoice(key: 'b', text: const {'en': 'False'}),
        ColregChoice(key: 'c', text: const {'en': 'Sometimes'}),
        ColregChoice(key: 'd', text: const {'en': 'Never'}),
      ],
      correctKey: 'a',
    ),
  ];

  Future<void> pumpVhfScreen(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          auditRepositoryProvider.overrideWithValue(AuditRepository(db)),
          vhfRecordingRepositoryProvider
              .overrideWithValue(VhfRecordingRepository(db)),
          sessionIdProvider.overrideWithValue('test-session'),
          vhfScenariosProvider.overrideWith(
            (ref) async => demoScenarios,
          ),
          colregQuestionsProvider.overrideWith(
            (ref) async => demoQuestions,
          ),
        ],
        child: MaterialApp(
          theme: CwTheme.material(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: VhfTrainingScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('VhfTrainingScreen shows scenario and quiz tabs', (tester) async {
    await pumpVhfScreen(tester);

    expect(find.text('Scenarios'), findsOneWidget);
    expect(find.text('COLREG quiz'), findsOneWidget);
    expect(find.byType(VhfScenarioCard), findsOneWidget);
    expect(find.text('Test marina'), findsOneWidget);
    expect(find.text('Beginner'), findsOneWidget);
  });

  testWidgets('selecting scenario shows dialogue bubbles and record FAB',
      (tester) async {
    await pumpVhfScreen(tester);

    await tester.tap(find.text('Test marina'));
    await tester.pumpAndSettle();

    expect(find.byType(VhfDialogueBubble), findsNWidgets(2));
    expect(find.text('Shore'), findsOneWidget);
    expect(find.text('You'), findsOneWidget);
    expect(find.byType(VhfRecordButton), findsOneWidget);
  });

  testWidgets('quiz tab shows question card and four options', (tester) async {
    await pumpVhfScreen(tester);

    await tester.tap(find.text('COLREG quiz'));
    await tester.pumpAndSettle();

    expect(find.byType(ColregQuizTab), findsOneWidget);
    expect(find.text('Overtaking vessel keeps clear?'), findsOneWidget);
    expect(find.text('True'), findsOneWidget);
    expect(find.text('False'), findsOneWidget);
    expect(find.text('Sometimes'), findsOneWidget);
    expect(find.text('Never'), findsOneWidget);
    expect(find.text('Question 1 of 1'), findsOneWidget);
  });

  testWidgets('quiz requires answer before advancing', (tester) async {
    await pumpVhfScreen(tester);

    await tester.tap(find.text('COLREG quiz'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Finish'));
    await tester.pump();

    expect(find.text('Select an answer first.'), findsOneWidget);
  });
}
