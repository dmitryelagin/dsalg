import 'dart:math';

mixin Segment {
  Point get a => getPoint(0);
  Point get b => getPoint(1);

  bool isValidCoefficient(double t) => t >= 0 && t <= 1;

  Point getPoint(double t);

  Iterable<Point> getPointsByMagnitude(num magnitude) {
    assert(magnitude > 0);
    return getPointsByAmount((a.distanceTo(b) / magnitude).ceil() + 1);
  }

  Iterable<Point> getPointsByAmount(int amount) sync* {
    assert(amount >= 2);
    yield a;
    final step = 1 / (amount - 1), middleAmount = amount - 2;
    for (var i = 1; i <= middleAmount; i += 1) {
      yield getPoint(step * i);
    }
    yield b;
  }
}
