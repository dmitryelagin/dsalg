import 'dart:collection';

class CachingIterable<T> extends IterableBase<T> {
  CachingIterable(this.length, this._generate) : assert(!length.isNegative);

  @override
  final int length;

  final T Function(int) _generate;

  final _cache = <T>[];

  @override
  CachingIterator<T> get iterator =>
      CachingIterator._(length, _generate, _cache);

  @override
  T elementAt(int index) =>
      index < _cache.length ? _cache[index] : super.elementAt(index);

  @override
  T get first => elementAt(0);

  @override
  T get last => elementAt(length - 1);
}

class CachingIterator<T> implements Iterator<T> {
  CachingIterator._(this._length, this._generate, this._cache);

  final int _length;
  final T Function(int) _generate;
  final List<T> _cache;

  late T _current;

  var _index = 0;

  @override
  T get current => _current;

  @override
  bool moveNext() {
    if (_index >= _length) return false;
    if (_index < _cache.length) {
      _current = _cache[_index];
    } else {
      _current = _generate(_index);
      _cache.add(_current);
    }
    _index += 1;
    return true;
  }
}
