import '../trees/binary_heap.dart';
import '../utils/list_utils.dart';

extension HeapSort<T> on List<T> {
  void heapSort(Comparator<T> compare) {
    for (var i = length ~/ 2 - 1; i >= 0; i -= 1) {
      BinaryHeap.sink(this, compare, i);
    }
    for (var i = length - 1; i >= 0; i -= 1) {
      swap(0, i);
      BinaryHeap.sink(this, compare, 0, i);
    }
  }
}
