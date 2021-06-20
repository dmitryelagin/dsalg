import 'linked_list_entry.dart';

class Stack<T> {
  Stack([Iterable<T> items = const []]) {
    items.forEach(insert);
  }

  LinkedListEntry<T>? _first;

  int _length = 0;

  int get length => _length;

  bool get isEmpty => _first == null;
  bool get isNotEmpty => _first != null;

  void insert(T item) {
    _first = LinkedListEntry(item)..next = _first;
    _length += 1;
  }

  T extract() {
    final entry = _first;
    if (entry == null) throw StateError('Nothing to extract');
    _first = entry.next;
    _length -= 1;
    return entry.value;
  }
}
