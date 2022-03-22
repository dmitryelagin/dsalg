part of 'binary_tree.dart';

class BinarySearchTree<K, V>
    extends _BaseBinarySearchTree<K, V, _BinarySearchNode<K, V>> {
  BinarySearchTree(Comparator<K> compare, [Map<K, V> entries = const {}])
      : super(_BinarySearchNode.new, compare) {
    addAll(entries);
  }
}

class _BinarySearchNode<K, V>
    extends LinkedBinaryNode<K, V, _BinarySearchNode<K, V>> {
  _BinarySearchNode(super.key, super.value);
}
