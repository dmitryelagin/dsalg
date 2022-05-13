import '../../collections/stack.dart';
import '../../utils/iterable_utils.dart';
import 'absent_trie_node.dart';
import 'trie_node.dart';

class Trie<K, V> {
  Trie(this._getIterator, [Map<K, V> entries = const {}]) {
    addAll(entries);
  }

  final Iterator<Object> Function(K) _getIterator;

  final _root = TrieNode<V>();

  bool get isEmpty => _root.isEmpty;
  bool get isNotEmpty => !_root.isEmpty;

  static Iterator<T> getStandardIterator<T>(Iterable<T> iterable) =>
      iterable.iterator;

  static Never _throwSearchError([Object? _, Object? __]) {
    TrieNode.throwSearchError();
  }

  V operator [](K key) =>
      _getSearchPath(_getIterator(key), orElse: _throwSearchError).last.value;

  void operator []=(K key, V value) {
    add(key, value);
  }

  Iterable<V> getCyclically(Iterator<Object> iterator) =>
      _getSearchPath(iterator, orElse: _getRootChild)
          .where((node) => node.isSet)
          .map((node) => node.value);

  bool containsKey(K key) =>
      _getSearchPath(_getIterator(key), orElse: AbsentTrieNode.child)
          .last
          .isSet;

  void add(K key, V value) {
    _getSearchPath(_getIterator(key), orElse: TrieNode.child).last.value =
        value;
  }

  void addAll(Map<K, V> entries) {
    entries.forEach(add);
  }

  V? remove(K key) {
    final nodes = Stack<TrieNode<V>>();
    for (final node in _getSearchPath(
      _getIterator(key),
      orElse: AbsentTrieNode.child,
    )) {
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
    Iterator<Object> iterator, {
    required TrieNode<V> Function(TrieNode<V>, Object) orElse,
  }) sync* {
    var node = _root;
    while (iterator.moveNext()) {
      final childKey = iterator.current;
      yield node = node.children[childKey] ?? orElse(node, childKey);
    }
  }

  TrieNode<V> _getRootChild(Object _, Object childKey) =>
      _root.children[childKey] ?? _throwSearchError();
}
