import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/audit_repository.dart';

/// Управляет локалью приложения: только **en** и **ru**, сохранение в SharedPreferences.
///
/// При первом запуске (ключа нет) выбирается язык системы, если он `ru`, иначе `en`.
class LocaleController extends StateNotifier<Locale> {
  LocaleController(
    this._prefs,
    this._audit,
    this._sessionId,
  ) : super(_initialLocale(_prefs));

  final SharedPreferences _prefs;
  final AuditRepository _audit;
  final String _sessionId;

  static const localePreferenceKey = 'localeCode';

  static Locale _initialLocale(SharedPreferences prefs) {
    final saved = prefs.getString(localePreferenceKey);
    if (saved == 'ru') return const Locale('ru');
    if (saved == 'en') return const Locale('en');
    final code = PlatformDispatcher.instance.locale.languageCode;
    return code == 'ru' ? const Locale('ru') : const Locale('en');
  }

  /// Фиксирует только поддерживаемые локали; остальное → `en`.
  Future<void> setLocale(Locale locale) async {
    final code = locale.languageCode == 'ru' ? 'ru' : 'en';
    final next = Locale(code);
    if (next == state) return;

    final previous = state.languageCode;
    await _prefs.setString(localePreferenceKey, code);
    state = next;

    await _audit.record(
      sessionId: _sessionId,
      module: 'core',
      action: 'locale_change',
      contextJson: '{"from":"$previous","to":"$code"}',
    );
  }
}
