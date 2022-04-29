import 'dart:math';

class LoopRandomMock implements Random {
  LoopRandomMock(this._values);

  final List<int> _values;

  var _index = -1;

  @override
  int nextInt(int _) =>
      _values[(_index += 1) < _values.length ? _index : (_index = 0)];

  @override
  double nextDouble() => nextInt(0).toDouble();

  @override
  bool nextBool() => nextInt(0) > 0;
}
