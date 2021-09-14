import 'dart:math';

import 'package:dsalg/src/geometry/point.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';

void main() {
  group('PointUtils', () {
    final random = Random();

    test('should properly get coordinate parts', () {
      final items = createIntList(100, 1000), points = <Point>[];
      for (var i = 0; i < items.length / 2; i += 2) {
        points.add(Point(items[i], items[i + 1]));
      }
      for (final point in points) {
        expect(PointUtils.getX(point), point.x);
        expect(PointUtils.getY(point), point.y);
      }
    });

    test('should return interpolated value between points', () {
      final firstItems = createIntList(1000, 500, -500)
          .map((item) => item.toDouble())
          .toList();
      final secondItems = createIntList(1000, 500, -500)
          .map((item) => item.toDouble())
          .toList();
      for (var i = 0; i < firstItems.length / 2; i += 2) {
        final t = random.nextDouble() * 2 - 0.5;
        final a = Point(firstItems[i], firstItems[i + 1]);
        final b = Point(secondItems[i], secondItems[i + 1]);
        final result = PointUtils.lerp(a, b, t);
        if (a.x != b.x) {
          final cX = (result.x - a.x) / (b.x - a.x);
          expect(cX.toStringAsPrecision(10), t.toStringAsPrecision(10));
        } else {
          expect(result.x, a.x);
        }
        if (a.y != b.y) {
          final cY = (result.y - a.y) / (b.y - a.y);
          expect(cY.toStringAsPrecision(10), t.toStringAsPrecision(10));
        } else {
          expect(result.y, a.y);
        }
      }
    });

    test('should return accurate numbers when case is edge case', () {
      final multiplier = random.nextInt(1 << 32);
      double getDouble() => random.nextDouble() * multiplier;
      final a = Point(getDouble(), getDouble());
      final b = Point(getDouble(), getDouble());
      expect(PointUtils.lerp(a, b, 0), a);
      expect(PointUtils.lerp(a, b, 1), b);
    });
  });
}
