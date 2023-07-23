class TrieNode<T> {
  TrieNode();

  factory TrieNode.child(TrieNode<T> parent, Object key) =>
      parent.children[key] = TrieNode();

  final children = <Object, TrieNode<T>>{};

  T? _value;

  bool _isSet = false;

  bool get isSet => _isSet;
  bool get isUnset => !_isSet;

  bool get isEmpty {
    if (_isSet) return false;
    for (final child in children.values) {
      if (!child.isEmpty) return false;
    }
    return true;
  }

  T get value => _isSet ? _value as T : throwSearchError();

  set value(T value) {
    _value = value;
    _isSet = true;
  }

  static Never throwSearchError() {
    throw StateError('Item is not found');
  }

  void clear() {
    _value = null;
    _isSet = false;
  }
}
