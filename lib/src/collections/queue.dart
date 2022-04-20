import 'linked_list.dart';

class Queue<T> {
  Queue([Iterable<T> items = const []]) {
    items.forEach(insert);
  }

  final _items = LinkedList<T>();

  Iterable<T> get items => _items.toIterable();

  int get length => _items.length;

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  void insert(T item) {
    _items.addLast(item);
  }

  T extract() => _items.removeFirst();

  void clear() {
    _items.clear();
  }
}
