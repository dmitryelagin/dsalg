import '../collections/queue.dart';
import '../trees/binary_heap.dart';

class PriorityQueue<T> extends BinaryHeap<T> implements Queue<T> {
  PriorityQueue(super.compare, [super.items]);
}
