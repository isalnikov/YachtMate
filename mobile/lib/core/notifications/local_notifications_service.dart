import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Notification kinds for tests and analytics (step 51).
enum LocalNotificationKind {
  anchorDrift,
  weatherWind,
}

/// Port for local notifications — swappable in tests.
abstract class LocalNotificationsPort {
  Future<void> initialize();

  Future<void> showAnchorDriftAlert({
    required String title,
    required String body,
  });

  Future<void> showWeatherWindAlert({
    required String title,
    required String body,
  });

  /// Last notification shown (recording implementations only).
  LocalNotificationKind? get lastKind;

  String? get lastTitle;

  String? get lastBody;
}

/// Records notifications without platform calls (tests / unsupported platforms).
class RecordingLocalNotificationsPort implements LocalNotificationsPort {
  @override
  LocalNotificationKind? lastKind;

  @override
  String? lastTitle;

  @override
  String? lastBody;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> showAnchorDriftAlert({
    required String title,
    required String body,
  }) async {
    lastKind = LocalNotificationKind.anchorDrift;
    lastTitle = title;
    lastBody = body;
  }

  @override
  Future<void> showWeatherWindAlert({
    required String title,
    required String body,
  }) async {
    lastKind = LocalNotificationKind.weatherWind;
    lastTitle = title;
    lastBody = body;
  }
}

/// Production local notifications via flutter_local_notifications.
class FlutterLocalNotificationsPort implements LocalNotificationsPort {
  FlutterLocalNotificationsPort() : _plugin = FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  @override
  LocalNotificationKind? lastKind;

  @override
  String? lastTitle;

  @override
  String? lastBody;

  static const _channelId = 'captain_wrongel_alerts';
  static const _channelName = 'Safety alerts';

  @override
  Future<void> initialize() async {
    if (kIsWeb) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _channelId,
              _channelName,
              importance: Importance.high,
            ),
          );
    }
  }

  Future<void> _show(String title, String body, LocalNotificationKind kind) async {
    lastKind = kind;
    lastTitle = title;
    lastBody = body;
    if (kIsWeb) return;
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.show(kind.index, title, body, details);
  }

  @override
  Future<void> showAnchorDriftAlert({
    required String title,
    required String body,
  }) =>
      _show(title, body, LocalNotificationKind.anchorDrift);

  @override
  Future<void> showWeatherWindAlert({
    required String title,
    required String body,
  }) =>
      _show(title, body, LocalNotificationKind.weatherWind);
}
