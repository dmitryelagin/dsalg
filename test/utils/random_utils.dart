import 'dart:math';

class LoopRandomMock implements Random {
  LoopRandomMock(this._values, [this._random]);

  static final _defaultRandom = Random();

  final List<int> _values;
  final Random? _random;

  var _index = -1;

  @override
  int nextInt(int _) =>
      _values[(_index += 1) < _values.length ? _index : (_index = 0)];

  @override
  double nextDouble() => (_random ?? _defaultRandom).nextDouble();

  @override
  bool nextBool() => (_random ?? _defaultRandom).nextBool();
}
