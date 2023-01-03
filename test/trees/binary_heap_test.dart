import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';
import '../utils/data_utils.dart';

void main() {
  const absentItem = 1000, itemsAmount = 500;
  final random = Random();

  group('BinaryHeap', () {
    late IntComparator compareInt;
    late List<int> firstItems, secondItems;
    late BinaryHeap<int> heap;

    setUp(() {
      compareInt = IntComparator();
      firstItems = random.nextIntList(itemsAmount, absentItem);
      secondItems = random.nextIntList(itemsAmount, absentItem);
      heap = BinaryHeap(compareInt.call, firstItems);
    });

    test('should insert and extract items in correct order', () {
      heap.insertAll(secondItems);
      final extractedItems = heap.extractAll();
      final items = [...firstItems, ...secondItems]..sort(compareInt.call);
      expect(extractedItems, items.reversed);
    });

    test('should throw when nothing to extract', () {
      final heap = BinaryHeap<int>(compareInt.call);
      expect(heap.extract, throwsStateError);
    });
  });
}
