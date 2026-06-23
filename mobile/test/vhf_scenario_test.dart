import 'package:captain_wrongel/domain/training/vhf_scenario.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('VhfScenario.parseJson loads scenarios and dialogue lines', () {
    const raw = '''
{
  "version": 1,
  "scenarios": [
    {
      "id": "demo",
      "title": { "en": "Demo" },
      "summary": { "en": "Summary" },
      "difficulty": "intermediate",
      "lines": [
        { "speaker": "shore", "text": { "en": "Hello" } },
        { "speaker": "you", "text": { "en": "Roger" } }
      ]
    }
  ]
}
''';
    final scenarios = VhfScenario.parseJson(raw);
    expect(scenarios, hasLength(1));
    expect(scenarios.first.id, 'demo');
    expect(scenarios.first.difficulty, VhfScenarioDifficulty.intermediate);
    expect(scenarios.first.lines, hasLength(2));
    expect(scenarios.first.lines.first.speaker, VhfDialogueSpeaker.shore);
    expect(scenarios.first.lines.last.textFor('en'), 'Roger');
  });
}
