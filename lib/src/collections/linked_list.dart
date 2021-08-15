class LinkedList<T> {
  LinkedList([Iterable<T> items = const []]) {
    items.forEach(addLast);
  }

  _LinkedListEntry<T>? _first;
  _LinkedListEntry<T>? _last;

  var _length = 0;

  int get length => _length;

  bool get isEmpty => _first == null || _last == null;
  bool get isNotEmpty => _first != null && _last != null;

  T get first {
    if (isEmpty) throw StateError('Nothing to return');
    return _first!.value;
  }

  T get last {
    if (isEmpty) throw StateError('Nothing to return');
    return _last!.value;
  }

  T operator [](int key) => _getEntry(key).value;

  void operator []=(int key, T item) {
    _getEntry(key).value = item;
  }

  void addFirst(T item) {
    _first = _LinkedListEntry(item, _first);
    _last ??= _first;
    _length += 1;
  }

  void addLast(T item) {
    final entry = _LinkedListEntry(item);
    _first ??= entry;
    _last?.next = entry;
    _last = entry;
    _length += 1;
  }

  void add(int key, T item) {
    if (key == 0) {
      addFirst(item);
    } else if (key == length) {
      addLast(item);
    } else {
      final previous = _getEntry(key - 1);
      previous.next = _LinkedListEntry(item, previous.next);
      _length += 1;
    }
  }

  T removeFirst() {
    if (isEmpty) throw StateError('Nothing to extract');
    final entry = _first!;
    _first = entry.next;
    if (_first == null) _last = null;
    _length -= 1;
    return entry.value;
  }

  T removeLast() => remove(length - 1);

  T remove(int key) {
    if (isEmpty) throw StateError('Nothing to extract');
    if (key == 0) return removeFirst();
    final previous = _getEntry(key - 1), current = previous.next;
    if (current == null) throw RangeError.index(key, this);
    previous.next = current.next;
    if (previous.next == null) _last = previous;
    _length -= 1;
    return current.value;
  }

  void forEach(void Function(T) callback) {
    if (isEmpty) return;
    var entry = _first;
    while (entry != null) {
      callback(entry.value);
      entry = entry.next;
    }
  }

  Iterable<T> toIterable() sync* {
    var current = _first;
    while (current != null) {
      yield current.value;
      current = current.next;
    }
  }

  _LinkedListEntry<T> _getEntry(int key) {
    var current = _first, i = 0;
    while (current != null && i <= key) {
      if (i == key) return current;
      current = current.next;
      i += 1;
    }
    throw RangeError.index(key, this);
  }
}

class _LinkedListEntry<T> {
  _LinkedListEntry(this.value, [this.next]);

  T value;

  _LinkedListEntry<T>? next;
}
