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

  bool everyIsEqual() {
    for (final item in skip(1)) {
      if (item != first) return false;
    }
    return true;
  }
}

extension IterableNumUtils<T extends num> on Iterable<T> {
  num get sum => fold(0, _foldNums);

  num _foldNums(num a, num b) => a + b;
}
