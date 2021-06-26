import 'dart:math';

import 'package:dsalg/trees.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';

void main() {
  group('BinarySearchTree', () {
    const absentItem = 1000;
    final random = Random();
    final emptyTree = BinarySearchTree<int>(compareNum);
    var items = <int>[];
    var otherItems = <int>[];
    var tree = BinarySearchTree<int>(compareNum);

    setUp(() {
      final firstItems = List.generate(500, (_) => random.nextInt(absentItem));
      tree = BinarySearchTree(compareNum, firstItems);
      final secondItems = List.generate(500, (_) => random.nextInt(absentItem))
        ..forEach(tree.insert);
      items = {...firstItems, ...secondItems}.toList();
      otherItems = List.generate(100, (_) => random.nextInt(absentItem))
        ..add(absentItem);
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

    test('should remove nodes preserving search structure', () {
      otherItems.forEach(tree.remove);
      expect(
        tree.depthFirstInOrderTraversal,
        items
          ..sort(compareNum)
          ..removeWhere(otherItems.contains),
      );
    });
  });
}
