import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';
import '../utils/data_utils.dart';

void main() {
  final random = Random();
  var compareInt = IntComparator();

  setUp(() {
    compareInt = IntComparator();
  });

  group('MergeSort', () {
    test('should not fail on empty lists', () {
      final emptyList = <int>[];
      expect(emptyList..mergeSort(compareInt), emptyList);
    });

    test('should sort random lists', () {
      final items = random.nextIntList(1000, 1000);
      final itemsCopy = items.toList();
      expect(items..mergeSort(compareInt), itemsCopy..sort(compareInt));
    });
  });

  group('MergeSort.execute', () {
    test('should return new list', () {
      final items = random.nextIntList(10, 1000);
      expect(MergeSort.execute(items, compareInt), isNot(equals(items)));
    });
  });
}
