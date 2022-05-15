import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';
import '../utils/data_utils.dart';
import '../utils/matchers.dart';
import '../utils/test_utils.dart';
import 'commons/segment_test.dart';

void main() {
  final random = Random();

  group('CombinedSegment', () {
    testSegment((a, b) => CombinedSegment.fromPoints([a, b]));
  });

  group('CombinedSegment', () {
    late List<Segment> segments;
    late CombinedSegment segment;

    setUp(() {
      final points = random.nextIntPointList(10, 100);
      segments = [
        for (var i = 1; i < points.length; i += 1)
          Line(points[i - 1], points[i]),
      ];
      segment = CombinedSegment(segments);
    });

    test('should return points from correct sub segment', () {
      repeat(times: 10, () {
        final i = random.nextInt(segments.length - 1);
        final t = random.nextDouble();
        expect(
          segment.getPoint(i + t).roundTo(10),
          segments[i].getPoint(t).roundTo(10),
        );
      });
      expect(segment.getPoint(segments.length.toDouble()), segment.b);
    });

    test('should accept coefficent in range until sub segments length', () {
      expect(segment.isValidCoefficient(0), isTrue);
      expect(segment.isValidCoefficient(1), isTrue);
      expect(segment.isValidCoefficient(0.123456789), isTrue);
      expect(segment.isValidCoefficient(segments.length.toDouble()), isTrue);
      expect(segment.isValidCoefficient(1000), isFalse);
      expect(segment.isValidCoefficient(1000.1), isFalse);
      expect(segment.isValidCoefficient(-1000), isFalse);
      expect(segment.isValidCoefficient(-1000.1), isFalse);
      repeat(times: 10, () {
        expect(
          segment.isValidCoefficient(
            random.nextInt(segments.length - 1) + random.nextDouble(),
          ),
          isTrue,
        );
      });
    });

    test('should throw on invalid coefficent', () {
      expect(() => segment.getPoint(-1000), throwsAssertionError);
      expect(() => segment.getPoint(1000), throwsAssertionError);
    });

    test(
        'should return points from maximum magnitude '
        'applied to every sub segement', () {
      final magnitude = random.nextInt(10) + 5;
      final points = segment.getPointsByMagnitude(magnitude);
      expect(points.first, segment.a);
      expect(points.last, segment.b);
      expect(
        points,
        segments
            .expand((segment) => segment.getPointsByMagnitude(magnitude))
            .toSet(),
      );
    });

    test('should return points amount from every sub segement', () {
      final amount = random.nextInt(4) + 2;
      final points = segment.getPointsByAmount(amount);
      expect(points.length, segments.length * (amount - 1) + 1);
      expect(points.first, segment.a);
      expect(points.last, segment.b);
      expect(
        points,
        segments.expand((segment) => segment.getPointsByAmount(amount)).toSet(),
      );
    });

    test('should allow only chained segments', () {
      const line = Line(Point(1, 1), Point(2, 2));
      expect(() => CombinedSegment([line, line]), throwsAssertionError);
    });
  });
}
