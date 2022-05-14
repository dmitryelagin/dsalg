import 'dart:math';

import 'point.dart';
import 'segment.dart';

class Line with Segment {
  const Line(this._a, this._b);

  final Point _a, _b;

  @override
  Point getPoint(double t) => PointUtils.interpLinear(_a, _b, t);
}
