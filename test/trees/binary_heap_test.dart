import 'dart:math';

import 'package:dsalg/trees.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';

void main() {
  group('BinaryHeap', () {
    const absentItem = 1000;
    final random = Random();
    var items = <int>[];
    var heap = BinaryHeap<int>(compareInt);

    setUp(() {
      final firstItems = List.generate(500, (_) => random.nextInt(absentItem));
      heap = BinaryHeap(compareInt, firstItems);
      final secondItems = List.generate(500, (_) => random.nextInt(absentItem))
        ..forEach(heap.insert);
      items = [...firstItems, ...secondItems];
    });

    test('should insert and extract items in correct order', () {
      final extractedItems = <int>[];
      while (heap.isNotEmpty) {
        extractedItems.add(heap.extract());
      }
      items.sort(compareInt);
      expect(extractedItems, items.reversed);
    });

    test('should throw when nothing to extract', () {
      final heap = BinaryHeap<int>(compareInt);
      expect(heap.extract, throwsStateError);
    });
  });
}
