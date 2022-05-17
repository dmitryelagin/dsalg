import 'dart:math';

import '../../maths/interpolation/interpolate.dart';
import '../point.dart';
import '../segment.dart';

class BezierCurve with Segment {
  BezierCurve(Iterable<Point> points)
      : assert(points.isNotEmpty),
        _controlXs = points.map(PointUtils.getX),
        _controlYs = points.map(PointUtils.getY),
        _controlPoints = points.toList();

  final Iterable<num> _controlXs, _controlYs;
  final List<Point> _controlPoints;

  bool get _isOptimal => _controlPoints.length <= 4;

  @override
  Point getPoint(double t) {
    assert(isValidCoefficient(t));
    if (t == 0) return _controlPoints.first;
    if (t == 1) return _controlPoints.last;
    return _isOptimal
        ? Point(_interpOptimal(_controlXs, t), _interpOptimal(_controlYs, t))
        : interpRecursive(PointUtils.interpLinear, _controlPoints, t);
  }

  num _interpOptimal(Iterable<num> items, double t) {
    final iterator = items.iterator..moveNext();
    final a = iterator.current;
    if (!iterator.moveNext()) return a;
    final b = iterator.current;
    if (!iterator.moveNext()) return interpLinear(a, b, t);
    final c = iterator.current, dt = 1 - t;
    if (!iterator.moveNext()) return dt * dt * a + 2 * dt * t * b + t * t * c;
    final d = iterator.current;
    return dt * dt * dt * a +
        3 * dt * dt * t * b +
        3 * dt * t * t * c +
        t * t * t * d;
  }
}
