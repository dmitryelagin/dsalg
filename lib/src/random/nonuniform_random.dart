import 'dart:math';

import '../searches/binary_search.dart';
import '../utils/iterable_utils.dart';

class NonuniformRandom implements Random {
  NonuniformRandom(this._random, List<int> distributions)
      : assert(distributions.isNotEmpty),
        assert(distributions.every(_isValidDistribution)),
        _cumulativeWeights = distributions.cumulativeSums.toInts().toList(),
        _rangeSize = 1 / distributions.length;

  final Random _random;
  final List<int> _cumulativeWeights;
  final double _rangeSize;

  static bool _isValidDistribution(int distribution) => distribution >= 0;

  int nextDistributedInt() {
    final value = _random.nextInt(_cumulativeWeights.last);
    return _cumulativeWeights.relativeBinarySearch((weight, getPrevious) {
      if (value >= weight) return 1;
      if (value >= (getPrevious() ?? 0)) return 0;
      return -1;
    });
  }

  @override
  int nextInt(int max) {
    assert(max > 0);
    return (max * nextDouble()).toInt();
  }

  @override
  double nextDouble() {
    final value = _rangeSize * (nextDistributedInt() + _random.nextDouble());
    return value < 1 ? value : nextDouble();
  }

  @override
  bool nextBool() => nextDouble() >= 0.5;
}
