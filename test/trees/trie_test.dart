import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';

void main() {
  const absentItem = 1000, itemsAmount = 10;
  final random = Random();

  group('Trie', () {
    var tree = Trie<String, int>((key) => key.runes.iterator);
    var firstData = <String, int>{}, secondData = <String, int>{};

    final cyclicalTraversalHierarchy = {
      for (var i = 0; i < 4; i += 1)
        for (var j = 0; j < 4; j += 1)
          for (var k = 0; k < 4; k += 1) [i, j, k]: '$i$j$k',
    };

    setUp(() {
      firstData = Map.fromIterables(
        random.nextStringList(itemsAmount, 10, 20),
        random.nextIntList(itemsAmount, absentItem),
      );
      secondData = Map.fromIterables(
        random.nextStringList(itemsAmount, 10, 20),
        random.nextIntList(itemsAmount, absentItem),
      );
      tree = Trie((key) => key.runes.iterator);
    });

    test('should properly add items and remove items', () {
      for (final key in firstData.keys) {
        tree.add(key, firstData[key]!);
      }
      tree.addAll(secondData);
      final result = tree.removeAll(firstData.keys.followedBy(secondData.keys));
      expect(result, firstData.values.followedBy(secondData.values));
    });

    test('should have valid empty or not empty state', () {
      expect(tree.isEmpty, isTrue);
      expect(tree.isNotEmpty, isFalse);
      tree.addAll({...firstData, ...secondData});
      expect(tree.isEmpty, isFalse);
      expect(tree.isNotEmpty, isTrue);
      tree.removeAll(firstData.keys.followedBy(secondData.keys));
      expect(tree.isEmpty, isTrue);
      expect(tree.isNotEmpty, isFalse);
    });

    test('should properly read items', () {
      tree.addAll({...firstData, ...secondData});
      for (final key in firstData.keys) {
        expect(tree.containsKey(key), isTrue);
        expect(tree[key], firstData[key]);
      }
      for (final key in secondData.keys) {
        expect(tree.containsKey(key), isTrue);
        expect(tree[key], secondData[key]);
      }
    });

    test('should throw on reading of an absent key', () {
      tree
        ..add('first', 0)
        ..add('first_next_last', 1);
      expect(tree.containsKey('first'), isTrue);
      expect(tree.containsKey('first_next_last'), isTrue);
      expect(tree.containsKey('first_next'), isFalse);
      expect(() => tree['first_next'], throwsStateError);
      expect(tree.containsKey('second'), isFalse);
      expect(() => tree['second'], throwsStateError);
    });

    test('should allow cyclical traversal through the hierarchy', () {
      final tree = Trie<Iterable<int>, Object>((key) => key.iterator)
        ..addAll(cyclicalTraversalHierarchy);
      final values = random.nextIntList(35, 4);
      expect(
        tree.getCyclically(values.iterator).join(),
        values.take(33).map((value) => value.toString()).join(),
      );
      expect(
        tree.getCyclically(values.take(33).iterator).join(),
        values.take(33).map((value) => value.toString()).join(),
      );
    });

    test('should fail cyclical traversal if next symbol is not a child', () {
      final tree = Trie<Iterable<int>, Object>((key) => key.iterator)
        ..addAll(cyclicalTraversalHierarchy);
      final values = random.nextIntList(22, 4)
        ..add(4)
        ..addAll(random.nextIntList(22, 4));
      expect(
        () => tree.getCyclically(values.iterator),
        throwsStateError,
      );
    });
  });
}
