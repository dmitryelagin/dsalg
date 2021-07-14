import 'dart:math';

class FibonacciSeriesFactory {
  static final instance = FibonacciSeriesFactory();

  var _cache = <int>[0, 1];

  Iterable<int> getAllBelow(int limit) sync* {
    final cachedLimit = min(limit, _cache.length);
    var i = 0;
    for (; i < cachedLimit; i += 1) {
      yield _cache[i];
    }
    for (; i < limit; i += 1) {
      _cache.add(_cache[i - 1] + _cache[i - 2]);
      yield _cache[i];
    }
  }

  void invalidate() {
    _cache = [0, 1];
  }
}
