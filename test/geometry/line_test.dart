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
      do {
        a = random.nextIntPoint(100);
        b = random.nextIntPoint(100);
        line = Line(a, b);
      } while (line.a.distanceTo(line.b) <= 0);
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
        'equal to specified one', () {
      const epsilon = 0.0000000000001;
      final magnitude = random.nextDouble() * random.nextInt(10) + 0.2;
      final points = line.getPointsByMagnitude(magnitude).toList();
      final distances = [
        for (var i = 1; i < points.length; i += 1)
          points[i - 1].distanceToSafe(points[i]),
      ];
      expect(
        distances.every((distance) => distance <= magnitude + epsilon),
        isTrue,
      );
    });

    test('should return points with equal magnitudes between neighbours', () {
      final amount = random.nextInt(50) + 2;
      final points = line.getPointsByAmount(amount).toList();
      final distances = [
        for (var i = 1; i < points.length; i += 1)
          points[i - 1].distanceToSafe(points[i]),
      ].map((distance) => distance.roundTo(10));
      expect(distances.everyIsEqual(), isTrue);
    });

    test('should accept any coefficent', () {
      expect(line.isValidCoefficient(0), isTrue);
      expect(line.isValidCoefficient(1), isTrue);
      expect(line.isValidCoefficient(0.123456789), isTrue);
      expect(line.isValidCoefficient(1000), isTrue);
      expect(line.isValidCoefficient(1000.1), isTrue);
      expect(line.isValidCoefficient(-1000), isTrue);
      expect(line.isValidCoefficient(-1000.1), isTrue);
    });
  });
}
