import 'dart:math';

import '../maths/lerp.dart' as math;

extension PointUtils<T extends num> on Point<T> {
  static T getX<T extends num>(Point<T> point) => point.x;
  static T getY<T extends num>(Point<T> point) => point.y;

  static Point<double> lerp(Point a, Point b, double t) =>
      Point(math.lerp(a.x, b.x, t), math.lerp(a.y, b.y, t));
}
