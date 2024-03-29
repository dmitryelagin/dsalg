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

  group('Treap', () {
    testBaseBinarySearchTree(<K, V>(compare, [entries]) {
      return Treap(compare, entries ?? const {});
    });
  });

  group('Treap', () {
    late IntComparator compareInt;
    late List<int> items, otherItems;
    late Treap<int, int> tree, worstTree, emptyTree;

    setUp(() {
      compareInt = IntComparator();
      emptyTree = Treap(compareInt);
      final firstItems = random.nextIntMap(500, absentItem);
      tree = Treap(compareInt, firstItems);
      final secondItems = random.nextIntMap(500, absentItem);
      tree.addAll(secondItems);
      items = {...firstItems.keys, ...secondItems.keys}.toList();
      otherItems = random.nextIntList(200, absentItem)..add(absentItem);
      final worstItems = items.copySort(compareInt.call);
      worstTree = Treap(compareInt, worstItems.toMap());
    });

    test('should be able to traverse depth first with decent performance', () {
      _checkDepthFirstTraversalIndirectly(
        worstTree.depthFirstPreOrderTraversalKeys.toList(),
      );
      _checkDepthFirstTraversalIndirectly(
        worstTree.depthFirstPostOrderTraversalKeys.toList(),
      );
    });

    test('should have decent performance after nodes change', () {
      tree.removeAll(otherItems);
      _checkDepthFirstTraversalIndirectly(
        tree.depthFirstPreOrderTraversalKeys.toList(),
      );
      _checkDepthFirstTraversalIndirectly(
        tree.depthFirstPostOrderTraversalKeys.toList(),
      );
    });

    test('should be properly splitted by existing item', () {
      items.sort(compareInt.call);
      final index = random.nextInt(items.length), item = items[index];
      final first = items.sublist(0, index), second = items.sublist(index + 1);
      final other = tree.split(item);
      expect(
        tree.depthFirstInOrderTraversalEntries.toList().toString(),
        first.toMapEntries().toList().toString(),
      );
      expect(
        other.depthFirstInOrderTraversalEntries.toList().toString(),
        second.toMapEntries().toList().toString(),
      );
    });

    test('should be properly splitted by non-existing item', () {
      items.sort(compareInt.call);
      final index = random.nextInt(items.length), item = items[index];
      items.removeAt(index);
      final first = items.sublist(0, index), second = items.sublist(index);
      final other = tree.split(item);
      expect(
        tree.depthFirstInOrderTraversalEntries.toList().toString(),
        first.toMapEntries().toList().toString(),
      );
      expect(
        other.depthFirstInOrderTraversalEntries.toList().toString(),
        second.toMapEntries().toList().toString(),
      );
    });

    test('should be less than other tree after split', () {
      final index = random.nextInt(items.length - 2) + 1;
      final other = tree.split(items[index]);
      expect(tree.max.key, lessThan(other.min.key));
    });

    test('should be splitted if empty', () {
      final other = emptyTree.split(absentItem);
      expect(emptyTree.isEmpty, isTrue);
      expect(other, isNotNull);
      expect(other.isEmpty, isTrue);
    });

    test('should be properly merged after split', () {
      items.sort(compareInt.call);
      final index = random.nextInt(items.length), item = items[index];
      final other = tree.split(item);
      tree.union(other);
      items.remove(item);
      expect(
        tree.depthFirstInOrderTraversalEntries.toList().toString(),
        items.toMapEntries().toList().toString(),
      );
      expect(other.isEmpty, isTrue);
    });

    test('should union properly', () {
      const margin = absentItem ~/ 3;
      final firstItems = random.nextIntList(500, absentItem - margin);
      final secondItems = random.nextIntList(500, absentItem - margin, margin);
      final items = {...firstItems, ...secondItems}.toList();
      final tree = Treap<int, int>(compareInt, firstItems.toMap());
      final unionTree = Treap<int, int>(compareInt, secondItems.toMap())
        ..union(tree);
      items.sort(compareInt.call);
      expect(
        unionTree.depthFirstInOrderTraversalEntries.toList().toString(),
        items.toMapEntries().toList().toString(),
      );
      expect(tree.isEmpty, isTrue);
      _checkDepthFirstTraversalIndirectly(
        unionTree.depthFirstPreOrderTraversalKeys.toList(),
      );
      _checkDepthFirstTraversalIndirectly(
        unionTree.depthFirstPostOrderTraversalKeys.toList(),
      );
    });

    test('should not fail with empty cases', () {
      var unionTree = Treap<int, int>(compareInt)
        ..union(Treap<int, int>(compareInt));
      expect(unionTree.depthFirstInOrderTraversalEntries, isEmpty);
      unionTree = tree..union(emptyTree);
      expect(
        unionTree.depthFirstInOrderTraversalEntries.toList().toString(),
        items.copySort(compareInt.call).toMapEntries().toList().toString(),
      );
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
