import '../commons/binary_node.dart';
import 'base_binary_search_tree.dart';

class BinarySearchTree<T> extends BaseBinarySearchTree<T, _BinaryNode<T>> {
  BinarySearchTree(Comparator<T> compare, [Iterable<T> items = const []])
      : super(_createNode, compare) {
    insertAll(items);
  }

  static _BinaryNode<T> _createNode<T>(T value) => _BinaryNode(value);
}

class _BinaryNode<T> extends BinaryNode<T, _BinaryNode<T>> {
  _BinaryNode(T value) : super(value);
}
