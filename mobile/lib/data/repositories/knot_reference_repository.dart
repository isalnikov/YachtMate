import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../domain/reference/knot_entry.dart';

/// Загрузка каталога узлов из asset (офлайн).
class KnotReferenceRepository {
  KnotReferenceRepository({
    this.assetPath = 'assets/reference/knots_demo.json',
  });

  final String assetPath;

  List<KnotEntry>? _cache;

  Future<List<KnotEntry>> loadCatalog() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString(assetPath);
    _cache = parseKnotsCatalogJson(raw);
    return _cache!;
  }

  void clearCacheForTests() => _cache = null;
}

/// Парсер для тестов без Flutter binding.
List<KnotEntry> parseKnotsCatalogJson(String raw) {
  final decoded = jsonDecode(raw);
  if (decoded is! Map<String, dynamic>) return const [];
  final list = decoded['knots'];
  if (list is! List<dynamic>) return const [];
  return list
      .map((e) => KnotEntry.fromJson(e as Map<String, dynamic>))
      .toList(growable: false);
}
