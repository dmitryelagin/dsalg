import 'dart:math';

import 'line.dart';
import 'segment.dart';

class CombinedSegment with Segment {
  CombinedSegment(this._segments) : assert(areChainedSegments(_segments));

  factory CombinedSegment.fromPoints(List<Point> points) {
    assert(points.length >= 2);
    return CombinedSegment([
      for (var i = 1; i < points.length; i += 1) Line(points[i - 1], points[i]),
    ]);
  }

  static bool areChainedSegments(List<Segment> segments) {
    assert(segments.isNotEmpty);
    for (var i = 1; i < segments.length; i += 1) {
      if (segments[i - 1].b != segments[i].a) return false;
    }
    return true;
  }

  final List<Segment> _segments;

  @override
  Point get a => _segments.first.a;

  @override
  Point get b => _segments.last.b;

  @override
  bool isValidCoefficient(double t) => t >= 0 && t <= _segments.length;

  @override
  Point getPoint(double t) {
    assert(isValidCoefficient(t));
    if (t == _segments.length) return b;
    final i = t.toInt();
    return _segments[i].getPoint(t - i);
  }

  @override
  Iterable<Point> getPointsByMagnitude(num magnitude) sync* {
    assert(magnitude > 0);
    yield a;
    for (final segment in _segments) {
      yield* segment.getPointsByMagnitude(magnitude).skip(1);
    }
  }

  @override
  Iterable<Point> getPointsByAmount(int amount) sync* {
    assert(amount >= 2);
    yield a;
    for (final segment in _segments) {
      yield* segment.getPointsByAmount(amount).skip(1);
    }
  }
}
