import 'package:captain_wrongel/core/notifications/local_notifications_service.dart';
import 'package:captain_wrongel/core/notifications/weather_wind_alert.dart';
import 'package:captain_wrongel/core/notifications/notification_preferences_controller.dart';
import 'package:captain_wrongel/domain/weather/weather_forecast_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maybeNotifyHighWind fires when forecast exceeds threshold', () async {
    final port = RecordingLocalNotificationsPort();
    final prefs = const NotificationPreferences(
      anchorDriftEnabled: true,
      weatherWindEnabled: true,
      windThresholdKn: 20,
    );
    final bundle = WeatherForecastBundle(
      fetchedAtUtc: DateTime.utc(2026, 6, 1),
      isStale: false,
      hourly: [
        HourlyWeatherPoint(
          timeUtc: DateTime.utc(2026, 6, 1, 12),
          temperatureC: 20,
          precipitationMm: 0,
          pressureHpa: 1013,
          windSpeedKn: 28,
          windDirectionDeg: 180,
        ),
      ],
    );

    await maybeNotifyHighWind(
      bundle: bundle,
      prefs: prefs,
      port: port,
      title: 'High wind',
      bodyForKn: (kn, th) => '$kn kn > $th kn',
    );

    expect(port.lastKind, LocalNotificationKind.weatherWind);
    expect(port.lastTitle, 'High wind');
    expect(port.lastBody, contains('28'));
  });

  test('RecordingLocalNotificationsPort records anchor drift', () async {
    final port = RecordingLocalNotificationsPort();
    await port.showAnchorDriftAlert(title: 'Drift', body: 'Check anchor');
    expect(port.lastKind, LocalNotificationKind.anchorDrift);
    expect(port.lastBody, 'Check anchor');
  });
}
