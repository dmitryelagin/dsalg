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

  group('SplayTree', () {
    testBaseBinarySearchTree(<K, V>(compare, [entries]) {
      return SplayTree(compare, entries ?? const {});
    });
  });

  group('SplayTree', () {
    late IntComparator compareInt, compareIntReversed;
    late List<int> items, worstItems;
    late SplayTree<int, int> tree, worstTree;

    setUp(() {
      compareInt = IntComparator();
      compareIntReversed = IntComparator()..invert();
      final firstItems = random.nextIntMap(500, absentItem);
      tree = SplayTree(compareInt, firstItems);
      final secondItems = random.nextIntMap(500, absentItem);
      tree.addAll(secondItems);
      items = {...firstItems.keys, ...secondItems.keys}.toList();
      worstItems = items.copySort(compareInt);
      worstTree = SplayTree(compareInt, worstItems.toMap());
    });

    test('should be able to traverse breadth first', () {
      tree
        ..clear()
        ..addAll([10, 6, 15, 3, 8, 20, 9, 17].toMap());
      expect(
        tree.breadthFirstTraversalEntries.toString(),
        [17, 9, 20, 8, 15, 3, 10, 6].toMapEntries().toString(),
      );
      worstItems.sort(compareIntReversed);
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
        [17, 9, 8, 3, 6, 15, 10, 20].toMapEntries().toString(),
      );
      worstItems.sort(compareIntReversed);
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
        [6, 3, 8, 10, 15, 9, 20, 17].toMapEntries().toString(),
      );
      expect(
        worstTree.depthFirstPostOrderTraversalEntries.toString(),
        worstItems.toMapEntries().toString(),
      );
    });
  });
}
