import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../../utils/compare_utils.dart';
import '../../utils/data_utils.dart';
import '../../utils/int_utils.dart';
import '../../utils/iterable_utils.dart';

void main() {
  // testBaseBinarySearchTree(<K, V>(compare, [entries]) {
  //   return BinarySearchTree<K, V>(compare, entries ?? const {});
  // });
}

void testBaseBinarySearchTree(
  BaseBinarySearchTree<K, V> Function<K, V>(Comparator<K>, [Map<K, V>?])
      createTree,
) {
  int getBigItem() => 2000;
  const absentItem = 1000;
  final random = Random();
  var compareInt = IntComparator();
  var tree = createTree<int, int>(compareInt);
  final emptyTree = createTree<int, int>(compareInt);
  var items = <int>[], otherItems = <int>[];

  setUp(() {
    compareInt = IntComparator();
    final firstItems = random.nextIntMap(500, absentItem);
    tree = createTree(compareInt, firstItems);
    final secondItems = random.nextIntMap(500, absentItem);
    tree.addAll(secondItems);
    items = {...firstItems.keys, ...secondItems.keys}.toList();
    otherItems = random.nextIntList(200, absentItem)..add(absentItem);
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
      final small = items.lastWhere((item) => item < other, orElse: getBigItem);
      final large =
          items.firstWhere((item) => item > other, orElse: getBigItem);
      final diff = min((other - small).abs(), (other - large).abs());
      final target = tree.getClosestTo(other).key;
      expect((other - target).abs(), diff);
    }
  });

  test('should properly invert tree structure', () {
    final inOrder = tree.depthFirstInOrderTraversalKeys.toList();
    final preOrder = tree.depthFirstPreOrderTraversalKeys.toList();
    tree.invert();
    expect(tree.depthFirstInOrderTraversalKeys, inOrder.reversed);
    expect(tree.depthFirstPreOrderTraversalKeys.first, preOrder.first);
    expect(tree.depthFirstPreOrderTraversalKeys, isNot(preOrder.reversed));
  });
}
