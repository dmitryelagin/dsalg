extension CountingSort<T> on List<T> {
  static List<T> execute<T>(List<T> items, int Function(T) getKey) {
    final buckets = <List<T>?>[], result = <T>[];
    for (final item in items) {
      final key = getKey(item);
      if (key >= buckets.length) buckets.length = key + 1;
      (buckets[key] ??= []).add(item);
    }
    for (final bucket in buckets) {
      if (bucket != null) result.addAll(bucket);
    }
    return result;
  }

  void countingSort(int Function(T) getKey) {
    final result = execute(this, getKey);
    clear();
    addAll(result);
  }
}
