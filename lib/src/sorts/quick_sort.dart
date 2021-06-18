import 'dart:math';

import 'utils/list_utils.dart';

extension QuickSort<T> on List<T> {
  static final _random = Random();

  void quickSort(Comparator<T> compare) {
    _quickSort(compare, 0, length - 1);
  }

  void _quickSort(Comparator<T> compare, int start, int end) {
    if (start >= end) return;
    swap(start, _random.nextInt(end - start) + start);
    final pivot = this[start];
    var target = start;
    for (var i = start + 1; i <= end; i += 1) {
      if (compare(this[i], pivot) < 0) swap(i, target += 1);
    }
    swap(start, target);
    _quickSort(compare, start, target - 1);
    _quickSort(compare, target + 1, end);
  }
}
