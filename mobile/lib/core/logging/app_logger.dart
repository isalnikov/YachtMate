import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Technical logging channel — structured fields in debug; safe release behavior.
///
/// Coordinate- and secret-like keys are redacted in release builds.
/// See финальный план §10.
class AppLogger {
  AppLogger(this.tag);

  final String tag;

  static final Set<String> _redactedKeys = {
    'lat',
    'lon',
    'latitude',
    'longitude',
    'token',
    'apiKey',
  };

  void debug(String message, [Map<String, Object?>? attrs]) {
    if (kReleaseMode) return;
    _emit('DEBUG', message, attrs);
  }

  void info(String message, [Map<String, Object?>? attrs]) =>
      _emit('INFO', message, attrs);

  void warning(String message, [Map<String, Object?>? attrs]) =>
      _emit('WARN', message, attrs);

  void error(String message, [Map<String, Object?>? attrs]) =>
      _emit('ERROR', message, attrs);

  void _emit(String level, String message, Map<String, Object?>? attrs) {
    final sanitized = _sanitize(attrs);
    final payload = sanitized == null
        ? message
        : '$message ${jsonEncode(sanitized)}';
    developer.log(payload, name: '$tag|$level');
  }

  Map<String, Object?>? _sanitize(Map<String, Object?>? attrs) {
    if (attrs == null) return null;
    if (!kReleaseMode) return attrs;
    return {
      for (final e in attrs.entries)
        e.key: _redactedKeys.contains(e.key.toLowerCase())
            ? '[redacted]'
            : e.value,
    };
  }
}
