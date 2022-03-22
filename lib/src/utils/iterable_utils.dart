extension IterableNullUtils<T> on Iterable<T?> {
  Iterable<T> get whereNotNull => where(_isNotNull).cast();

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

  bool _isNotNull<V>(V? item) => item != null;
}
