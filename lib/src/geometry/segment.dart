import 'dart:math';

mixin Segment {
  static bool isSegmentCoefficient(double t) => t >= 0 && t <= 1;

  Point getPoint(double t);

  Iterable<Point> getPointsByMagnitude(num magnitude) {
    assert(magnitude > 0);
    return getPointsByAmount(
      (getPoint(0).distanceTo(getPoint(1)) / magnitude).ceil() + 1,
    );
  }

  Iterable<Point> getPointsByAmount(int amount) sync* {
    assert(amount >= 2);
    yield getPoint(0);
    final step = 1 / (amount - 1), middleAmount = amount - 2;
    for (var i = 1; i <= middleAmount; i += 1) {
      yield getPoint(step * i);
    }
    yield getPoint(1);
  }
}
