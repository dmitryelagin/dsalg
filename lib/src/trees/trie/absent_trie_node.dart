import 'trie_node.dart';

class AbsentTrieNode<T> implements TrieNode<T> {
  const AbsentTrieNode();

  factory AbsentTrieNode.child([Object? _, Object? __]) =>
      const AbsentTrieNode();

  @override
  Map<Object, TrieNode<T>> get children => const {};

  @override
  T get value => TrieNode.throwSearchError();

  @override
  set value(T value) {}

  @override
  bool get isUnset => true;

  @override
  bool get isEmpty => true;

  @override
  void clear() {}
}
