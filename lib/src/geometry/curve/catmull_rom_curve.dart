import 'dart:math';

import '../../maths/interpolation/interpolate.dart';
import '../point.dart';
import '../segment.dart';

class CatmullRomCurve with Segment {
  CatmullRomCurve(
    this._a,
    this._b,
    this._c,
    this._d, [
    double alpha = centripetalAlpha,
  ]) {
    _distances
      ..add(_getKnotDistance(_a, _b, alpha))
      ..add(_getKnotDistance(_b, _c, alpha) + _distances[1])
      ..add(_getKnotDistance(_c, _d, alpha) + _distances[2]);
  }

  static const uniformAlpha = 0.0;
  static const centripetalAlpha = 0.5;
  static const chordalAlpha = 1.0;

  final Point _a, _b, _c, _d;

  final List<num> _distances = [0];

  static num _getKnotDistance(Point a, Point b, double alpha) =>
      pow(a.squaredDistanceTo(b), alpha / 2);

  @override
  Point getPoint(double t) {
    assert(isValidCoefficient(t));
    if (t == 0) return _b;
    if (t == 1) return _c;
    final u = interpLinear(_distances[1], _distances[2], t);
    final a1 = _interp(_a, _b, 0, 1, u);
    final a2 = _interp(_b, _c, 1, 2, u);
    final a3 = _interp(_c, _d, 2, 3, u);
    final b1 = _interp(a1, a2, 0, 2, u);
    final b2 = _interp(a2, a3, 1, 3, u);
    return _interp(b1, b2, 1, 2, u);
  }

  Point _interp(Point a, Point b, int start, int end, num u) {
    final t = (u - _distances[start]) / (_distances[end] - _distances[start]);
    return PointUtils.interpLinear(a, b, t);
  }
}
