import 'utils/list_utils.dart';

extension SelectionSort<T> on List<T> {
  void selectionSort(Comparator<T> compare) {
    for (var i = 0; i < length - 1; i += 1) {
      var min = i;
      for (var j = i + 1; j < length; j += 1) {
        if (compare(this[min], this[j]) > 0) min = j;
      }
      if (i != min) swap(i, min);
    }
  }
}
