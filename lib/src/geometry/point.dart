import 'dart:math';

import '../maths/interpolation.dart';
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

  static Point<double> interpLinear(Point a, Point b, double t) =>
      Point(interp.linear(a.x, b.x, t), interp.linear(a.y, b.y, t));

  Point<double> operator /(num divider) => Point(x / divider, y / divider);

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

  Point<int> toInt() => truncate();
  Point<double> toDouble() => Point(x.toDouble(), y.toDouble());
}
