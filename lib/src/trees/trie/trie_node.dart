class TrieNode<T> {
  TrieNode();

  factory TrieNode.child(TrieNode<T> parent, Object key) =>
      parent.children[key] = TrieNode();

  final children = <Object, TrieNode<T>>{};

  T? _value;

  bool _isUnset = true;

  bool get isEmpty {
    if (!_isUnset) return false;
    for (final key in children.keys) {
      if (!children[key]!.isEmpty) return false;
    }
    return true;
  }

  T get value => _isUnset ? throwSearchError() : _value as T;

  set value(T value) {
    _value = value;
    _isUnset = false;
  }

  static Never throwSearchError() {
    throw StateError('Item is not found');
  }

  void clear() {
    _value = null;
    _isUnset = true;
  }
}
