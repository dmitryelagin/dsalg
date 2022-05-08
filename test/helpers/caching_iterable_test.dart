import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

void main() {
  final random = Random();

  group('CachingIterable', () {
    late CachingIterable<int> iterable;
    late int count;

    setUp(() {
      count = 0;
      iterable = CachingIterable(random.nextInt(100) + 100, (_) {
        count += 1;
        return random.nextInt(20);
      });
    });

    test('should implement iterable interface', () {
      expect(iterable, const TypeMatcher<Iterable<Object>>());
    });

    test('should return the same values every time after first call', () {
      final items = iterable.toList();
      expect(iterable.toList(), items);
      expect(iterable.length, count);
    });

    test('should generate items only on call', () {
      final firstAmount = random.nextInt(50) + 10;
      final firstItems = iterable.take(firstAmount).toList();
      expect(firstItems.length, count);
      final firstItemsAgain = iterable.take(firstAmount).toList();
      expect(firstItems, firstItemsAgain);
      expect(firstItems.length, count);
      final secondItems = iterable.skip(firstAmount).toList();
      expect(firstItems.length + secondItems.length, count);
      expect(iterable.toList(), firstItems.followedBy(secondItems));
    });

    test('should generate items from start until selected index', () {
      final index = random.nextInt(50) + 10;
      iterable.elementAt(index);
      expect(index + 1, count);
      iterable.take(index).toList();
      expect(index + 1, count);
    });
  });
}
