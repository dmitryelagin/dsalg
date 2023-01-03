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
}
