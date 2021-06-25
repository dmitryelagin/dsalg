import 'dart:math';

import 'package:dsalg/trees.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';

void main() {
  group('BinarySearchTree', () {
    final random = Random();

    var items = <int>[];
    var worstItems = <int>[];
    var tree = BinarySearchTree<int>(compareNum);
    var worstTree = BinarySearchTree<int>(compareNum);

    setUp(() {
      final firstItems = List.generate(500, (_) => random.nextInt(1000));
      tree = BinarySearchTree(compareNum, firstItems);
      final secondItems = List.generate(500, (_) => random.nextInt(1000))
        ..forEach(tree.insert);
      items = {...firstItems, ...secondItems}.toList();
      worstItems = List.of(items)..sort(compareNum);
      worstTree = BinarySearchTree(compareNum, worstItems);
    });

    test('should find min value', () {
      expect(tree.min, items.reduce(min));
    });

    test('should throw when has no min value to find', () {
      final tree = BinarySearchTree<int>(compareNum);
      expect(() => tree.min, throwsStateError);
    });

    test('should find max value', () {
      expect(tree.max, items.reduce(max));
    });

    test('should throw when has no max value to find', () {
      final tree = BinarySearchTree<int>(compareNum);
      expect(() => tree.max, throwsStateError);
    });

    test('should be able to traverse breadth first', () {
      const items = [10, 6, 15, 3, 8, 20, 9, 17];
      final tree = BinarySearchTree(compareNum, items);
      expect(tree.breadthFirstTraversal, items);
      expect(worstTree.breadthFirstTraversal, worstItems);
    });

    test('should be able to traverse depth first pre order', () {
      const items = [10, 6, 15, 3, 8, 20, 9, 17];
      const result = [10, 6, 3, 8, 9, 15, 20, 17];
      final tree = BinarySearchTree(compareNum, items);
      expect(tree.depthFirstPreOrderTraversal, result);
      expect(worstTree.depthFirstPreOrderTraversal, worstItems);
    });

    test('should be able to traverse depth first in order', () {
      items.sort(compareNum);
      expect(tree.depthFirstInOrderTraversal, items);
    });

    test('should be able to traverse depth first post order', () {
      const items = [10, 6, 15, 3, 8, 20, 9, 17];
      const result = [3, 9, 8, 6, 17, 20, 15, 10];
      final tree = BinarySearchTree(compareNum, items);
      expect(tree.depthFirstPostOrderTraversal, result);
      expect(worstTree.depthFirstPostOrderTraversal, worstItems.reversed);
    });

    test('should determine if it contains an item', () {
      final otherItems = List.generate(100, (_) => random.nextInt(1000));
      for (final item in otherItems) {
        expect(tree.contains(item), items.contains(item));
      }
    });

    test('should remove nodes preserving search structure', () {
      final otherItems = List.generate(100, (_) => random.nextInt(1000))
        ..add(1000)
        ..forEach(tree.remove);
      expect(
        tree.depthFirstInOrderTraversal,
        items
          ..sort(compareNum)
          ..removeWhere(otherItems.contains),
      );
    });
  });
}
