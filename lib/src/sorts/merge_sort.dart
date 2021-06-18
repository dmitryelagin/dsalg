extension MergeSort<T> on List<T> {
  static List<T> execute<T>(Iterable<T> list, Comparator<T> compare) {
    if (list.length <= 1) return list.toList();
    final mid = list.length ~/ 2;
    final first = execute(list.take(mid), compare);
    final second = execute(list.skip(mid), compare);
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
    if (length <= 1) return;
    final result = execute(this, compare);
    clear();
    addAll(result);
  }
}
