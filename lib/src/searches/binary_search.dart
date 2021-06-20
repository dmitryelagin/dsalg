extension BinarySearch<T> on List<T> {
  int binarySearch(int Function(T) compare) {
    if (isEmpty) return -1;
    var start = 0, end = length - 1;
    while (start < end) {
      final middle = (start + end) ~/ 2;
      final ratio = compare(this[middle]);
      if (ratio == 0) return middle;
      if (ratio > 0) {
        start = middle + 1;
      } else {
        end = middle - 1;
      }
    }
    return compare(this[start]) == 0 ? start : -1;
  }
}
