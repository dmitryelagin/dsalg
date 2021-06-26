import 'dart:math';

import 'package:dsalg/sorts.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';

void main() {
  group('MergeSort', () {
    test('should not fail on empty lists', () {
      final emptyList = <int>[];
      expect(emptyList..mergeSort(compareInt), emptyList);
    });

    test('should sort random lists', () {
      final random = Random();
      final items = List.generate(1000, (_) => random.nextInt(1000));
      final itemsCopy = List.of(items);
      expect(items..mergeSort(compareInt), itemsCopy..sort(compareInt));
    });
  });

  group('MergeSort.execute', () {
    test('should return new list', () {
      final random = Random();
      final items = List.generate(10, (_) => random.nextInt(1000));
      expect(MergeSort.execute(items, compareInt), isNot(equals(items)));
    });
  });
}
