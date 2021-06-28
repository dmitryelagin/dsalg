import '../utils/list_utils.dart';

class BinaryHeap<T> {
  BinaryHeap(this._compare, [Iterable<T> items = const []]) {
    insertAll(items);
  }

  final Comparator<T> _compare;

  final _items = <T>[];

  int get length => _items.length;

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  static void bubble<T>(List<T> items, Comparator<T> compare) {
    var index = items.length - 1;
    final item = items[index];
    while (index > 0) {
      final parentIndex = (index - 1) ~/ 2;
      if (compare(item, items[parentIndex]) <= 0) break;
      items.swap(index, parentIndex);
      index = parentIndex;
    }
  }

  static void sink<T>(List<T> items, Comparator<T> compare, [int? i, int? n]) {
    final start = i ?? 0, end = n ?? items.length;
    var index = start;
    final leftChildIndex = start * 2 + 1;
    if (leftChildIndex >= end) return;
    if (compare(items[leftChildIndex], items[index]) > 0) {
      index = leftChildIndex;
    }
    final rightChildIndex = start * 2 + 2;
    if (rightChildIndex < end &&
        compare(items[rightChildIndex], items[index]) > 0) {
      index = rightChildIndex;
    }
    if (index == start) return;
    items.swap(start, index);
    sink(items, compare, index, end);
  }

  void insert(T item) {
    _items.add(item);
    bubble(_items, _compare);
  }

  void insertAll(Iterable<T> items) {
    items.forEach(insert);
  }

  T extract() {
    if (_items.isEmpty) throw StateError('Nothing to extract');
    if (_items.length == 1) return _items.removeLast();
    _items.swap(0, _items.length - 1);
    final result = _items.removeLast();
    sink(_items, _compare, 0, _items.length);
    return result;
  }

  Iterable<T> extractAll() sync* {
    while (isNotEmpty) {
      yield extract();
    }
  }

  void clear() {
    _items.clear();
  }
}
