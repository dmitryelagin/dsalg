import 'dart:math';

import 'package:dsalg/trees.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';

void main() {
  group('BinarySearchTree', () {
    const absentItem = 1000;
    final random = Random();
    final emptyTree = BinarySearchTree(compareInt);
    var items = <int>[];
    var worstItems = <int>[];
    var otherItems = <int>[];
    var tree = BinarySearchTree(compareInt);
    var worstTree = BinarySearchTree(compareInt);

    setUp(() {
      final firstItems = List.generate(500, (_) => random.nextInt(absentItem));
      tree = BinarySearchTree(compareInt, firstItems);
      final secondItems = List.generate(500, (_) => random.nextInt(absentItem));
      tree.insertAll(secondItems);
      items = {...firstItems, ...secondItems}.toList();
      worstItems = List.of(items)..sort(compareInt);
      worstTree = BinarySearchTree(compareInt, worstItems);
      otherItems = List.generate(200, (_) => random.nextInt(absentItem))
        ..add(absentItem);
    });

    test('should be able to traverse breadth first', () {
      items = [10, 6, 15, 3, 8, 20, 9, 17];
      tree
        ..clear()
        ..insertAll(items);
      expect(tree.breadthFirstTraversal, items);
      expect(worstTree.breadthFirstTraversal, worstItems);
    });

    test('should be able to traverse depth first pre order', () {
      const result = [10, 6, 3, 8, 9, 15, 20, 17];
      items = [10, 6, 15, 3, 8, 20, 9, 17];
      tree
        ..clear()
        ..insertAll(items);
      expect(tree.depthFirstPreOrderTraversal, result);
      expect(worstTree.depthFirstPreOrderTraversal, worstItems);
    });

    test('should be able to traverse depth first in order', () {
      expect(tree.depthFirstInOrderTraversal, items..sort(compareInt));
    });

    test('should be able to traverse depth first post order', () {
      const result = [3, 9, 8, 6, 17, 20, 15, 10];
      items = [10, 6, 15, 3, 8, 20, 9, 17];
      tree
        ..clear()
        ..insertAll(items);
      expect(tree.depthFirstPostOrderTraversal, result);
      expect(worstTree.depthFirstPostOrderTraversal, worstItems.reversed);
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
  });
}
