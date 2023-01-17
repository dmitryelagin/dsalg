extension ListUtils<T> on List<T> {
  void swap(int i, int j) {
    final temp = this[i];
    this[i] = this[j];
    this[j] = temp;
  }

  void sortAsc(Comparable<Object> Function(T) getItem) {
    sort((a, b) => getItem(a).compareTo(getItem(b)));
  }

  void sortDesc(Comparable<Object> Function(T) getItem) {
    sort((a, b) => getItem(b).compareTo(getItem(a)));
  }

  T getSafe(int index) {
    if (index.isNegative) return first;
    if (index >= length) return last;
    return this[index];
  }
}
