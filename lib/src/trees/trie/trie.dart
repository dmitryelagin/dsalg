import '../../collections/stack.dart';
import '../../utils/iterable_utils.dart';
import 'absent_trie_node.dart';
import 'trie_node.dart';

class Trie<K, V> {
  Trie(this._getIterator);

  final Iterator<Object> Function(K) _getIterator;

  final _root = TrieNode<V>();

  bool get isEmpty => _root.isEmpty;
  bool get isNotEmpty => !_root.isEmpty;

  static Never _throwSearchError([Object? _, Object? __]) {
    TrieNode.throwSearchError();
  }

  V operator [](K key) =>
      _getSearchPath(key, orElse: _throwSearchError).last.value;

  void operator []=(K key, V value) {
    add(key, value);
  }

  bool containsKey(K key) => _getSearchPath(key, orElse: AbsentTrieNode.child)
      .nothingIs<AbsentTrieNode<V>>();

  void add(K key, V value) {
    _getSearchPath(key, orElse: TrieNode.child).last.value = value;
  }

  void addAll(Map<K, V> entries) {
    entries.forEach(add);
  }

  V? remove(K key) {
    final nodes = Stack<TrieNode<V>>();
    for (final node in _getSearchPath(key, orElse: AbsentTrieNode.child)) {
      if (node is AbsentTrieNode<V>) return null;
      nodes.insert(node);
    }
    var target = nodes.extract();
    if (target.isEmpty) return null;
    final targetValue = target.value;
    target.clear();
    if (target.children.isNotEmpty) return targetValue;
    while (nodes.isNotEmpty) {
      final parent = nodes.extract();
      if (parent.children.length == 1) {
        target = parent;
      } else {
        parent.children.removeWhere((_, node) => target == node);
        return targetValue;
      }
    }
    target.children.clear();
    return targetValue;
  }

  Iterable<V> removeAll(Iterable<K> keys) =>
      keys.map(remove).whereNotNull.toList();

  void clear() {
    _root
      ..clear()
      ..children.clear();
  }

  Iterable<TrieNode<V>> _getSearchPath(
    K key, {
    required TrieNode<V> Function(TrieNode<V>, Object) orElse,
  }) sync* {
    final iterator = _getIterator(key);
    var node = _root;
    yield node;
    while (iterator.moveNext()) {
      final childKey = iterator.current;
      yield node = node.children[childKey] ?? orElse(node, childKey);
    }
  }
}
