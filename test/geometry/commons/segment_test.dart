import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../../utils/data_utils.dart';
import '../../utils/matchers.dart';

void main() {
  // testSegment(Line.new);

  final random = Random();

  group('Segment', () {
    test('should properly check allowed coefficient', () {
      expect(Segment.isSegmentCoefficient(0), isTrue);
      expect(Segment.isSegmentCoefficient(1), isTrue);
      expect(Segment.isSegmentCoefficient(random.nextDouble()), isTrue);
      expect(Segment.isSegmentCoefficient(-1), isFalse);
      expect(Segment.isSegmentCoefficient(2), isFalse);
      expect(Segment.isSegmentCoefficient(random.nextInt(1000) + 2), isFalse);
      expect(Segment.isSegmentCoefficient(-random.nextInt(1000) + 1), isFalse);
    });
  });
}

void testSegment(Segment Function(Point, Point) createSegment) {
  final random = Random();

  late Segment segment;

  setUp(() {
    final a = random.nextIntPoint(100), b = random.nextIntPoint(100);
    segment = createSegment(a, b);
  });

  test('should return correct points amount from maximum magnitude', () {
    final magnitude = random.nextDouble() * random.nextInt(10) + 0.1;
    final points = segment.getPointsByMagnitude(magnitude).toList();
    final a = segment.getPoint(0), b = segment.getPoint(1);
    final targetAmount = (a.distanceTo(b) / magnitude).ceil() + 1;
    expect(points.length, targetAmount);
    expect(points.first, segment.getPoint(0));
    expect(points.last, segment.getPoint(1));
  });

  test('should return proper amount of correct points', () {
    final amount = random.nextInt(50) + 2;
    final points = segment.getPointsByAmount(amount).toList();
    expect(points.length, amount);
    expect(points.first, segment.getPoint(0));
    expect(points.last, segment.getPoint(1));
  });

  test('should fail on invalid arguments', () {
    expect(() => segment.getPointsByMagnitude(0), throwsAssertionError);
    expect(() => segment.getPointsByMagnitude(-0.001), throwsAssertionError);
    expect(() => segment.getPointsByMagnitude(-100), throwsAssertionError);
    expect(() => segment.getPointsByAmount(0), throwsAssertionError);
    expect(() => segment.getPointsByAmount(1), throwsAssertionError);
    expect(() => segment.getPointsByAmount(-100), throwsAssertionError);
  });
}
