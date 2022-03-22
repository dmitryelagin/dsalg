import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';
import '../utils/data_utils.dart';

void main() {
  const absentItem = 1000, itemsAmount = 500;
  final random = Random();

  group('BinaryHeap', () {
    var compareInt = IntComparator();
    var heap = BinaryHeap<int>(compareInt);
    var firstItems = <int>[], secondItems = <int>[];

    setUp(() {
      compareInt = IntComparator();
      firstItems = random.nextIntList(itemsAmount, absentItem);
      secondItems = random.nextIntList(itemsAmount, absentItem);
      heap = BinaryHeap(compareInt, firstItems);
    });

    test('should insert and extract items in correct order', () {
      heap.insertAll(secondItems);
      final extractedItems = heap.extractAll();
      final items = [...firstItems, ...secondItems]..sort(compareInt);
      expect(extractedItems, items.reversed);
    });

    test('should throw when nothing to extract', () {
      final heap = BinaryHeap<int>(compareInt);
      expect(heap.extract, throwsStateError);
    });
  });
}
