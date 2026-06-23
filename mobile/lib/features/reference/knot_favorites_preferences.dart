import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers.dart';

const kKnotFavoritesKey = 'knot_favorite_ids';

/// Locally persisted favorite knot ids (offline, per device).
class KnotFavoritesNotifier extends StateNotifier<Set<String>> {
  KnotFavoritesNotifier(this._prefs) : super(_load(_prefs));

  final SharedPreferences _prefs;

  static Set<String> _load(SharedPreferences prefs) {
    final raw = prefs.getStringList(kKnotFavoritesKey);
    if (raw == null) return {};
    return raw.toSet();
  }

  bool isFavorite(String knotId) => state.contains(knotId);

  Future<void> toggle(String knotId) async {
    final next = Set<String>.from(state);
    if (next.contains(knotId)) {
      next.remove(knotId);
    } else {
      next.add(knotId);
    }
    await _prefs.setStringList(kKnotFavoritesKey, next.toList(growable: false));
    state = next;
  }
}

final knotFavoritesProvider =
    StateNotifierProvider<KnotFavoritesNotifier, Set<String>>((ref) {
  return KnotFavoritesNotifier(ref.read(sharedPreferencesProvider));
});
