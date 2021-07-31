class Comparator<T> {
  Comparator(this._compare);

  final int Function(T, T) _compare;

  int _modifier = 1;

  int call(T a, T b) => _compare(a, b) * _modifier;

  bool areEqual(T a, T b) => this(a, b) == 0;
  bool areNotEqual(T a, T b) => this(a, b) != 0;

  void invert() {
    _modifier *= -1;
  }
}
