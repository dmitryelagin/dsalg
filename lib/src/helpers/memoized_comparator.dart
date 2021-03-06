import 'comparator.dart';

class MemoizedComparator<T> extends Comparator<T> {
  MemoizedComparator(super.compare);

  T? _a, _b;

  var _ratio = 0;

  @override
  int call(T a, T b) {
    if (_a == a && _b == b) return _ratio;
    return _ratio = super.call(_a = a, _b = b);
  }

  void invalidate() {
    _a = null;
    _b = null;
    _ratio = 0;
  }
}
