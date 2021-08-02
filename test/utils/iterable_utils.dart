extension IterableUtils<T> on Iterable<T> {
  Map<T, T> toMap() => Map.fromIterable(this);
  Iterable<MapEntry<T, T>> toMapEntries() => toMap().entries;
}
