import 'package:captain_wrongel/features/map/offline_chart_pack_deleter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('offlineChartSqlitePackPath matches sqlite pack ids', () {
    expect(offlineChartSqlitePackPath.hasMatch('sqlite:42'), isTrue);
    expect(offlineChartSqlitePackPath.hasMatch('file:///tmp/x'), isFalse);
  });
}
