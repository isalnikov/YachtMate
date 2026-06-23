import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/features/weather/weather_providers.dart';
import 'package:captain_wrongel/features/weather/widgets/weather_layer_toolbar.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('layer buttons are 44dp and update provider', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: CwTheme.material(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: Align(
              alignment: Alignment.topRight,
              child: WeatherLayerToolbar(),
            ),
          ),
        ),
      ),
    );

    final windButton = find.bySemanticsLabel('Wind layer');
    expect(windButton, findsOneWidget);

    final size = tester.getSize(windButton);
    expect(size.width, WeatherLayerToolbar.buttonSize);
    expect(size.height, WeatherLayerToolbar.buttonSize);

    await tester.tap(find.bySemanticsLabel('Temperature layer'));
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(WeatherLayerToolbar)),
    );
    expect(container.read(weatherLayerProvider), WeatherLayer.temperature);
  });
}
