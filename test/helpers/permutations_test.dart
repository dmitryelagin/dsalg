import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';

void main() {
  group('Permutations', () {
    const absentItem = 1000;
    final random = Random();
    var itemsAmount = 0;

    setUp(() {
      itemsAmount = random.nextInt(4) + 2;
    });

    test('should return all permutations of non-repeated items', () {
      final items = createIntSet(itemsAmount, absentItem);
      final permutations = items.permutations;
      expect(permutations.length, items.length.factorial.toInt());
      for (final permutation in permutations) {
        expect(permutation.length, items.length);
        expect(permutation, containsAll(items));
        expect(permutation, isNot(orderedEquals(items.skip(1))));
      }
    });

    test('should not fail when list has repeated items', () {
      final items = createIntSet(itemsAmount ~/ 2, absentItem);
      items.addAll(items.toList());
      final lessItems = items.toSet().toList();
      final permutations = items.permutations;
      final lessPermutations = lessItems.permutations;
      for (final permutation in permutations) {
        expect(permutation.length, items.length);
        expect(
          lessPermutations
              .toList()
              .toString()
              .contains(permutation.toSet().toList().toString()),
          isTrue,
        );
      }
    });

    test('should not fail on empty lists', () {
      final items = <int>[];
      final permutations = items.permutations;
      expect(permutations.length, items.length.factorial.toInt());
    });

    test('should not mutate original list', () {
      final items = createIntSet(itemsAmount, absentItem);
      final permutation = items.permutations.iterator;
      while (permutation.moveNext()) {
        expect(permutation.current, containsAll(items));
      }
    });
  });
}
