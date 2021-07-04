import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';

void main() {
  group('InsertionSort', () {
    test('should not fail on empty lists', () {
      final emptyList = <int>[];
      expect(emptyList..insertionSort(compareInt), emptyList);
    });

    test('should sort random lists', () {
      final random = Random();
      final items = List.generate(1000, (_) => random.nextInt(1000));
      final itemsCopy = List.of(items);
      expect(items..insertionSort(compareInt), itemsCopy..sort(compareInt));
    });
  });
}
