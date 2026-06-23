import 'dart:convert';

/// VHF radio practice scenario with branching dialogue (F12).
class VhfScenario {
  VhfScenario({
    required this.id,
    required this.title,
    required this.summary,
    required this.difficulty,
    required this.lines,
  });

  final String id;
  final Map<String, String> title;
  final Map<String, String> summary;
  final VhfScenarioDifficulty difficulty;
  final List<VhfDialogueLine> lines;

  String titleFor(String lang) => title[lang] ?? title['en'] ?? id;
  String summaryFor(String lang) => summary[lang] ?? summary['en'] ?? '';

  static List<VhfScenario> parseJson(String raw) {
    final root = jsonDecode(raw) as Map<String, dynamic>;
    final items = root['scenarios'];
    if (items is! List<dynamic>) return const [];
    return items.map((item) {
      final m = item as Map<String, dynamic>;
      final linesRaw = m['lines'];
      final lines = <VhfDialogueLine>[];
      if (linesRaw is List) {
        for (final line in linesRaw) {
          if (line is Map<String, dynamic>) {
            lines.add(
              VhfDialogueLine(
                speaker: VhfDialogueSpeaker.parse(line['speaker'] as String?),
                text: _strMap(line['text']),
              ),
            );
          }
        }
      }
      return VhfScenario(
        id: m['id'] as String,
        title: _strMap(m['title']),
        summary: _strMap(m['summary']),
        difficulty:
            VhfScenarioDifficulty.parse(m['difficulty'] as String?),
        lines: lines,
      );
    }).toList(growable: false);
  }

  static Map<String, String> _strMap(Object? raw) {
    final m = <String, String>{};
    if (raw is Map) {
      for (final e in raw.entries) {
        if (e.value is String) m[e.key.toString()] = e.value as String;
      }
    }
    return m;
  }
}

enum VhfScenarioDifficulty {
  beginner,
  intermediate,
  advanced;

  static VhfScenarioDifficulty parse(String? raw) {
    switch (raw) {
      case 'intermediate':
        return VhfScenarioDifficulty.intermediate;
      case 'advanced':
        return VhfScenarioDifficulty.advanced;
      default:
        return VhfScenarioDifficulty.beginner;
    }
  }
}

enum VhfDialogueSpeaker {
  shore,
  you;

  static VhfDialogueSpeaker parse(String? raw) {
    if (raw == 'you') return VhfDialogueSpeaker.you;
    return VhfDialogueSpeaker.shore;
  }
}

class VhfDialogueLine {
  VhfDialogueLine({required this.speaker, required this.text});

  final VhfDialogueSpeaker speaker;
  final Map<String, String> text;

  String textFor(String lang) => text[lang] ?? text['en'] ?? '';
}
