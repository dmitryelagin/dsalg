import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';

void main() {
  final random = Random();

  group('DirectedGraph', () {
    var nodesData = <int, int>{}, edgesData = <Pair<int, int>, int>{};
    var graph = DirectedGraph<int, int, int>();

    setUp(() {
      nodesData = Map.fromIterables(
        random.nextIntList(100, 1000),
        random.nextIntList(100, 1000),
      );
      edgesData = Map.fromIterables(
        Map.fromIterables(
          random.nextIntList(100, 1000),
          random.nextIntList(100, 1000),
        ).entries.map(Pair.fromEntry),
        random.nextIntList(100, 1000),
      );
      graph = DirectedGraph();
    });

    test('should do something', () {});
  });
}
