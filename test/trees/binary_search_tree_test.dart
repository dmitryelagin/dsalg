import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';
import '../utils/data_utils.dart';
import '../utils/iterable_utils.dart';
import 'commons/base_binary_search_tree_test.dart';

void main() {
  const absentItem = 1000;
  final random = Random();

  group('BinarySearchTree', () {
    testBaseBinarySearchTree(<K, V>(compare, [entries]) {
      return BinarySearchTree<K, V>(compare, entries ?? const {});
    });
  });

  group('BinarySearchTree', () {
    var compareInt = IntComparator();
    var tree = BinarySearchTree<int, int>(compareInt);
    var items = <int>[];
    var worstTree = BinarySearchTree<int, int>(compareInt);
    var worstItems = <int>[];

    setUp(() {
      compareInt = IntComparator();
      final firstItems = random.nextIntMap(500, absentItem);
      tree = BinarySearchTree(compareInt, firstItems);
      final secondItems = random.nextIntMap(500, absentItem);
      tree.addAll(secondItems);
      items = {...firstItems.keys, ...secondItems.keys}.toList();
      worstItems = items.copySort(compareInt);
      worstTree = BinarySearchTree(compareInt, worstItems.toMap());
    });

    test('should be able to traverse breadth first', () {
      items = [10, 6, 15, 3, 8, 20, 9, 17];
      tree
        ..clear()
        ..addAll(items.toMap());
      expect(
        tree.breadthFirstTraversalEntries.toString(),
        items.toMapEntries().toString(),
      );
      expect(
        worstTree.breadthFirstTraversalEntries.toString(),
        worstItems.toMapEntries().toString(),
      );
    });

    test('should be able to traverse depth first pre order', () {
      tree
        ..clear()
        ..addAll([10, 6, 15, 3, 8, 20, 9, 17].toMap());
      expect(
        tree.depthFirstPreOrderTraversalEntries.toString(),
        [10, 6, 3, 8, 9, 15, 20, 17].toMapEntries().toString(),
      );
      expect(
        worstTree.depthFirstPreOrderTraversalEntries.toString(),
        worstItems.toMapEntries().toString(),
      );
    });

    test('should be able to traverse depth first post order', () {
      tree
        ..clear()
        ..addAll([10, 6, 15, 3, 8, 20, 9, 17].toMap());
      expect(
        tree.depthFirstPostOrderTraversalEntries.toString(),
        [3, 9, 8, 6, 17, 20, 15, 10].toMapEntries().toString(),
      );
      expect(
        worstTree.depthFirstPostOrderTraversalEntries.toString(),
        worstItems.reversed.toMapEntries().toString(),
      );
    });
  });
}
