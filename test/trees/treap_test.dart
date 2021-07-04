import 'dart:math';

import 'package:dsalg/trees.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';

void main() {
  group('Treap', () {
    const absentItem = 1000;
    final random = Random();
    final emptyTree = Treap(compareInt);
    var items = <int>[];
    var worstItems = <int>[];
    var otherItems = <int>[];
    var tree = Treap(compareInt);
    var worstTree = Treap(compareInt);

    setUp(() {
      final firstItems = List.generate(500, (_) => random.nextInt(absentItem));
      tree = Treap(compareInt, firstItems);
      final secondItems = List.generate(500, (_) => random.nextInt(absentItem));
      tree.insertAll(secondItems);
      items = {...firstItems, ...secondItems}.toList();
      worstItems = List.of(items)..sort(compareInt);
      worstTree = Treap(compareInt, worstItems);
      otherItems = List.generate(200, (_) => random.nextInt(absentItem))
        ..add(absentItem);
    });

    test('should be able to traverse depth first in order', () {
      expect(tree.depthFirstInOrderTraversal, items..sort(compareInt));
    });

    test('should be able to traverse depth first with decent performance', () {
      _checkDepthFirstTraversalIndirectly(
        worstTree.depthFirstPreOrderTraversal.toList(),
      );
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

    test('should have decent performance after nodes change', () {
      tree.removeAll(otherItems);
      _checkDepthFirstTraversalIndirectly(
        tree.depthFirstPreOrderTraversal.toList(),
      );
      _checkDepthFirstTraversalIndirectly(
        tree.depthFirstPostOrderTraversal.toList(),
      );
    });

    test('should be properly splitted by existing item', () {
      items.sort(compareInt);
      final index = random.nextInt(items.length), item = items[index];
      final first = items.sublist(0, index), second = items.sublist(index + 1);
      final trees = tree.split(item);
      expect(trees.first.depthFirstInOrderTraversal, first);
      expect(trees.last.depthFirstInOrderTraversal, second);
      expect(tree.isEmpty, isTrue);
    });

    test('should be properly splitted by non-existing item', () {
      items.sort(compareInt);
      final index = random.nextInt(items.length), item = items[index];
      items.removeAt(index);
      final first = items.sublist(0, index), second = items.sublist(index);
      final trees = tree.split(item);
      expect(trees.first.depthFirstInOrderTraversal, first);
      expect(trees.last.depthFirstInOrderTraversal, second);
      expect(tree.isEmpty, isTrue);
    });

    test('should be splitted if empty', () {
      final trees = emptyTree.split(absentItem);
      expect(trees.first, isNotNull);
      expect(trees.first.isEmpty, isTrue);
      expect(trees.last, isNotNull);
      expect(trees.last.isEmpty, isTrue);
    });

    test('should be properly merged after split', () {
      items.sort(compareInt);
      final index = random.nextInt(items.length), item = items[index];
      final trees = tree.split(item);
      final unionTree = Treap.union(trees.first, trees.last);
      expect(unionTree.depthFirstInOrderTraversal, items..remove(item));
      expect(trees.first.isEmpty, isTrue);
      expect(trees.last.isEmpty, isTrue);
    });

    test('should be properly union', () {
      const margin = absentItem ~/ 3;
      final firstItems = List.generate(500, (_) {
        return random.nextInt(absentItem - margin);
      });
      final secondItems = List.generate(500, (_) {
        return random.nextInt(absentItem - margin) + margin;
      });
      final items = {...firstItems, ...secondItems}.toList();
      final firstTree = Treap(compareInt, firstItems);
      final secondTree = Treap(compareInt, secondItems);
      final unionTree = Treap.union(secondTree, firstTree);
      expect(unionTree.depthFirstInOrderTraversal, items..sort(compareInt));
      expect(firstTree.isEmpty, isTrue);
      expect(secondTree.isEmpty, isTrue);
      _checkDepthFirstTraversalIndirectly(
        unionTree.depthFirstPreOrderTraversal.toList(),
      );
      _checkDepthFirstTraversalIndirectly(
        unionTree.depthFirstPostOrderTraversal.toList(),
      );
    });

    test('should not fail with empty cases', () {
      var unionTree = Treap.union(Treap(compareInt), Treap(compareInt));
      expect(unionTree.depthFirstInOrderTraversal, isEmpty);
      unionTree = Treap.union(tree, emptyTree);
      expect(unionTree.depthFirstInOrderTraversal, items..sort(compareInt));
    });
  });
}

void _checkDepthFirstTraversalIndirectly(List<int> traversal) {
  final worstHeight = traversal.length - 1;
  var increaseCount = 0, decreaseCount = 0;
  for (var i = 1; i < traversal.length; i += 1) {
    increaseCount = traversal[i] < traversal[i - 1] ? 0 : increaseCount + 1;
    decreaseCount = traversal[i] < traversal[i - 1] ? decreaseCount + 1 : 0;
    expect(increaseCount, lessThan(worstHeight));
    expect(decreaseCount, lessThan(worstHeight));
  }
}
