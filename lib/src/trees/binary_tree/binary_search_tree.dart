part of 'binary_tree.dart';

class BinarySearchTree<T>
    extends _BaseBinarySearchTree<T, _BinarySearchTreeNode<T>> {
  BinarySearchTree(Comparator<T> compare, [Iterable<T> items = const []])
      : super(_createBinarySearchTreeNode, compare) {
    insertAll(items);
  }

  static _BinarySearchTreeNode<T> _createBinarySearchTreeNode<T>(T value) =>
      _BinarySearchTreeNode(value);
}

class _BinarySearchTreeNode<T> extends BinaryNode<T, _BinarySearchTreeNode<T>> {
  _BinarySearchTreeNode(T value) : super(value);
}
