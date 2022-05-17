import 'dart:math';

class LimitedDoubleRandom implements Random {
  static const _maxDouble = 0.999999999999999;

  static final _random = Random();

  @override
  int nextInt(int max) => _random.nextInt(max);

  @override
  double nextDouble() =>
      min((_random.nextDouble() * 5).floor() / 4, _maxDouble);

  @override
  bool nextBool() => _random.nextBool();
}
