import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';
import '../utils/data_utils.dart';
import '../utils/iterable_utils.dart';
import 'commons/base_binary_search_tree_test.dart';

void main() {
  group('AVLTree', () {
    testBaseBinarySearchTree(<K, V>(compare, [entries = const {}]) {
      return AVLTree<K, V>(compare, entries);
    });
  });

  group('AVLTree', () {
    const absentItem = 1000;
    var compareInt = IntComparator();
    var tree = AVLTree<int, int>(compareInt);
    var items = <int>[], otherItems = <int>[];
    var worstTree = AVLTree<int, int>(compareInt);

    setUp(() {
      compareInt = IntComparator();
      final firstItems = createIntMap(500, absentItem);
      tree = AVLTree(compareInt, firstItems);
      final secondItems = createIntMap(500, absentItem);
      tree.addAll(secondItems);
      items = {...firstItems.keys, ...secondItems.keys}.toList();
      otherItems = createIntList(200, absentItem)..add(absentItem);
      final worstItems = items.copySort(compareInt).reversed;
      worstTree = AVLTree(compareInt, worstItems.toMap());
    });

    test('should be able to traverse breadth first', () {
      tree
        ..clear()
        ..addAll([10, 6, 15, 8, 20, 3, 9, 17, 2, 1, 23, 22].toMap());
      expect(
        tree.breadthFirstTraversalEntries.toString(),
        [10, 6, 17, 2, 8, 15, 22, 1, 3, 9, 20, 23].toMapEntries().toString(),
      );
      final traversal = worstTree.breadthFirstTraversalKeys.toList();
      var decreaseCount = 0;
      for (var i = 1; i < traversal.length; i += 1) {
        if (traversal[i] < traversal[i - 1]) decreaseCount += 1;
        if (traversal[i] > traversal[i - 1]) decreaseCount = 0;
        expect(decreaseCount, lessThanOrEqualTo(1));
      }
    });

    test('should be able to traverse depth first pre order', () {
      tree
        ..clear()
        ..addAll([10, 6, 15, 8, 20, 3, 9, 17, 2, 1, 23, 22].toMap());
      expect(
        tree.depthFirstPreOrderTraversalEntries.toString(),
        [10, 6, 2, 1, 3, 8, 9, 17, 15, 22, 20, 23].toMapEntries().toString(),
      );
      _checkDepthFirstTraversalIndirectly(
        worstTree.depthFirstPreOrderTraversalKeys.toList(),
      );
    });

    test('should be able to traverse depth first post order', () {
      tree
        ..clear()
        ..addAll([10, 6, 15, 8, 20, 3, 9, 17, 2, 1, 23, 22].toMap());
      expect(
        tree.depthFirstPostOrderTraversalEntries.toString(),
        [1, 3, 2, 9, 8, 6, 15, 20, 23, 22, 17, 10].toMapEntries().toString(),
      );
      _checkDepthFirstTraversalIndirectly(
        worstTree.depthFirstPostOrderTraversalKeys.toList(),
      );
    });

    test('should stay balanced after nodes insertion and removal', () {
      tree.removeAll(otherItems);
      _checkDepthFirstTraversalIndirectly(
        tree.depthFirstPreOrderTraversalKeys.toList(),
      );
      _checkDepthFirstTraversalIndirectly(
        tree.depthFirstPostOrderTraversalKeys.toList(),
      );
      tree
        ..clear()
        ..addAll([10, 6, 15, 8, 20, 3, 9, 17, 2, 1, 23, 22].toMap())
        ..removeAll([6, 8, 10]);
      expect(
        tree.breadthFirstTraversalEntries.toString(),
        [15, 2, 22, 1, 9, 17, 23, 3, 20].toMapEntries().toString(),
      );
      tree
        ..clear()
        ..addAll(
          [
            ...[21, 64, 79, 24, 4, 61, 7, 75, 80, 63, 10, 53, 19, 13, 95],
            ...[81, 23, 5, 65, 57, 18, 87, 25, 67, 96],
          ].toMap(),
        )
        ..removeAll([
          ...[3, 99, 21, 1, 10, 14, 16, 77, 25, 78, 33, 90, 74, 44, 56],
          ...[93, 39, 64, 54, 49, 46, 45],
        ]);
      expect(
        tree.breadthFirstTraversalEntries.toString(),
        [
          ...[65, 24, 79, 13, 61, 67, 81, 5, 19, 53, 63, 75, 80, 95, 4],
          ...[7, 18, 23, 57, 87, 96],
        ].toMapEntries().toString(),
      );
      tree
        ..clear()
        ..addAll(
          [
            ...[91, 24, 5, 71, 86, 90, 38, 48, 3, 81, 21, 64, 79, 4, 61, 7],
            ...[75, 80, 63, 10, 53, 19, 13, 95, 23, 65, 57, 18, 87, 25, 67],
            ...[96, 99, 1],
          ].toMap(),
        )
        ..removeAll([
          ...[10, 14, 16, 77, 25, 78, 33, 90, 74, 44, 56, 93, 39, 64, 54],
          ...[49, 46, 45, 48, 82, 95, 3, 24, 58, 86, 76, 72, 32, 51, 75],
          ...[99, 37, 18, 98],
        ]);
      expect(
        tree.breadthFirstTraversalEntries.toString(),
        [
          ...[53, 13, 79, 5, 21, 63, 87, 4, 7, 19, 38, 57, 67, 81, 96, 1],
          ...[23, 61, 65, 71, 80, 91],
        ].toMapEntries().toString(),
      );
      tree
        ..clear()
        ..addAll(
          [
            ...[20, 4, 31, 89, 7, 94, 79, 80, 59, 21, 77, 33, 14, 88, 44, 61],
            ...[3, 26, 82, 49, 11, 37, 53, 10, 55, 1, 93, 68, 8, 99, 46],
          ].toMap(),
        )
        ..removeAll([
          ...[3, 58, 40, 15, 7, 1, 24, 27, 14, 79, 49, 46, 66, 60, 99, 91],
          ...[37, 88, 4, 38, 39, 81, 85, 45, 2, 53, 21, 41, 96, 74, 68, 78],
          ...[56, 16, 76, 32, 62, 17, 95],
        ]);
      expect(
        tree.breadthFirstTraversalEntries.toString(),
        [55, 31, 80, 11, 44, 61, 89, 8, 26, 33, 59, 77, 82, 94, 10, 20, 93]
            .toMapEntries()
            .toString(),
      );
    });
  });
}

void _checkDepthFirstTraversalIndirectly(List<int> traversal) {
  final height = (log(traversal.length) / ln2).ceil();
  final heightError = height ~/ 4, minHeight = height ~/ 2;
  var increaseCount = 0, decreaseCount = 0, maxDecreaseCount = 0;
  for (var i = 1; i < traversal.length; i += 1) {
    increaseCount = traversal[i] < traversal[i - 1] ? 0 : increaseCount + 1;
    decreaseCount = traversal[i] < traversal[i - 1] ? decreaseCount + 1 : 0;
    if (maxDecreaseCount < decreaseCount) maxDecreaseCount = decreaseCount;
    expect(increaseCount, lessThanOrEqualTo(minHeight + heightError));
    expect(decreaseCount, lessThanOrEqualTo(height + heightError));
  }
  expect(maxDecreaseCount, greaterThanOrEqualTo(minHeight));
}
