import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Key screens must not reuse English template text (step 56).
void main() {
  final arbDir = Directory('lib/l10n');
  final en = jsonDecode(File('${arbDir.path}/app_en.arb').readAsStringSync())
      as Map<String, dynamic>;

  const criticalKeys = [
    'settingsTitle',
    'tabMap',
    'tabWeather',
    'moreMenuCommunity',
    'communityHubTitle',
    'voyageMonitorTitle',
    'errorNetwork',
  ];

  const locales = ['de', 'fr', 'es', 'it', 'el', 'tr', 'pt'];

  test('all locales have same keys as English template', () {
    final enKeys = en.keys.where((k) => !k.startsWith('@')).toSet();
    for (final loc in locales) {
      final data = jsonDecode(
        File('${arbDir.path}/app_$loc.arb').readAsStringSync(),
      ) as Map<String, dynamic>;
      final locKeys = data.keys.where((k) => !k.startsWith('@')).toSet();
      expect(
        locKeys,
        enKeys,
        reason: 'app_$loc.arb missing keys vs app_en.arb',
      );
    }
  });

  test('critical keys differ from English in EU locales', () {
    for (final loc in ['de', 'fr', 'es', 'it']) {
      final data = jsonDecode(
        File('${arbDir.path}/app_$loc.arb').readAsStringSync(),
      ) as Map<String, dynamic>;
      for (final key in criticalKeys) {
        expect(data[key], isNotNull, reason: '$loc missing $key');
        if (en[key] is String && (en[key] as String).isNotEmpty) {
          expect(
            data[key],
            isNot(equals(en[key])),
            reason: '$loc.$key still English',
          );
        }
      }
    }
  });

  test('EL TR PT core navigation strings are localized', () {
    final checks = {
      'el': {'settingsTitle': 'Ρυθμίσεις', 'tabMap': null},
      'tr': {'settingsTitle': 'Ayarlar'},
      'pt': {'settingsTitle': 'Definições'},
    };
    for (final entry in checks.entries) {
      final data = jsonDecode(
        File('${arbDir.path}/app_${entry.key}.arb').readAsStringSync(),
      ) as Map<String, dynamic>;
      for (final kv in entry.value.entries) {
        if (kv.value != null) {
          expect(data[kv.key], kv.value);
        } else {
          expect(data[kv.key], isNot(equals(en[kv.key])));
        }
      }
    }
  });
}
