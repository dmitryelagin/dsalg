import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../../utils/data_utils.dart';

void main() {
  // testBaseComparator(<T>(compare) => Comparator(compare));
}

void testBaseComparator(
  Comparator<T> Function<T>(int Function(T, T)) createComparator,
) {
  const absentItem = 1000;
  final random = Random();
  var compare = createComparator<int>((a, b) => a - b);
  var firstItems = <int>[], secondItems = <int>[];

  setUp(() {
    compare = createComparator((a, b) => a - b);
    firstItems = random.nextIntList(100, absentItem);
    secondItems = random.nextIntList(100, absentItem);
  });

  test('should return comparision result', () {
    for (var i = 0; i < firstItems.length; i += 1) {
      final first = firstItems[i], second = secondItems[i];
      expect(compare(first, second), first - second);
    }
  });

  test('should return inverted comparision result after switch', () {
    compare.invert();
    for (var i = 0; i < firstItems.length; i += 1) {
      final first = firstItems[i], second = secondItems[i];
      expect(compare(first, second), second - first);
    }
  });

  test('should return proper boolean result of comparision', () {
    for (var i = 0; i < firstItems.length; i += 1) {
      final first = firstItems[i], second = secondItems[i];
      expect(compare.areEqual(first, second), first == second);
      expect(compare.areNotEqual(first, second), first != second);
    }
  });
}
