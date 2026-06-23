import 'package:url_launcher/url_launcher.dart';

/// Sends anchor drift SMS via `sms:` URI (step 45).
typedef AnchorWatchSmsLauncher = Future<void> Function(Uri uri);

Future<void> defaultAnchorWatchSmsLauncher(Uri uri) async {
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

Future<void> sendAnchorDriftSms({
  required String number,
  required String message,
  AnchorWatchSmsLauncher? launcher,
}) async {
  final raw = number.replaceAll(RegExp(r'[^\d+]'), '');
  if (raw.isEmpty) return;
  final uri = Uri.parse('sms:$raw?body=${Uri.encodeComponent(message)}');
  await (launcher ?? defaultAnchorWatchSmsLauncher)(uri);
}

String buildAnchorDriftSmsMessage({
  required double lat,
  required double lon,
  required double distanceM,
  required double radiusM,
}) {
  return 'Anchor drift alert: ${distanceM.toStringAsFixed(0)} m from anchor '
      '(limit ${radiusM.toStringAsFixed(0)} m). '
      'Position ${lat.toStringAsFixed(5)}, ${lon.toStringAsFixed(5)}.';
}
