import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shell bottom-nav / rail selection (0 = Map … 4 = More).
final shellTabIndexProvider =
    StateNotifierProvider<ShellTabController, int>((ref) {
  return ShellTabController();
});

class ShellTabController extends StateNotifier<int> {
  ShellTabController() : super(0);

  void selectTab(int index) {
    if (index < 0 || index > 4) return;
    state = index;
  }
}
