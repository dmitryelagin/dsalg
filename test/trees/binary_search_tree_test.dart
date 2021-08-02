import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:dsalg/src/trees/binary_tree/binary_tree.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';
import '../utils/data_utils.dart';
import '../utils/int_utils.dart';
import '../utils/iterable_utils.dart';

void main() {
  const absentItem = 1000;
  var compareInt = IntComparator();
  var tree = BinarySearchTree<int, int>(compareInt);
  var items = <int>[];

  setUp(() {
    compareInt = IntComparator();
    final firstItems = createIntMap(500, absentItem);
    tree = BinarySearchTree(compareInt, firstItems);
    final secondItems = createIntMap(500, absentItem);
    tree.addAll(secondItems);
    items = {...firstItems.keys, ...secondItems.keys}.toList();
  });

  group('BinarySearchTree', () {
    var worstTree = BinarySearchTree<int, int>(compareInt);
    var worstItems = <int>[];

    setUp(() {
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

  group('BinarySearchTree as BaseBinarySearchTree', () {
    int getBigItem() => 2000;
    final emptyTree = BinarySearchTree<int, int>(compareInt);
    var otherItems = <int>[];

    setUp(() {
      otherItems = createIntList(200, absentItem)..add(absentItem);
    });

    test('should be able to traverse depth first in order', () {
      expect(
        tree.entries.toString(),
        items.copySort(compareInt).toMapEntries().toString(),
      );
    });

    test('should remove nodes and preserve search structure', () {
      tree.removeAll(otherItems);
      items
        ..sort(compareInt)
        ..removeWhere(otherItems.contains);
      expect(
        tree.entries.toString(),
        items.toMapEntries().toString(),
      );
    });

    test('should find min value', () {
      expect(
        tree.min.toString(),
        items.reduce(min).toMapEntry().toString(),
      );
    });

    test('should throw when has no min value to find', () {
      expect(() => emptyTree.min, throwsStateError);
    });

    test('should find max value', () {
      expect(
        tree.max.toString(),
        items.reduce(max).toMapEntry().toString(),
      );
    });

    test('should throw when has no max value to find', () {
      expect(() => emptyTree.max, throwsStateError);
    });

    test('should determine if it contains an item', () {
      for (final item in otherItems) {
        expect(tree.containsKey(item), items.contains(item));
      }
    });

    test('should find an item', () {
      for (final item in otherItems.where(items.contains)) {
        expect(items.contains(tree[item]), isTrue);
      }
    });

    test('should throw when item is not found', () {
      expect(() => tree[absentItem], throwsStateError);
    });

    test('should find an item closest to argument', () {
      tree.removeAll(otherItems);
      final items = tree.depthFirstInOrderTraversalKeys.toList();
      for (final other in otherItems) {
        final small =
            items.lastWhere((item) => item < other, orElse: getBigItem);
        final large =
            items.firstWhere((item) => item > other, orElse: getBigItem);
        final diff = min((other - small).abs(), (other - large).abs());
        final target = tree.getClosestTo(other).key;
        expect((other - target).abs(), diff);
      }
    });
  });
}
