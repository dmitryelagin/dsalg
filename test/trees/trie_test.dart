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
      tree.add('first', 0);
      expect(() => tree['second'], throwsStateError);
      expect(tree.containsKey('first'), isTrue);
      expect(tree.containsKey('second'), isFalse);
    });
  });
}
