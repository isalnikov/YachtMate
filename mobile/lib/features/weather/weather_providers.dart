import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../domain/tides/tide_demo_models.dart';
import '../../domain/weather/weather_forecast_view.dart';

class WeatherPin {
  const WeatherPin({required this.lat, required this.lon});

  final double lat;
  final double lon;
}

class WeatherPinNotifier extends StateNotifier<WeatherPin> {
  WeatherPinNotifier() : super(const WeatherPin(lat: 36.65, lon: 29.12));

  void setPin(double lat, double lon) => state = WeatherPin(lat: lat, lon: lon);
}

final weatherPinProvider =
    StateNotifierProvider<WeatherPinNotifier, WeatherPin>((ref) {
      return WeatherPinNotifier();
    });

final weatherForecastProvider =
    FutureProvider.autoDispose<WeatherForecastBundle>((ref) async {
      final pin = ref.watch(weatherPinProvider);
      final repo = ref.watch(weatherRepositoryProvider);
      return repo.loadForecast(pin.lat, pin.lon);
    });

final tideDemoProvider = FutureProvider<TideDemoStation>((ref) async {
  return ref.read(tidesRepositoryProvider).loadDemoBundled();
});

/// Index into the 48-hour forecast slice shown on [WeatherScreen].
final selectedHourIndexProvider = StateProvider<int>((ref) => 0);

/// Active weather overlay layer on [WeatherScreen] (step-15).
enum WeatherLayer { wind, waves, temperature, pressure }

final weatherLayerProvider = StateProvider<WeatherLayer>((ref) {
  return WeatherLayer.wind;
});
