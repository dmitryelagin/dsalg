import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';
import '../utils/data_utils.dart';
import '../utils/iterable_utils.dart';
import '../utils/test_utils.dart';
import 'commons/segment_test.dart';

void main() {
  final random = Random();

  group('Line', () {
    testSegment(Line.new);
  });

  group('Line', () {
    late Point<int> a, b;
    late Line line;

    void setUpTests() {
      a = random.nextIntPoint(100);
      b = random.nextIntPoint(100);
      line = Line(a, b);
    }

    setUp(setUpTests);

    test('should return same point as with base points interpolation', () {
      repeat(times: 100, () {
        setUpTests();
        final firstTarget = random.nextDouble();
        expect(
          line.getPoint(firstTarget),
          PointUtils.interpLinear(a, b, firstTarget),
        );
        final secondTarget =
            random.nextDouble() * random.nextInt(100) - random.nextInt(50);
        expect(
          line.getPoint(secondTarget),
          PointUtils.interpLinear(a, b, secondTarget),
        );
      });
    });

    test(
        'should return points with magnitudes less than or '
        'equal to the specified one', () {
      final magnitude = random.nextDouble() * random.nextInt(10) + 0.1;
      final points = line.getPointsByMagnitude(magnitude).toList();
      final distances = [
        for (var i = 0; i < points.length - 1; i += 1)
          points[i].distanceTo(points[i + 1]),
      ];
      expect(distances.every((distance) => distance <= magnitude), isTrue);
    });

    test('should return points with equal magnitudes between neighbours', () {
      final amount = random.nextInt(50) + 2;
      final points = line.getPointsByAmount(amount).toList();
      final distances = [
        for (var i = 0; i < points.length - 1; i += 1)
          points[i].distanceTo(points[i + 1]),
      ].map((distance) => distance.roundTo(10));
      expect(distances.everyIsEqual(), isTrue);
    });
  });
}
