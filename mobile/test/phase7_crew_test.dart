import 'package:captain_wrongel/core/crew/crew_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('CrewController create ship sets captain', () async {
    SharedPreferences.setMockInitialValues({});
    final p = await SharedPreferences.getInstance();
    final c = CrewController(p);
    await c.createShipAndInvite();
    expect(c.state.role, CrewRole.captain);
    expect(c.state.inviteCode, hasLength(6));
    expect(c.state.shipId, isNotNull);
  });

  test('joinShip matches same invite hash', () async {
    SharedPreferences.setMockInitialValues({});
    final p = await SharedPreferences.getInstance();
    final cap = CrewController(p);
    await cap.createShipAndInvite();
    final code = cap.state.inviteCode!;

    SharedPreferences.setMockInitialValues({});
    final p2 = await SharedPreferences.getInstance();
    final crew = CrewController(p2);
    await crew.joinShip(code);
    expect(crew.state.role, CrewRole.crew);
    expect(crew.state.shipId, cap.state.shipId);
  });
}
