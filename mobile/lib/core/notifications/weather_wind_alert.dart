import '../../domain/weather/weather_forecast_view.dart';
import 'local_notifications_service.dart';
import 'notification_preferences_controller.dart';

typedef WindAlertBodyBuilder = String Function(String kn, String threshold);

/// Fires a local notification when forecast wind exceeds user threshold (step 51).
Future<void> maybeNotifyHighWind({
  required WeatherForecastBundle bundle,
  required NotificationPreferences prefs,
  required LocalNotificationsPort port,
  required String title,
  required WindAlertBodyBuilder bodyForKn,
}) async {
  if (!prefs.weatherWindEnabled || bundle.hourly.isEmpty) return;

  final maxKn = bundle.hourly
      .take(24)
      .map((h) => h.windSpeedKn)
      .where((v) => !v.isNaN)
      .fold<double>(0, (a, b) => a > b ? a : b);

  if (maxKn < prefs.windThresholdKn) return;

  await port.showWeatherWindAlert(
    title: title,
    body: bodyForKn(
      maxKn.toStringAsFixed(0),
      prefs.windThresholdKn.toStringAsFixed(0),
    ),
  );
}
