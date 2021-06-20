import 'dart:math';

import 'package:dsalg/collections.dart';
import 'package:test/test.dart';

void main() {
  group('Queue', () {
    test('should insert and extract items in correct order', () {
      final random = Random();
      final firstItems = List.generate(500, (_) => random.nextInt(1000));
      final queue = Queue(firstItems);
      final secondItems = List.generate(500, (_) => random.nextInt(1000))
        ..forEach(queue.insert);
      final items = [...firstItems, ...secondItems];
      final extractedItems = <int>[];
      while (queue.isNotEmpty) {
        extractedItems.add(queue.extract());
      }
      expect(extractedItems, items);
    });

    test('should throw when nothing to extract', () {
      final queue = Queue<int>();
      expect(queue.extract, throwsStateError);
    });
  });
}
