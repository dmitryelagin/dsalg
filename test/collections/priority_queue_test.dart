import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';

void main() {
  group('PriorityQueue', () {
    test('should insert and extract items in correct order', () {
      final random = Random();
      final firstItems = List.generate(500, (_) => random.nextInt(1000));
      final queue = PriorityQueue(compareInt, firstItems);
      final secondItems = List.generate(500, (_) => random.nextInt(1000))
        ..forEach(queue.insert);
      final items = [...firstItems, ...secondItems]..sort(compareInt);
      final extractedItems = <int>[];
      while (queue.isNotEmpty) {
        extractedItems.add(queue.extract());
      }
      expect(extractedItems, items.reversed);
    });

    test('should throw when nothing to extract', () {
      final queue = PriorityQueue<int>(compareInt);
      expect(queue.extract, throwsStateError);
    });
  });
}
