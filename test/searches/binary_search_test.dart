import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';

void main() {
  final random = Random();

  group('BinarySearch', () {
    test('should find index in random list', () {
      final items = List.generate(1000, (_) => random.nextInt(1000))
        ..sort(IntComparator());
      final target = items[random.nextInt(1000)];
      expect(items[items.binarySearch(target.compareTo)], target);
    });

    test('should return negative when item is not found', () {
      final items = <int>[0];
      expect(items.binarySearch(1.compareTo), -1);
    });

    test('should return negative when empty', () {
      final items = <int>[];
      expect(items.binarySearch(1.compareTo), -1);
    });
  });
}
