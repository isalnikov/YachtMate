import 'dart:io';

import 'package:captain_wrongel/data/repositories/knot_reference_repository.dart';
import 'package:captain_wrongel/domain/reference/knot_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parseKnotsCatalogJson parses titles and steps by language', () {
    const raw = r'''
{
  "version": 1,
  "knots": [
    {
      "id": "bowline",
      "category": "loops",
      "titles": { "en": "Bowline", "ru": "Булинь" },
      "steps": { "en": ["a", "b"], "ru": ["а", "б"] }
    }
  ]
}''';
    final one = parseKnotsCatalogJson(raw);
    expect(one, hasLength(1));
    final k = one.single;
    expect(k.id, 'bowline');
    expect(k.titleForLang('en'), 'Bowline');
    expect(k.titleForLang('de'), 'Bowline');
    expect(k.stepsForLang('ru'), hasLength(2));
  });

  test('bundled knots_demo.json has six entries', () {
    final file = File('assets/reference/knots_demo.json');
    final raw = file.readAsStringSync();
    final list = parseKnotsCatalogJson(raw);
    expect(list, hasLength(6));
    expect(list.any((k) => k.id == 'bowline'), isTrue);
  });

  test('KnotEntry.fromJson requires en fallback in model', () {
    final k = KnotEntry.fromJson({
      'id': 'x',
      'category': 'loops',
      'titles': {'en': 'E'},
      'steps': {
        'en': ['1'],
      },
    });
    expect(k.titleForLang('es'), 'E');
  });
}
