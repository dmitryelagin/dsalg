extension IterableNullUtils<T> on Iterable<T?> {
  Iterable<T> get whereNotNull => where(_isNotNull).cast();

  bool _isNotNull<V>(V? item) => item != null;
}

extension IterableUtils<T> on Iterable<T> {
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
}
