import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';

void main() {
  group('LinkedList', () {
    const absentItem = 1000;
    final random = Random();
    var firstItems = <int>[], secondItems = <int>[];
    var thirdItems = <int>[], fourthItems = <int>[];
    var items = <int>[], list = LinkedList<int>();

    setUp(() {
      firstItems = createIntList(500, absentItem);
      list = LinkedList(firstItems);
      secondItems = createIntList(500, absentItem)..forEach(list.addLast);
      thirdItems = createIntList(500, absentItem)..forEach(list.addFirst);
      fourthItems = createIntList(500, absentItem);
      for (var i = 0; i < fourthItems.length; i += 1) {
        list.add(thirdItems.length + i, fourthItems[i]);
      }
      items = [
        ...thirdItems.reversed,
        ...fourthItems,
        ...firstItems,
        ...secondItems,
      ];
    });

    test('should preserve items in correct insertion order', () {
      expect(list.toIterable(), items);
    });

    test('should preserve items properly after deletions', () {
      for (var i = 0; i < fourthItems.length; i += 1) {
        list.remove(thirdItems.length);
      }
      for (var i = 0; i < thirdItems.length; i += 1) {
        list
          ..removeFirst()
          ..removeLast();
      }
      expect(list.toIterable(), firstItems);
    });

    test('should get correct items', () {
      for (var i = 0; i < 1000; i += 1) {
        final index = random.nextInt(absentItem);
        expect(list[index], items[index]);
      }
    });

    test('should set items correctly', () {
      for (var i = 0; i < 1000; i += 1) {
        final index = random.nextInt(list.length);
        final item = random.nextInt(absentItem);
        list[index] = items[index] = item;
      }
      expect(list.toIterable(), items);
    });

    test('should have correct length', () {
      final firstItems = createIntList(100 + random.nextInt(500), absentItem);
      final secondItems = createIntList(100 + random.nextInt(500), absentItem);
      list = LinkedList(firstItems);
      secondItems.forEach(list.addLast);
      final removedAmount = random.nextInt(200);
      for (var i = 0; i < removedAmount; i += 1) {
        list.removeFirst();
      }
      expect(
        list.length,
        firstItems.length + secondItems.length - removedAmount,
      );
    });

    test('should iterate through all list items', () {
      list.forEach((item) {
        expect(item, items.first);
        items.removeAt(0);
      });
    });
  });
}
