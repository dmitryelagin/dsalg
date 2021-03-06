import 'dart:math';

extension IterableUtils<T> on Iterable<T> {
  Map<T, T> toMap() => Map.fromIterable(this);

  Iterable<MapEntry<T, T>> toMapEntries() => toMap().entries;

  V foldBinary<V>(V initialValue, V Function(V, T, T) combine) {
    final otherItems = skip(1);
    if (isEmpty || otherItems.isEmpty) return initialValue;
    var value = initialValue, previous = first;
    for (final current in otherItems) {
      value = combine(value, previous, current);
      previous = current;
    }
    return value;
  }

  bool nothingIsEqual() => !anyIsEqual();

  bool anyIsEqual() {
    for (final item in skip(1)) {
      if (item == first) return true;
    }
    return false;
  }

  bool everyIsEqual() {
    for (final item in skip(1)) {
      if (item != first) return false;
    }
    return true;
  }

  T elementAtSafe(int index) {
    if (index.isNegative) return first;
    if (index >= length) return last;
    return elementAt(index);
  }
}

extension IterableNumUtils<T extends num> on Iterable<T> {
  T get minValue => reduce(min);
  T get maxValue => reduce(max);

  num get sum => fold(0, _foldNums);

  Iterable<num> get cumulativeSums {
    num previousItem = 0;
    return map((item) => previousItem += item);
  }

  Iterable<int> toInts() => map(_toInt);

  num _foldNums(num a, num b) => a + b;
  int _toInt(num item) => item.toInt();
}
