import 'dart:math';

import 'package:dsalg/sorts.dart';
import 'package:test/test.dart';

import 'utils/compare_utils.dart';

void main() {
  group('InsertionSort', () {
    test('should not fail on empty lists', () {
      const emptyList = <int>[];
      expect(emptyList..insertionSort(compareNum), emptyList);
    });

    test('should sort random lists', () {
      final random = Random();
      final list = List.generate(1000, (_) => random.nextInt(1000));
      final listCopy = List.of(list);
      expect(list..insertionSort(compareNum), listCopy..sort(compareNum));
    });
  });
}
