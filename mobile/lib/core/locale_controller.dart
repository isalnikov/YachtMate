import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/audit_repository.dart';

/// Управляет локалью приложения (**en**, **ru**, **de**, **fr**, **es**, **it**, **el**, **tr**, **pt**).
///
/// При первом запуске (ключа нет) для языка системы используется поддерживаемая локаль или `en`.
class LocaleController extends StateNotifier<Locale> {
  LocaleController(this._prefs, this._audit, this._sessionId)
    : super(_initialLocale(_prefs));

  final SharedPreferences _prefs;
  final AuditRepository _audit;
  final String _sessionId;

  static const localePreferenceKey = 'localeCode';

  static const Set<String> supportedCodes = {
    'en',
    'ru',
    'de',
    'fr',
    'es',
    'it',
    'el',
    'tr',
    'pt',
  };

  static Locale _initialLocale(SharedPreferences prefs) {
    final saved = prefs.getString(localePreferenceKey);
    if (saved != null && supportedCodes.contains(saved)) {
      return Locale(saved);
    }
    final code = PlatformDispatcher.instance.locale.languageCode;
    if (supportedCodes.contains(code)) return Locale(code);
    return const Locale('en');
  }

  /// Фиксирует только поддерживаемые локали; остальное → `en`.
  Future<void> setLocale(Locale locale) async {
    final raw = locale.languageCode;
    final code = supportedCodes.contains(raw) ? raw : 'en';
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
