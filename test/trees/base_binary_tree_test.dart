import 'dart:math';

import 'package:dsalg/src/trees/base_binary_tree.dart';
import 'package:dsalg/trees.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';

void main() {
  group('BaseBinaryTree', () {
    const absentItem = 1000;
    final random = Random();
    var items = <int>[];
    var worstItems = <int>[];
    late BaseBinaryTree<int> tree;
    late BaseBinaryTree<int> worstTree;

    setUp(() {
      items = List.generate(1000, (_) => random.nextInt(absentItem))
          .toSet()
          .toList();
      tree = BinarySearchTree(compareInt, items);
      worstItems = List.of(items)..sort(compareInt);
      worstTree = BinarySearchTree(compareInt, worstItems);
    });

    test('should be able to traverse breadth first', () {
      const items = [10, 6, 15, 3, 8, 20, 9, 17];
      final tree = BinarySearchTree(compareInt, items);
      expect(tree.breadthFirstTraversal, items);
      expect(worstTree.breadthFirstTraversal, worstItems);
    });

    test('should be able to traverse depth first pre order', () {
      const items = [10, 6, 15, 3, 8, 20, 9, 17];
      const result = [10, 6, 3, 8, 9, 15, 20, 17];
      final tree = BinarySearchTree(compareInt, items);
      expect(tree.depthFirstPreOrderTraversal, result);
      expect(worstTree.depthFirstPreOrderTraversal, worstItems);
    });

    test('should be able to traverse depth first in order', () {
      items.sort(compareInt);
      expect(tree.depthFirstInOrderTraversal, items);
    });

    test('should be able to traverse depth first post order', () {
      const items = [10, 6, 15, 3, 8, 20, 9, 17];
      const result = [3, 9, 8, 6, 17, 20, 15, 10];
      final tree = BinarySearchTree(compareInt, items);
      expect(tree.depthFirstPostOrderTraversal, result);
      expect(worstTree.depthFirstPostOrderTraversal, worstItems.reversed);
    });
  });
}
