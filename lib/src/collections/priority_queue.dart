import '../collections/queue.dart';
import '../trees/binary_heap.dart';

class PriorityQueue<T> extends BinaryHeap<T> implements Queue<T> {
  PriorityQueue(Comparator<T> compare, [Iterable<T> items = const []])
      : super(compare, items);
}
