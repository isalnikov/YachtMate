import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/audit_repository.dart';

enum TextSizeBucket {
  standard,
  large,
  extraLarge;

  double get scale => switch (this) {
    TextSizeBucket.standard => 1.0,
    TextSizeBucket.large => 1.15,
    TextSizeBucket.extraLarge => 1.32,
  };

  static TextSizeBucket decode(int? raw) => switch (raw) {
    1 => TextSizeBucket.large,
    2 => TextSizeBucket.extraLarge,
    _ => TextSizeBucket.standard,
  };

  int get encoded => switch (this) {
    TextSizeBucket.standard => 0,
    TextSizeBucket.large => 1,
    TextSizeBucket.extraLarge => 2,
  };
}

/// Режим перчатки, масштаб текста и высокий контраст (Фаза 8).
class AccessibilityPreferences {
  const AccessibilityPreferences({
    required this.gloveMode,
    required this.textSize,
    required this.highContrast,
  });

  final bool gloveMode;
  final TextSizeBucket textSize;
  final bool highContrast;

  double get textScale => textSize.scale;

  @override
  bool operator ==(Object other) =>
      other is AccessibilityPreferences &&
      other.gloveMode == gloveMode &&
      other.textSize == textSize &&
      other.highContrast == highContrast;

  @override
  int get hashCode => Object.hash(gloveMode, textSize, highContrast);
}

class AccessibilityPreferencesController
    extends StateNotifier<AccessibilityPreferences> {
  AccessibilityPreferencesController(this._prefs, this._audit, this._sessionId)
    : super(_initial(_prefs));

  final SharedPreferences _prefs;
  final AuditRepository _audit;
  final String _sessionId;

  static const glovePreferenceKey = 'accessibilityGloveMode';
  static const textSizePreferenceKey = 'accessibilityTextSize';
  static const highContrastPreferenceKey = 'accessibilityHighContrast';

  static AccessibilityPreferences _initial(SharedPreferences prefs) {
    return AccessibilityPreferences(
      gloveMode: prefs.getBool(glovePreferenceKey) ?? false,
      textSize: TextSizeBucket.decode(prefs.getInt(textSizePreferenceKey)),
      highContrast: prefs.getBool(highContrastPreferenceKey) ?? false,
    );
  }

  Future<void> setGloveMode(bool value) async {
    if (value == state.gloveMode) return;
    await _prefs.setBool(glovePreferenceKey, value);
    state = AccessibilityPreferences(
      gloveMode: value,
      textSize: state.textSize,
      highContrast: state.highContrast,
    );
    await _audit.record(
      sessionId: _sessionId,
      module: 'core',
      action: 'accessibility_glove',
      contextJson: '{"enabled":$value}',
    );
  }

  Future<void> setTextSize(TextSizeBucket bucket) async {
    if (bucket == state.textSize) return;
    await _prefs.setInt(textSizePreferenceKey, bucket.encoded);
    state = AccessibilityPreferences(
      gloveMode: state.gloveMode,
      textSize: bucket,
      highContrast: state.highContrast,
    );
    await _audit.record(
      sessionId: _sessionId,
      module: 'core',
      action: 'accessibility_text_size',
      contextJson: '{"bucket":${bucket.encoded}}',
    );
  }

  Future<void> setHighContrast(bool value) async {
    if (value == state.highContrast) return;
    await _prefs.setBool(highContrastPreferenceKey, value);
    state = AccessibilityPreferences(
      gloveMode: state.gloveMode,
      textSize: state.textSize,
      highContrast: value,
    );
    await _audit.record(
      sessionId: _sessionId,
      module: 'core',
      action: 'accessibility_high_contrast',
      contextJson: '{"enabled":$value}',
    );
  }
}
