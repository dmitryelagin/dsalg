import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';

void main() {
  final random = Random();

  group('Queue', () {
    test('should insert and extract items in correct order', () {
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

    test('should return all inserted items', () {
      final queue = Queue<int>();
      final items = random.nextIntList(100, 1000)..forEach(queue.insert);
      expect(queue.items, items);
    });
  });
}
