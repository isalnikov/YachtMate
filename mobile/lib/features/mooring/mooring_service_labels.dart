import '../../l10n/app_localizations.dart';

/// Локализованные подписи для JSON-ключей `services` в каталоге.
String mooringServiceKeyLabel(AppLocalizations l10n, String key) {
  switch (key) {
    case 'electricity':
      return l10n.mooringSvcElectricity;
    case 'water':
      return l10n.mooringSvcWater;
    case 'wifi':
      return l10n.mooringSvcWifi;
    case 'fuel':
      return l10n.mooringSvcFuel;
    case 'protection':
      return l10n.mooringSvcProtection;
    case 'holding':
      return l10n.mooringSvcHolding;
    default:
      return key;
  }
}

String mooringServiceLine(AppLocalizations l10n, MapEntry<String, dynamic> e) {
  final label = mooringServiceKeyLabel(l10n, e.key);
  final v = e.value;
  if (v is bool) {
    return v ? '✓ $label' : '— $label';
  }
  return '$label: $v';
}
