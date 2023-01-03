import 'dart:math';

import '../maths/interpolation/interpolate.dart' as lib;
import '../utils/iterable_utils.dart';

extension PointUtils<T extends num> on Point<T> {
  static T getX<T extends num>(Point<T> point) => point.x;
  static T getY<T extends num>(Point<T> point) => point.y;

  static Point<double> getCentroid(Iterable<Point> points) {
    assert(points.isNotEmpty);
    return Point(
      points.map(getX).sum / points.length,
      points.map(getY).sum / points.length,
    );
  }

  static Point interpLinear(Point a, Point b, double t) =>
    switch (t) {
      0 => a,
      1 => b,
      _ => Point(lib.interpLinear(a.x, b.x, t), lib.interpLinear(a.y, b.y, t)),
    };

  Point<double> operator /(num divider) => Point(x / divider, y / divider);

  double distanceToSafe(Point other) {
    final dx = x - other.x, dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }

  Point<double> merge(Point other) =>
      Point((x + other.x) / 2, (y + other.y) / 2);

  Point<double> move(num distance, num rad) =>
      Point(x + distance * cos(rad), y + distance * sin(rad));

  Point<double> trim([num accuracy = 100]) => Point(
        (x * accuracy).round() / accuracy,
        (y * accuracy).round() / accuracy,
      );

  Point<int> floor() => Point(x.floor(), y.floor());
  Point<int> round() => Point(x.round(), y.round());
  Point<int> ceil() => Point(x.ceil(), y.ceil());
  Point<int> truncate() => Point(x.truncate(), y.truncate());

  Point<int> toInt() => this is Point<int> ? this as Point<int> : truncate();

  Point<double> toDouble() => this is Point<double>
      ? this as Point<double>
      : Point(x.toDouble(), y.toDouble());
}
