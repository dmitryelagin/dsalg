extension BinarySearch<T> on List<T> {
  int binarySearch(int Function(T) compare) =>
      relativeBinarySearch((item, _) => compare(item));

  int relativeBinarySearch(int Function(T, T? Function()) compare) {
    if (isEmpty) return -1;
    var start = 0, middle = 0, end = length - 1;
    T? getPrevious() => middle > 0 ? this[middle - 1] : null;
    while (start < end) {
      middle = (start + end) ~/ 2;
      final ratio = compare(this[middle], getPrevious);
      if (ratio == 0) return middle;
      if (ratio > 0) {
        start = middle + 1;
      } else {
        end = middle - 1;
      }
    }
    return compare(this[start], getPrevious) == 0 ? start : -1;
  }
}
