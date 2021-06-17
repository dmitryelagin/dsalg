import 'utils/list_utils.dart';

extension BubbleSort<T> on List<T> {
  void bubbleSort(Comparator<T> compare) {
    var iteration = 0, hadSwaps = false;
    do {
      iteration += 1;
      hadSwaps = false;
      for (var i = 0; i < length - iteration; i += 1) {
        if (compare(this[i], this[i + 1]) <= 0) continue;
        swap(i, i + 1);
        hadSwaps = true;
      }
    } while (hadSwaps);
  }
}
