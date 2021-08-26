import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';

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
      final items = List.generate(1000, (_) => random.nextInt(1000));
      final itemsCopy = items.toList();
      expect(items..mergeSort(compareInt), itemsCopy..sort(compareInt));
    });
  });

  group('MergeSort.execute', () {
    test('should return new list', () {
      final items = List.generate(10, (_) => random.nextInt(1000));
      expect(MergeSort.execute(items, compareInt), isNot(equals(items)));
    });
  });
}
