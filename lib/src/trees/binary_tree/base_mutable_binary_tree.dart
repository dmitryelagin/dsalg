part of 'binary_tree.dart';

abstract class _BaseMutableBinaryTree<K, V,
    N extends MutableBinaryNode<K, V, N>> extends _BaseBinaryTree<K, V> {
  @override
  N? _root;

  @override
  Iterable<N> get _breadthFirstTraversal => super._breadthFirstTraversal.cast();

  @override
  Iterable<N> get _depthFirstPreOrderTraversal =>
      super._depthFirstPreOrderTraversal.cast();

  @override
  Iterable<N> get _depthFirstInOrderTraversal =>
      super._depthFirstInOrderTraversal.cast();

  @override
  Iterable<N> get _depthFirstPostOrderTraversal =>
      super._depthFirstPostOrderTraversal.cast();

  void invert() {
    for (final node in _depthFirstPostOrderTraversal) {
      if (node.hasChild) node.swapChildren();
    }
  }

  void clear() {
    _root = null;
  }
}
