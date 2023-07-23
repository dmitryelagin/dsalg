import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';
import '../utils/iterable_utils.dart';
import '../utils/matchers.dart';
import '../utils/test_utils.dart';

void main() {
  final random = Random();

  group('Bisect', () {
    test('should split list in two with equal masses', () {
      repeat(times: 100, () {
        final items = random.nextIntList(100, 500, 1);
        Iterable<int> first = [], second = [];
        Iterable<int> expectedFirst = [], expectedSecond = [];
        num sumDelta = double.infinity;
        for (var i = 1; i < items.length - 1; i += 1) {
          first = items.getRange(0, i);
          second = items.getRange(i, items.length);
          final currentSumDelta = (first.sum - second.sum).abs();
          if (currentSumDelta < sumDelta) {
            expectedFirst = first;
            expectedSecond = second;
            sumDelta = currentSumDelta;
          }
        }
        final (left, right) = items.bisectByMass();
        expect(left, expectedFirst);
        expect(right, expectedSecond);
      });
    });

    test('should split list by masses when masses are external', () {
      repeat(times: 100, () {
        final keys = random.nextStringList(20, 10, 20);
        final values = random.nextIntList(keys.length, 100, 1);
        Iterable<int> first = [], second = [];
        Iterable<String> expectedFirst = [], expectedSecond = [];
        num sumDelta = double.infinity;
        for (var i = 1; i < keys.length - 1; i += 1) {
          first = values.getRange(0, i);
          second = values.getRange(i, keys.length);
          final currentSumDelta = (first.sum - second.sum).abs();
          if (currentSumDelta < sumDelta) {
            expectedFirst = keys.getRange(0, i);
            expectedSecond = keys.getRange(i, keys.length);
            sumDelta = currentSumDelta;
          }
        }
        final items = Map.fromIterables(keys, values);
        final (left, right) = keys.bisectByMass((key) => items[key]!);
        expect(left, expectedFirst);
        expect(right, expectedSecond);
      });
    });

    test('should throw when there are less than two items', () {
      expect(() => const <int>[].bisectByMass(), throwsAssertionError);
      expect(() => const [0].bisectByMass(), throwsAssertionError);
      expect(const [1, 2].bisectByMass(), anything);
    });

    test('should throw when mass is zero or is negative', () {
      expect(() => const [1, 2, 0, 4].bisectByMass(), throwsAssertionError);
      expect(() => const [1, 2, -1, 4].bisectByMass(), throwsAssertionError);
      expect(const [1, 2, 3, 4].bisectByMass(), anything);
    });
  });
}
