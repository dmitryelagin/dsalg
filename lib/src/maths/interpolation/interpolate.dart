import 'dart:math';

import '../../collections/queue.dart';

typedef CubicEntry<T> = (T, T, T, T);

num interpLinear(num a, num b, double t) {
  switch (t) {
    case 0:
      return a;
    case 1:
      return b;
    default:
      return a * (1 - t) + b * t;
  }
}

num interpBiLinear(num a, num b, num c, num d, double tx, double ty) =>
    interpLinear(
      interpLinear(a, b, tx),
      interpLinear(c, d, tx),
      ty,
    );

num interpCubic(CubicEntry<num> values, double t) {
  final (a, b, c, d) = values;
  switch (t) {
    case 0:
      return b;
    case 1:
      return c;
    default:
      final m = 2 * a - 5 * b + 4 * c - d + t * (3 * (b - c) + d - a);
      return b + t * (c - a + t * m) / 2;
  }
}

num interpBiCubic(CubicEntry<CubicEntry<num>> values, double tx, double ty) {
  final (a, b, c, d) = values;
  return interpCubic(
    (
      interpCubic(a, ty),
      interpCubic(b, ty),
      interpCubic(c, ty),
      interpCubic(d, ty),
    ),
    tx,
  );
}

num interpCosineS(num a, num b, double t) =>
    interpLinear(a, b, _cosineSCurve(t));

num interpBiCosineS(num a, num b, num c, num d, double tx, double ty) =>
    interpBiLinear(a, b, c, d, _cosineSCurve(tx), _cosineSCurve(ty));

num interpCubicS(num a, num b, double t) => interpLinear(a, b, _cubicSCurve(t));

num interpBiCubicS(num a, num b, num c, num d, double tx, double ty) =>
    interpBiLinear(a, b, c, d, _cubicSCurve(tx), _cubicSCurve(ty));

num interpQuinticS(num a, num b, double t) =>
    interpLinear(a, b, _quinticSCurve(t));

num interpBiQuinticS(num a, num b, num c, num d, double tx, double ty) =>
    interpBiLinear(a, b, c, d, _quinticSCurve(tx), _quinticSCurve(ty));

T interpRecursive<T>(
  T Function(T, T, double) interp,
  Iterable<T> items,
  double t,
) {
  switch (t) {
    case 0:
      return items.first;
    case 1:
      return items.last;
    default:
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
}

double _cosineSCurve(double t) => (1 - cos(t * pi)) / 2;
double _cubicSCurve(double t) => t * t * (3 - 2 * t);
double _quinticSCurve(double t) => t * t * t * (6 * t * t - 15 * t + 10);
