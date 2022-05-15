import 'dart:math';

import 'point.dart';
import 'segment.dart';

class Line with Segment {
  const Line(this.a, this.b);

  @override
  final Point a;

  @override
  final Point b;

  @override
  Point getPoint(double t) => PointUtils.interpLinear(a, b, t);
}
