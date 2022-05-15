import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../../utils/data_utils.dart';
import '../../utils/matchers.dart';

void main() {
  // testSegment(Line.new);
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
    final a = segment.a, b = segment.b;
    final targetAmount = (a.distanceTo(b) / magnitude).ceil() + 1;
    expect(points.length, targetAmount);
    expect(points.first, segment.a);
    expect(points.last, segment.b);
  });

  test('should return proper amount of correct points', () {
    final amount = random.nextInt(50) + 2;
    final points = segment.getPointsByAmount(amount).toList();
    expect(points.length, amount);
    expect(points.first, segment.a);
    expect(points.last, segment.b);
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
