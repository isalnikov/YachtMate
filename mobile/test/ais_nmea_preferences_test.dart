import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/features/ais/ais_nmea_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('applyFromFields persists host and port', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(aisNmeaPreferencesProvider.notifier)
        .applyFromFields('10.0.0.5', '4001');

    expect(prefs.getString('ais_nmea_host'), '10.0.0.5');
    expect(prefs.getInt('ais_nmea_port'), 4001);
    expect(
      container.read(aisNmeaPreferencesProvider).host,
      '10.0.0.5',
    );
  });
}
