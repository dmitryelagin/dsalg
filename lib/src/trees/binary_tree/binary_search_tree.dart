part of 'binary_tree.dart';

class BinarySearchTree<K, V>
    extends _BaseBinarySearchTree<K, V, _BinarySearchNode<K, V>> {
  BinarySearchTree(Comparator<K> compare, [Map<K, V> entries = const {}])
      : super(_nodeFactory, compare) {
    addAll(entries);
  }

  static _BinarySearchNode<K, V> _nodeFactory<K, V>(K key, V value) =>
      _BinarySearchNode(key, value);
}

class _BinarySearchNode<K, V>
    extends MutableBinaryNode<K, V, _BinarySearchNode<K, V>> {
  _BinarySearchNode(K key, V value) : super(key, value);
}
