import 'dart:math';

import '../collections/queue.dart';

const interp = _Interpolation();

class _Interpolation {
  const _Interpolation();

  double linear(num a, num b, double t) => a * (1 - t) + b * t;

  double bilinear(num a, num b, num c, num d, double tx, double ty) =>
      (a * (1 - tx) * (1 - ty) + b * tx * (1 - ty)) +
      (c * (1 - tx) * ty + d * tx * ty);

  double cosineS(num a, num b, double t) => linear(a, b, _cosineSCurve(t));

  double bicosineS(num a, num b, num c, num d, double tx, double ty) =>
      bilinear(a, b, c, d, _cosineSCurve(tx), _cosineSCurve(ty));

  double cubicS(num a, num b, double t) => linear(a, b, _cubicSCurve(t));

  double bicubicS(num a, num b, num c, num d, double tx, double ty) =>
      bilinear(a, b, c, d, _cubicSCurve(tx), _cubicSCurve(ty));

  double quinticS(num a, num b, double t) => linear(a, b, _quinticSCurve(t));

  double biquinticS(num a, num b, num c, num d, double tx, double ty) =>
      bilinear(a, b, c, d, _quinticSCurve(tx), _quinticSCurve(ty));

  T recursive<T>(T Function(T, T, double) interp, Iterable<T> items, double t) {
    if (t == 0) return items.first;
    if (t == 1) return items.last;
    final queue = Queue(items);
    while (queue.length > 1) {
      final length = queue.length - 1;
      var previous = queue.extract();
      for (var i = 0; i < length; i += 1) {
        final current = queue.extract();
        queue.insert(interp(previous, current, t));
        previous = current;
      }
    }
    return queue.extract();
  }

  double _cosineSCurve(double t) => (1 - cos(t * pi)) / 2;
  double _cubicSCurve(double t) => pow(t, 2) * (3 - 2 * t);
  double _quinticSCurve(double t) => pow(t, 3) * (6 * pow(t, 2) - 15 * t + 10);
}
