import 'dart:math';

class LimitedDoubleRandom implements Random {
  const LimitedDoubleRandom(this._steps);

  static const _maxDouble = 0.999999999999999;

  static final _random = Random();

  final int _steps;

  @override
  int nextInt(int max) => _random.nextInt(max);

  @override
  double nextDouble() =>
      min((_random.nextDouble() * (_steps + 1)).floor() / _steps, _maxDouble);

  @override
  bool nextBool() => _random.nextBool();
}
