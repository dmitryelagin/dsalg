extension InsertionSort<T> on List<T> {
  void insertionSort(Comparator<T> compare) {
    for (var i = 1; i < length; i += 1) {
      var j = i;
      final current = this[j];
      while (j > 0 && compare(this[j - 1], current) > 0) {
        this[j] = this[j -= 1];
      }
      this[j] = current;
    }
  }
}
