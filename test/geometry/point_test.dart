import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';
import '../utils/matchers.dart';

void main() {
  group('PointUtils', () {
    final random = Random();

    test('should properly get coordinate parts', () {
      final items = random.nextIntList(100, 1000), points = <Point>[];
      for (var i = 0; i < items.length / 2; i += 2) {
        points.add(Point(items[i], items[i + 1]));
      }
      for (final point in points) {
        expect(PointUtils.getX(point), point.x);
        expect(PointUtils.getY(point), point.y);
      }
    });

    test('should return interpolated value between points', () {
      final firstItems = random
          .nextIntList(1000, 500, -500)
          .map((item) => item.toDouble())
          .toList();
      final secondItems = random
          .nextIntList(1000, 500, -500)
          .map((item) => item.toDouble())
          .toList();
      for (var i = 0; i < firstItems.length / 2; i += 2) {
        final t = random.nextDouble() * 2 - 0.5;
        final a = Point(firstItems[i], firstItems[i + 1]);
        final b = Point(secondItems[i], secondItems[i + 1]);
        final result = PointUtils.interpLinear(a, b, t);
        if (a.x != b.x) {
          final cX = (result.x - a.x) / (b.x - a.x);
          expect(cX.toStringAsPrecision(8), t.toStringAsPrecision(8));
        } else {
          expect(result.x, a.x);
        }
        if (a.y != b.y) {
          final cY = (result.y - a.y) / (b.y - a.y);
          expect(cY.toStringAsPrecision(8), t.toStringAsPrecision(8));
        } else {
          expect(result.y, a.y);
        }
      }
    });

    test('should return accurate numbers when case is edge case', () {
      final multiplier = random.nextInt(1 << 32);
      final a = random.nextDoublePoint() * multiplier;
      final b = random.nextDoublePoint() * multiplier;
      expect(PointUtils.interpLinear(a, b, 0), a);
      expect(PointUtils.interpLinear(a, b, 1), b);
    });

    test('should create valid centroid point', () {
      final points = random.nextIntPointList(20, 500, 100);
      expect(
        points.reduce((a, b) => a + b) / points.length,
        PointUtils.getCentroid(points),
      );
      expect(
        () => PointUtils.getCentroid(const <Point>[]),
        throwsAssertionError,
      );
    });

    test('should allow point coordinate division', () {
      final point = random.nextIntPoint(100);
      final divider = random.nextInt(100);
      var result = point / divider;
      expect(result.x, point.x / divider);
      expect(result.y, point.y / divider);
      result = point / 0;
      expect(result.x, point.x / 0);
      expect(result.y, point.y / 0);
    });

    test('should merge two points into one', () {
      final a = random.nextIntPoint(100), b = random.nextIntPoint(100);
      expect(a.merge(b), PointUtils.getCentroid([a, b]));
    });

    test('should move point with distance and direction', () {
      final point = random.nextIntPoint(100);
      final angle = random.nextInt(360) * pi / 180;
      var distance = random.nextInt(100);
      expect(
        point.move(distance, angle).distanceTo(point.toDouble()).round(),
        distance,
      );
      distance = random.nextInt(10) * 10;
      expect(
        point.move(distance, pi / 3).x.toStringAsFixed(8),
        (point.x + distance / 2).toStringAsFixed(8),
      );
      expect(
        point.move(distance, pi / 6).y.toStringAsFixed(8),
        (point.y + distance / 2).toStringAsFixed(8),
      );
      expect(
        point.move(distance, -pi / 3).x.toStringAsFixed(8),
        (point.x + distance / 2).toStringAsFixed(8),
      );
      expect(
        point.move(distance, -pi / 6).y.toStringAsFixed(8),
        (point.y - distance / 2).toStringAsFixed(8),
      );
    });

    test('should properly trim point', () {
      final point = random.nextDoublePoint() * random.nextInt(100);
      expect(
        point.trim().x.toString(),
        anyOf(
          point.x.toStringAsFixed(0),
          point.x.toStringAsFixed(1),
          point.x.toStringAsFixed(2),
        ),
      );
      expect(
        point.trim().y.toString(),
        anyOf(
          point.y.toStringAsFixed(0),
          point.y.toStringAsFixed(1),
          point.y.toStringAsFixed(2),
        ),
      );
      expect(
        point.trim(10).x.toString(),
        anyOf(point.x.toStringAsFixed(0), point.x.toStringAsFixed(1)),
      );
      expect(
        point.trim(10).y.toString(),
        anyOf(point.y.toStringAsFixed(0), point.y.toStringAsFixed(1)),
      );
    });

    test('should properly convert point', () {
      Point point = random.nextDoublePoint() * random.nextInt(100);
      expect(point.floor().x, point.x.floor());
      expect(point.floor().y, point.y.floor());
      expect(point.round().x, point.x.round());
      expect(point.round().y, point.y.round());
      expect(point.ceil().x, point.x.ceil());
      expect(point.ceil().y, point.y.ceil());
      expect(point.truncate().x, point.x.truncate());
      expect(point.truncate().y, point.y.truncate());
      expect(point.toInt().x, point.x.toInt());
      expect(point.toInt().y, point.y.toInt());
      point = random.nextIntPoint(100);
      expect(point.toDouble().x, point.x.toDouble());
      expect(point.toDouble().y, point.y.toDouble());
    });
  });
}
