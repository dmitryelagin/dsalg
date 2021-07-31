import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';

void main() {
  int getKey(int item) => item;
  final random = Random();

  group('CountingSort', () {
    test('should not fail on empty lists', () {
      final emptyList = <int>[];
      expect(emptyList..countingSort(getKey), emptyList);
    });

    test('should sort random lists', () {
      final items = List.generate(1000, (_) => random.nextInt(1000));
      final itemsCopy = List.of(items);
      expect(items..countingSort(getKey), itemsCopy..sort(IntComparator()));
    });
  });

  group('CountingSort.execute', () {
    test('should return new list', () {
      final items = List.generate(10, (_) => random.nextInt(1000));
      expect(CountingSort.execute(items, getKey), isNot(equals(items)));
    });
  });
}
