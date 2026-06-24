import 'package:captain_wrongel/domain/weather/wind_grid.dart';
import 'package:captain_wrongel/features/map/map_wind_particles_layer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('seedWindParticles creates field from grid', () {
    final grid = WindGridBundle(
      fetchedAtUtc: DateTime.utc(2026, 1, 1),
      cells: const [
        WindGridCell(
          lat: 36,
          lon: 29,
          windSpeedKn: 20,
          windDirectionDeg: 90,
        ),
      ],
    );
    final particles = seedWindParticles(grid, count: 12);
    expect(particles, hasLength(12));
    tickWindParticles(particles);
    expect(particles.first.x, isA<double>());
  });

  test('seedWindParticles returns empty list for empty grid', () {
    expect(seedWindParticles(WindGridBundle.empty), isEmpty);
  });
}
