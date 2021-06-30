import 'dart:math';

import 'package:dsalg/trees.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';

void main() {
  group('AVLTree', () {
    const absentItem = 1000;
    final random = Random();
    final emptyTree = AVLTree(compareInt);
    var items = <int>[];
    var worstItems = <int>[];
    var otherItems = <int>[];
    var tree = AVLTree(compareInt);
    var worstTree = AVLTree(compareInt);

    setUp(() {
      final firstItems = List.generate(500, (_) => random.nextInt(absentItem));
      tree = AVLTree(compareInt, firstItems);
      final secondItems = List.generate(500, (_) => random.nextInt(absentItem));
      tree.insertAll(secondItems);
      items = {...firstItems, ...secondItems}.toList();
      worstItems = List.of(items)..sort(compareInt);
      worstItems = worstItems.reversed.toList();
      worstTree = AVLTree(compareInt, worstItems);
      otherItems = List.generate(200, (_) => random.nextInt(absentItem))
        ..add(absentItem);
    });

    test('should be able to traverse breadth first', () {
      const result = [10, 6, 17, 2, 8, 15, 22, 1, 3, 9, 20, 23];
      tree
        ..clear()
        ..insertAll([10, 6, 15, 8, 20, 3, 9, 17, 2, 1, 23, 22]);
      expect(tree.breadthFirstTraversal, result);
      final traversal = worstTree.breadthFirstTraversal.toList();
      var decreaseCount = 0;
      for (var i = 1; i < traversal.length; i += 1) {
        if (traversal[i] < traversal[i - 1]) decreaseCount += 1;
        if (traversal[i] > traversal[i - 1]) decreaseCount = 0;
        expect(decreaseCount, lessThanOrEqualTo(1));
      }
    });

    test('should be able to traverse depth first pre order', () {
      const result = [10, 6, 2, 1, 3, 8, 9, 17, 15, 22, 20, 23];
      tree
        ..clear()
        ..insertAll([10, 6, 15, 8, 20, 3, 9, 17, 2, 1, 23, 22]);
      expect(tree.depthFirstPreOrderTraversal, result);
      _checkDepthFirstTraversalIndirectly(
        worstTree.depthFirstPreOrderTraversal.toList(),
      );
    });

    test('should be able to traverse depth first in order', () {
      expect(tree.depthFirstInOrderTraversal, items..sort(compareInt));
    });

    test('should be able to traverse depth first post order', () {
      const result = [1, 3, 2, 9, 8, 6, 15, 20, 23, 22, 17, 10];
      tree
        ..clear()
        ..insertAll([10, 6, 15, 8, 20, 3, 9, 17, 2, 1, 23, 22]);
      expect(tree.depthFirstPostOrderTraversal, result);
      _checkDepthFirstTraversalIndirectly(
        worstTree.depthFirstPostOrderTraversal.toList(),
      );
    });

    test('should find min value', () {
      expect(tree.min, items.reduce(min));
    });

    test('should throw when has no min value to find', () {
      expect(() => emptyTree.min, throwsStateError);
    });

    test('should find max value', () {
      expect(tree.max, items.reduce(max));
    });

    test('should throw when has no max value to find', () {
      expect(() => emptyTree.max, throwsStateError);
    });

    test('should determine if it contains an item', () {
      for (final item in otherItems) {
        expect(tree.contains(item), items.contains(item));
      }
    });

    test('should find an item', () {
      for (final item in otherItems.where(items.contains)) {
        expect(items.contains(tree.get(item)), isTrue);
      }
    });

    test('should throw when item is not found', () {
      expect(() => tree.get(absentItem), throwsStateError);
    });

    test('should find an item closest to argument', () {
      int getBig() => 2000;
      tree.removeAll(otherItems);
      final items = tree.depthFirstInOrderTraversal.toList();
      for (final other in otherItems) {
        final small = items.lastWhere((item) => item < other, orElse: getBig);
        final large = items.firstWhere((item) => item > other, orElse: getBig);
        final diff = min((other - small).abs(), (other - large).abs());
        final target = tree.getClosestTo(other);
        expect((other - target).abs(), diff);
      }
    });

    test('should remove nodes and preserve search structure', () {
      tree.removeAll(otherItems);
      expect(
        tree.depthFirstInOrderTraversal,
        items
          ..sort(compareInt)
          ..removeWhere(otherItems.contains),
      );
    });

    test('should stay balanced after nodes removal', () {
      tree.removeAll(otherItems);
      _checkDepthFirstTraversalIndirectly(
        tree.depthFirstPreOrderTraversal.toList(),
      );
      _checkDepthFirstTraversalIndirectly(
        tree.depthFirstPostOrderTraversal.toList(),
      );
      const result = [15, 2, 22, 1, 9, 17, 23, 3, 20];
      tree
        ..clear()
        ..insertAll([10, 6, 15, 8, 20, 3, 9, 17, 2, 1, 23, 22])
        ..removeAll([6, 8, 10]);
      expect(tree.breadthFirstTraversal, result);
    });
  });
}

void _checkDepthFirstTraversalIndirectly(List<int> traversal) {
  final treeHeight = (log(traversal.length) / ln2).floor();
  var increaseCount = 0, decreaseCount = 0, maxDecreaseCount = 0;
  for (var i = 1; i < traversal.length; i += 1) {
    if (traversal[i] < traversal[i - 1]) {
      increaseCount = 0;
      decreaseCount += 1;
    }
    if (traversal[i] > traversal[i - 1]) {
      increaseCount += 1;
      decreaseCount = 0;
    }
    if (maxDecreaseCount < decreaseCount) maxDecreaseCount = decreaseCount;
    expect(increaseCount, lessThanOrEqualTo(3));
    expect(decreaseCount, lessThanOrEqualTo(treeHeight));
  }
  expect(maxDecreaseCount, greaterThanOrEqualTo(treeHeight - 1));
}
