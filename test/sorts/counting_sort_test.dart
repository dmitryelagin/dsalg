import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';
import '../utils/data_utils.dart';

void main() {
  int getKey(int item) => item;
  final random = Random();

  group('CountingSort', () {
    test('should not fail on empty lists', () {
      final emptyList = <int>[];
      expect(emptyList..countingSort(getKey), emptyList);
    });

    test('should sort random lists', () {
      final items = random.nextIntList(1000, 1000);
      final itemsCopy = items.toList();
      expect(
        items..countingSort(getKey),
        itemsCopy..sort(IntComparator().call),
      );
    });
  });

  group('CountingSort.execute', () {
    test('should return new list', () {
      final items = random.nextIntList(10, 1000);
      expect(CountingSort.execute(items, getKey), isNot(equals(items)));
    });
  });
}
