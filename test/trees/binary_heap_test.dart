import 'dart:math';

import 'package:dsalg/trees.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';

void main() {
  group('BinaryHeap', () {
    final random = Random();

    var items = <int>[];
    var heap = BinaryHeap<int>(compareNum);

    setUp(() {
      final firstItems = List.generate(500, (_) => random.nextInt(1000));
      heap = BinaryHeap(compareNum, firstItems);
      final secondItems = List.generate(500, (_) => random.nextInt(1000))
        ..forEach(heap.insert);
      items = [...firstItems, ...secondItems];
    });

    test('should insert and extract items in correct order', () {
      final extractedItems = <int>[];
      while (heap.isNotEmpty) {
        extractedItems.add(heap.extract());
      }
      items.sort(compareNum);
      expect(extractedItems, items.reversed);
    });

    test('should throw when nothing to extract', () {
      final heap = BinaryHeap<int>(compareNum);
      expect(heap.extract, throwsStateError);
    });
  });
}
