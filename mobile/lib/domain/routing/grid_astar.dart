import 'dart:collection';
import 'dart:math' as math;

import 'depth_grid.dart';

typedef Cell = (int row, int col);

/// A* по 8-соседям.
List<Cell>? astarGridPath({
  required DepthGrid grid,
  required Cell start,
  required Cell goal,
  required bool Function(int r, int c) navigable,
}) {
  if (!navigable(start.$1, start.$2) || !navigable(goal.$1, goal.$2)) {
    return null;
  }

  double heuristic(Cell a) {
    final dr = (a.$1 - goal.$1).abs().toDouble();
    final dc = (a.$2 - goal.$2).abs().toDouble();
    return math.max(dr, dc) + (math.sqrt(2) - 1) * math.min(dr, dc);
  }

  final open = SplayTreeSet<_OpenNode>(_compareOpen);
  final gScore = <Cell, double>{};
  final came = <Cell, Cell>{};

  gScore[start] = 0;
  open.add(_OpenNode(cell: start, g: 0, f: heuristic(start)));

  const neighbors = <(int, int)>[
    (-1, 0),
    (1, 0),
    (0, -1),
    (0, 1),
    (-1, -1),
    (-1, 1),
    (1, -1),
    (1, 1),
  ];

  while (open.isNotEmpty) {
    final cur = open.first;
    open.remove(cur);
    if (cur.g != gScore[cur.cell]) {
      continue;
    }
    if (cur.cell == goal) {
      return _reconstructPath(came, start, goal);
    }

    for (final d in neighbors) {
      final nr = cur.cell.$1 + d.$1;
      final nc = cur.cell.$2 + d.$2;
      if (nr < 0 || nc < 0 || nr >= grid.rows || nc >= grid.cols) continue;
      if (!navigable(nr, nc)) continue;

      final step = (d.$1 != 0 && d.$2 != 0) ? math.sqrt(2) : 1.0;
      final tentative = cur.g + step;
      final next = (nr, nc);
      if (tentative < (gScore[next] ?? double.infinity)) {
        came[next] = cur.cell;
        gScore[next] = tentative;
        open.add(
          _OpenNode(cell: next, g: tentative, f: tentative + heuristic(next)),
        );
      }
    }
  }

  return null;
}

List<Cell> _reconstructPath(Map<Cell, Cell> came, Cell start, Cell goal) {
  final rev = <Cell>[];
  var c = goal;
  while (c != start) {
    rev.add(c);
    final p = came[c];
    if (p == null) {
      return [];
    }
    c = p;
  }
  rev.add(start);
  return rev.reversed.toList(growable: false);
}

int _compareOpen(_OpenNode a, _OpenNode b) {
  final byF = a.f.compareTo(b.f);
  if (byF != 0) return byF;
  final byR = a.cell.$1.compareTo(b.cell.$1);
  if (byR != 0) return byR;
  return a.cell.$2.compareTo(b.cell.$2);
}

class _OpenNode {
  _OpenNode({required this.cell, required this.g, required this.f});

  final Cell cell;
  final double g;
  final double f;

  @override
  bool operator ==(Object other) =>
      other is _OpenNode &&
      other.cell.$1 == cell.$1 &&
      other.cell.$2 == cell.$2 &&
      other.g == g &&
      other.f == f;

  @override
  int get hashCode => Object.hash(cell.$1, cell.$2, g, f);
}
