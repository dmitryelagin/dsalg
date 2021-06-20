import 'linked_list_entry.dart';

class Queue<T> {
  Queue([Iterable<T> items = const []]) {
    items.forEach(insert);
  }

  LinkedListEntry<T>? _first;
  LinkedListEntry<T>? _last;

  int _length = 0;

  int get length => _length;

  bool get isEmpty => _first == null;
  bool get isNotEmpty => _first != null;

  void insert(T item) {
    final entry = LinkedListEntry(item);
    _first ??= entry;
    _last?.next = entry;
    _last = entry;
    _length += 1;
  }

  T extract() {
    final entry = _first;
    if (entry == null) throw StateError('Nothing to extract');
    _first = entry.next;
    if (_first == null) _last = null;
    _length -= 1;
    return entry.value;
  }
}
