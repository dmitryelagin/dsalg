import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';
import '../utils/data_utils.dart';

void main() {
  final random = Random();

  group('BinarySearch', () {
    test('should find index in random list', () {
      final items = random.nextIntList(1000, 1000)..sort(IntComparator());
      final target = items[random.nextInt(1000)];
      expect(items[items.binarySearch(target.compareTo)], target);
    });

    test('should find index in random list using previous neighbour', () {
      final items = random.nextIntList(1000, 100)..sort(IntComparator());
      final index = random.nextInt(900) + 100;
      final target = items[index], previousTarget = items[index - 1];
      final targetIndex = items.relativeBinarySearch((item, getPrevious) {
        if (item == target && previousTarget == (getPrevious() ?? 0)) return 0;
        return target.compareTo(item);
      });
      expect(items[targetIndex], target);
    });

    test('should provide correct previous item in the end of a search', () {
      late int? previous;
      const [0, 1, 2].relativeBinarySearch((item, getPrevious) {
        previous = getPrevious();
        return -1;
      });
      expect(previous, isNull);
      const [0, 1, 2].relativeBinarySearch((item, getPrevious) {
        previous = getPrevious();
        return 1;
      });
      expect(previous, 1);
    });

    test('should return negative when item is not found', () {
      expect(const [0].binarySearch(1.compareTo), -1);
    });

    test('should return negative when empty', () {
      expect(const <int>[].binarySearch(1.compareTo), -1);
    });
  });
}
