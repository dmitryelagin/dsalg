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

  group('HeapSort', () {
    test('should not fail on empty lists', () {
      final emptyList = <int>[];
      expect(emptyList..heapSort(compareInt), emptyList);
    });

    test('should sort random lists', () {
      final items = random.nextIntList(1000, 1000);
      final itemsCopy = items.toList();
      expect(items..heapSort(compareInt), itemsCopy..sort(compareInt));
    });
  });
}
