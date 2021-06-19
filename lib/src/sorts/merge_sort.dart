extension MergeSort<T> on List<T> {
  static List<T> execute<T>(Iterable<T> items, Comparator<T> compare) {
    if (items.length <= 1) return items.toList();
    final mid = items.length ~/ 2;
    final first = execute(items.take(mid), compare);
    final second = execute(items.skip(mid), compare);
    final result = <T>[];
    var i = 0, j = 0;
    while (i < first.length && j < second.length) {
      if (compare(first[i], second[j]) > 0) {
        result.add(second[j]);
        j += 1;
      } else {
        result.add(first[i]);
        i += 1;
      }
    }
    while (i < first.length) {
      result.add(first[i]);
      i += 1;
    }
    while (j < second.length) {
      result.add(second[j]);
      j += 1;
    }
    return result;
  }

  void mergeSort(Comparator<T> compare) {
    final result = execute(this, compare);
    clear();
    addAll(result);
  }
}
