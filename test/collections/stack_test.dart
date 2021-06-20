import 'dart:math';

import 'package:dsalg/collections.dart';
import 'package:test/test.dart';

void main() {
  group('Stack', () {
    test('should insert and extract items in correct order', () {
      final random = Random();
      final firstItems = List.generate(500, (_) => random.nextInt(1000));
      final stack = Stack(firstItems);
      final secondItems = List.generate(500, (_) => random.nextInt(1000))
        ..forEach(stack.insert);
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
  });
}
