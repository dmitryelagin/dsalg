import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';

void main() {
  final random = Random();

  group('Stack', () {
    test('should insert and extract items in correct order', () {
      final firstItems = random.nextIntList(500, 1000);
      final stack = Stack(firstItems);
      final secondItems = random.nextIntList(500, 1000)..forEach(stack.insert);
      final items = [...firstItems, ...secondItems];
      final extractedItems = <int>[];
      while (stack.isNotEmpty) {
        extractedItems.add(stack.extract());
      }
      expect(extractedItems, items.reversed);
    });

    test('should throw when nothing to extract', () {
      final stack = Stack<int>();
      expect(stack.extract, throwsStateError);
    });

    test('should return all inserted items reversed', () {
      final stack = Stack<int>();
      final items = random.nextIntList(100, 1000)..forEach(stack.insert);
      expect(stack.items, items.reversed);
    });

    test('should become empty after clear', () {
      final stack = Stack(random.nextIntList(50, 100))..clear();
      expect(stack.isEmpty, isTrue);
      expect(stack.isNotEmpty, isFalse);
      expect(stack.length, 0);
      expect(stack.items, isEmpty);
      expect(stack.extract, throwsStateError);
    });
  });
}
