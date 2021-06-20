import 'dart:math';

import 'package:dsalg/trees.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';

void main() {
  group('BinaryHeap', () {
    test('should insert and extract items in correct order', () {
      final random = Random();
      final firstItems = List.generate(500, (_) => random.nextInt(1000));
      final heap = BinaryHeap(compareNum, firstItems);
      final secondItems = List.generate(500, (_) => random.nextInt(1000))
        ..forEach(heap.insert);
      final items = [...firstItems, ...secondItems]..sort(compareNum);
      final extractedItems = <int>[];
      while (heap.isNotEmpty) {
        extractedItems.add(heap.extract());
      }
      expect(extractedItems, items.reversed);
    });

    test('should throw when nothing to extract', () {
      final queue = BinaryHeap<int>(compareNum);
      expect(queue.extract, throwsStateError);
    });
  });
}
