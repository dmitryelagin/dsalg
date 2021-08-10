part of 'binary_tree.dart';

abstract class _BaseMutableBinaryTree<K, V,
        N extends MutableBinaryNode<K, V, N>> extends _BaseBinaryTree<K, V>
    implements BinaryTree<K, V> {
  @override
  N? _root;

  void invert() {
    for (final node in _depthFirstPostOrderTraversal.cast<N>()) {
      if (node.hasChild) node.swapChildren();
    }
  }

  void clear() {
    _root = null;
  }
}
