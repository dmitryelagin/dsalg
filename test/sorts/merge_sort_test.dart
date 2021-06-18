import 'dart:math';

import 'package:dsalg/sorts.dart';
import 'package:test/test.dart';

import 'utils/compare_utils.dart';

void main() {
  group('MergeSort', () {
    test('should not fail on empty lists', () {
      const emptyList = <int>[];
      expect(emptyList..mergeSort(compareNum), emptyList);
    });

    test('should sort random lists', () {
      final random = Random();
      final list = List.generate(1000, (_) => random.nextInt(1000));
      final listCopy = List.of(list);
      expect(list..mergeSort(compareNum), listCopy..sort(compareNum));
    });
  });

  group('MergeSort.execute', () {
    test('should return new list', () {
      final random = Random();
      final list = List.generate(10, (_) => random.nextInt(1000));
      expect(MergeSort.execute(list, compareNum), isNot(equals(list)));
    });
  });
}
