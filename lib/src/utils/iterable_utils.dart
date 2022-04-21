import 'dart:math';

extension IterableUtils<T> on Iterable<T> {
  bool nothingIs<V extends T>() => !anyIs<V>();

  bool anyIs<V extends T>() {
    for (final item in this) {
      if (item is V) return true;
    }
    return false;
  }

  bool everyIs<V extends T>() {
    for (final item in this) {
      if (item is! V) return false;
    }
    return true;
  }

  bool startsWith(Iterable<T> other) {
    if (other.length > length) return false;
    final first = iterator, second = other.iterator;
    while (second.moveNext()) {
      if (!first.moveNext() || first.current != second.current) return false;
    }
    return true;
  }
}

extension IterableNullUtils<T> on Iterable<T?> {
  Iterable<T> get whereNotNull => where(_isNotNull).cast();

  bool _isNotNull<V>(V? item) => item != null;
}

extension IterableNumUtils<T extends num> on Iterable<T> {
  T get minValue => reduce(min);
  T get maxValue => reduce(max);

  num get sum => fold(0, _foldNums);

  num _foldNums(num a, num b) => a + b;
}
