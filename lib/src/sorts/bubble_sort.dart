import 'utils/list_utils.dart';

extension BubbleSort<T> on List<T> {
  void bubbleSort(Comparator<T> compare) {
    var pass = 0, hadSwaps = false;
    do {
      pass += 1;
      hadSwaps = false;
      for (var i = 0; i < length - pass; i += 1) {
        if (compare(this[i], this[i + 1]) <= 0) continue;
        swap(i, i + 1);
        hadSwaps = true;
      }
    } while (hadSwaps);
  }
}
