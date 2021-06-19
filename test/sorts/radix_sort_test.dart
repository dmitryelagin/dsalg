import 'dart:math';

import 'package:dsalg/sorts.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';

void main() {
  group('RadixSort', () {
    test('should not fail on empty lists', () {
      final emptyList = <int>[];
      expect(emptyList..radixSort(), emptyList);
    });

    test('should sort random lists', () {
      final random = Random();
      final items = List.generate(1000, (_) => random.nextInt(1000));
      final listCopy = List.of(items);
      expect(items..radixSort(), listCopy..sort(compareNum));
    });

    group('RadixSort.execute', () {
      test('should return new list', () {
        final random = Random();
        final items = List.generate(10, (_) => random.nextInt(1000));
        expect(RadixSort.execute(items), isNot(equals(items)));
      });
    });
  });
}
