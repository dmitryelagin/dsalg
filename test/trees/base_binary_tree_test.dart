import 'dart:math';

import 'package:dsalg/src/trees/base_binary_tree.dart';
import 'package:test/test.dart';

import '../mocks/base_binary_tree_mock.dart';
import '../mocks/binary_node_mock.dart';
import '../utils/compare_utils.dart';

void main() {
  group('BaseBinaryTree', () {
    const absentItem = 1000;
    final random = Random();
    var items = <int>[];
    var worstItems = <int>[];
    late BaseBinaryTree<int, BinaryNodeMock> tree;
    late BaseBinaryTree<int, BinaryNodeMock> worstTree;

    setUp(() {
      items = List.generate(1000, (_) => random.nextInt(absentItem))
          .toSet()
          .toList();
      tree = BaseBinaryTreeMock(compareInt, items);
      worstItems = List.of(items)..sort(compareInt);
      worstTree = BaseBinaryTreeMock(compareInt, worstItems);
    });

    test('should be able to traverse breadth first', () {
      items = [10, 6, 15, 3, 8, 20, 9, 17];
      tree = BaseBinaryTreeMock(compareInt, items);
      expect(tree.breadthFirstTraversal, items);
      expect(worstTree.breadthFirstTraversal, worstItems);
    });

    test('should be able to traverse depth first pre order', () {
      const result = [10, 6, 3, 8, 9, 15, 20, 17];
      items = [10, 6, 15, 3, 8, 20, 9, 17];
      tree = BaseBinaryTreeMock(compareInt, items);
      expect(tree.depthFirstPreOrderTraversal, result);
      expect(worstTree.depthFirstPreOrderTraversal, worstItems);
    });

    test('should be able to traverse depth first in order', () {
      expect(tree.depthFirstInOrderTraversal, items..sort(compareInt));
    });

    test('should be able to traverse depth first post order', () {
      const result = [3, 9, 8, 6, 17, 20, 15, 10];
      items = [10, 6, 15, 3, 8, 20, 9, 17];
      tree = BaseBinaryTreeMock(compareInt, items);
      expect(tree.depthFirstPostOrderTraversal, result);
      expect(worstTree.depthFirstPostOrderTraversal, worstItems.reversed);
    });
  });
}
