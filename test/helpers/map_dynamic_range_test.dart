import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';
import '../utils/data_utils.dart';
import '../utils/iterable_utils.dart';
import '../utils/matchers.dart';

void main() {
  final random = Random();

  int Function(Iterable<num>) itemsAmount(num item) =>
      (list) => list.where((target) => target == item).length;

  group('MapDynamicRange', () {
    test('should handle standard cases', () {
      expect(
        const [1, 2, 3, 4].mapDynamicRange(-4, -1).roundTo(5),
        const [-4, -3, -2, -1],
      );
      expect(
        const [1, 2, 3, 4].mapDynamicRange(-8, -2).roundTo(5),
        const [-8, -6, -4, -2],
      );
      expect(
        const [1, 2, 3, 4].mapDynamicRange(-10, 8).roundTo(5),
        const [-10, -4, 2, 8],
      );
      expect(
        const [1.5, 3, 4.5, 6].mapDynamicRange(-10.5, 3).roundTo(5),
        const [-10.5, -6, -1.5, 3],
      );
      expect(
        const [9, 6, 3, 0].mapDynamicRange(2, 8).roundTo(5),
        const [8, 6, 4, 2],
      );
      expect(
        const [3, 6, 0, 9].mapDynamicRange(2, 8).roundTo(5),
        const [4, 6, 2, 8],
      );
      expect(
        const [6, 3].mapDynamicRange(2, 8).roundTo(5),
        const [8, 2],
      );
      expect(
        const [3, 3, 3].mapDynamicRange(2, 8).roundTo(5),
        const [2, 2, 2],
      );
      expect(
        const [3, 5, 7].mapDynamicRange(4, 4).roundTo(5),
        const [4, 4, 4],
      );
      expect(
        const [3].mapDynamicRange(2, 8).roundTo(5),
        const [2],
      );
      expect(
        const <num>[].mapDynamicRange(2, 8),
        const <num>[],
      );
    });

    test('should throw when min is greater than max', () {
      expect(() => const [1, 2, 3].mapDynamicRange(4, 3), throwsAssertionError);
    });

    test('should save the amount of edge values after mapping', () {
      final list = random.nextIntList(300, 100, 10);
      final actual = list.mapDynamicRange(2000, 3000);
      final listMinValue = list.minValue, listMaxValue = list.maxValue;
      final actualMinValue = actual.minValue, actualMaxValue = actual.maxValue;
      expect(
        itemsAmount(actualMinValue)(actual),
        itemsAmount(listMinValue)(list),
      );
      expect(
        itemsAmount(actualMaxValue)(actual),
        itemsAmount(listMaxValue)(list),
      );
    });

    test('should have proportional items with proportional limits', () {
      final list = random.nextIntList(300, 290, 210)..addAll([200, 300]);
      final actual = list.mapDynamicRange(2000, 3000).toList();
      for (var i = 0; i < list.length; i += 1) {
        expect(actual[i] / 10, list[i]);
      }
    });

    test('should map values to full 8-bit range', () {
      final values = [
        ...List.filled(10, 10),
        ...random.nextIntList(10, 25, 15),
        ...List.filled(10, 30),
      ]..shuffle();
      final actual = values.mapDynamicRangeToUint8List();
      expect(itemsAmount(0)(actual), 10);
      expect(itemsAmount(255)(actual), 10);
    });
  });

  group('Map2DDynamicRange', () {
    test('should handle standard cases', () {
      expect(
        const [
          [1, 2],
          [3, 4],
        ].mapDynamicRange(-4, -1).roundTo(5),
        const [
          [-4, -3],
          [-2, -1],
        ],
      );
      expect(
        const [
          [1, 2],
          [3, 4],
        ].mapDynamicRange(-10, 8).roundTo(5),
        const [
          [-10, -4],
          [2, 8],
        ],
      );
      expect(
        const [
          [1.5, 3],
          [4.5, 6],
        ].mapDynamicRange(-10.5, 3).roundTo(5),
        const [
          [-10.5, -6],
          [-1.5, 3],
        ],
      );
      expect(
        const [
          [9, 6],
          [3, 0],
        ].mapDynamicRange(2, 8).roundTo(5),
        const [
          [8, 6],
          [4, 2],
        ],
      );
      expect(
        const [
          [3, 6, 0, 9],
          [3, 6, 0, 9]
        ].mapDynamicRange(2, 8).roundTo(5),
        const [
          [4, 6, 2, 8],
          [4, 6, 2, 8],
        ],
      );
      expect(
        const [
          [3, 6, 0, 9],
          [3, 6, 6, 9]
        ].mapDynamicRange(2, 8).roundTo(5),
        const [
          [4, 6, 2, 8],
          [4, 6, 6, 8],
        ],
      );
      expect(
        const [
          [6, 3],
          [3, 6],
        ].mapDynamicRange(2, 8).roundTo(5),
        const [
          [8, 2],
          [2, 8],
        ],
      );
      expect(
        const [
          [3, 3, 3],
          [3, 3, 3],
          [3, 3, 3],
        ].mapDynamicRange(2, 8).roundTo(5),
        const [
          [2, 2, 2],
          [2, 2, 2],
          [2, 2, 2],
        ],
      );
      expect(
        const [
          [3, 8, 4],
          [5, 3, 5],
          [7, 6, 1],
        ].mapDynamicRange(4, 4).roundTo(5),
        const [
          [4, 4, 4],
          [4, 4, 4],
          [4, 4, 4],
        ],
      );
      expect(
        const [
          [3],
        ].mapDynamicRange(2, 8).roundTo(5),
        const [
          [2],
        ],
      );
      expect(
        const <List<num>>[].mapDynamicRange(2, 8),
        const <num>[],
      );
    });

    test('should throw when min is greater than max', () {
      expect(
        () => const [
          [1, 3],
          [2, 4],
        ].mapDynamicRange(4, 3),
        throwsAssertionError,
      );
    });

    test('should save the amount of edge values after mapping', () {
      final list = [
        random.nextIntList(100, 100, 10),
        random.nextIntList(100, 100, 10),
      ];
      final actual = list.mapDynamicRange(2000, 3000);
      final listMinValue = list.map((list) => list.minValue).minValue;
      final listMaxValue = list.map((list) => list.maxValue).maxValue;
      final actualMinValue = actual.map((list) => list.minValue).minValue;
      final actualMaxValue = actual.map((list) => list.maxValue).maxValue;
      expect(
        actual.map(itemsAmount(actualMinValue)).sum,
        list.map(itemsAmount(listMinValue)).sum,
      );
      expect(
        actual.map(itemsAmount(actualMaxValue)).sum,
        list.map(itemsAmount(listMaxValue)).sum,
      );
    });

    test('should have proportional items with proportional limits', () {
      final list = [
        random.nextIntList(100, 490, 400)..add(500),
        random.nextIntList(100, 300, 210)..add(200),
        random.nextIntList(100, 400, 300),
      ];
      final actual = list
          .mapDynamicRange(2000, 5000)
          .map((list) => list.toList())
          .toList();
      for (var i = 0; i < list.length; i += 1) {
        for (var j = 0; j < actual[i].length; j += 1) {
          expect((actual[i][j] / 10).roundTo(10), list[i][j]);
        }
      }
    });

    test('should map values to full 8-bit range', () {
      final values = [
        List.filled(10, 10),
        random.nextIntList(10, 25, 15),
        List.filled(10, 30),
      ]..shuffle();
      final actual = values.mapDynamicRangeToUint8List();
      expect(actual.where((item) => item == 0).length, 10);
      expect(actual.where((item) => item == 255).length, 10);
    });
  });
}
