import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';
import '../utils/test_utils.dart';

void main() {
  group('LinkedList', () {
    const absentItem = 1000;
    final random = Random();
    var firstItems = <int>[], secondItems = <int>[];
    var thirdItems = <int>[], fourthItems = <int>[];
    var items = <int>[], list = LinkedList<int>();

    setUp(() {
      firstItems = random.nextIntList(500, absentItem);
      list = LinkedList(firstItems);
      secondItems = random.nextIntList(500, absentItem)..forEach(list.addLast);
      thirdItems = random.nextIntList(500, absentItem)..forEach(list.addFirst);
      fourthItems = random.nextIntList(500, absentItem);
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
      repeat(times: fourthItems.length, () {
        list.remove(thirdItems.length);
      });
      repeat(times: thirdItems.length, () {
        list
          ..removeFirst()
          ..removeLast();
      });
      expect(list.toIterable(), firstItems);
    });

    test('should get correct items', () {
      repeat(times: 1000, () {
        final index = random.nextInt(absentItem);
        expect(list[index], items[index]);
      });
    });

    test('should set items correctly', () {
      repeat(times: 1000, () {
        final index = random.nextInt(list.length);
        final item = random.nextInt(absentItem);
        list[index] = items[index] = item;
      });
      expect(list.toIterable(), items);
    });

    test('should have correct length', () {
      final firstItems =
          random.nextIntList(100 + random.nextInt(500), absentItem);
      final secondItems =
          random.nextIntList(100 + random.nextInt(500), absentItem);
      list = LinkedList(firstItems);
      secondItems.forEach(list.addLast);
      final removedAmount = random.nextInt(200);
      repeat(times: removedAmount, () {
        list.removeFirst();
      });
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
