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

  T getSafeConst(int index, T value) {
    if (index.isNegative) return value;
    if (index >= length) return value;
    return this[index];
  }

  T getSafeTerminal(int index) {
    if (index.isNegative) return first;
    if (index >= length) return last;
    return this[index];
  }

  T getSafeCyclic(int index) {
    if (index == -1) return last;
    if (index == length) return first;
    if (index >= 0 && index < length) return this[index];
    return this[index % length];
  }
}
