import 'package:url_launcher/url_launcher.dart';

/// Открытие ссылок и geo URL из карточки стоянки (Фаза 6).
Future<bool> openExternalUri(Uri uri) async {
  if (!await canLaunchUrl(uri)) return false;
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Телефон с учётом префикса «+» и пробелов в каталоге.
Future<bool> dialPhoneNumber(String raw) async {
  final t = raw.trim();
  if (t.isEmpty) return false;
  final buf = StringBuffer();
  if (t.startsWith('+')) buf.write('+');
  final start = t.startsWith('+') ? 1 : 0;
  for (var i = start; i < t.length; i++) {
    final ch = t[i];
    if (RegExp(r'\d').hasMatch(ch)) buf.write(ch);
  }
  final s = buf.toString();
  if (s.replaceAll('+', '').isEmpty) return false;
  return openExternalUri(Uri.parse('tel:$s'));
}

Future<bool> openEmail(String raw) async {
  final uri = Uri(scheme: 'mailto', path: raw.trim());
  return openExternalUri(uri);
}

/// HTTP(S) или добавление схемы для домена из каталога.
Uri? parseHttpish(String? raw) {
  if (raw == null) return null;
  final t = raw.trim();
  if (t.isEmpty) return null;
  if (t.contains('://')) return Uri.tryParse(t);
  return Uri.tryParse('https://$t');
}

/// Карта OSM по координатам (нейтральный deeplink).
Future<bool> openInOpenStreetMap({
  required double lat,
  required double lon,
}) async {
  final uri = Uri.parse(
    'https://www.openstreetmap.org/?mlat=$lat&mlon=$lon#map=15/$lat/$lon',
  );
  return openExternalUri(uri);
}
