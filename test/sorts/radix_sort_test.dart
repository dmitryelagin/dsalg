import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';
import '../utils/data_utils.dart';

void main() {
  int getKey(int item) => item;
  final random = Random();

  group('RadixSort', () {
    test('should not fail on empty lists', () {
      final emptyList = <int>[];
      expect(emptyList..radixSort(getKey), emptyList);
    });

    test('should sort random lists', () {
      final items = random.nextIntList(1000, 1000);
      final itemsCopy = items.toList();
      expect(items..radixSort(getKey), itemsCopy..sort(IntComparator()));
    });
  });

  group('RadixSort.execute', () {
    test('should return new list', () {
      final items = random.nextIntList(10, 1000);
      expect(RadixSort.execute(items, getKey), isNot(equals(items)));
    });
  });
}
