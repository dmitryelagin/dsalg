import 'package:dsalg/src/trees/base_binary_search_tree.dart';
import 'package:dsalg/src/trees/base_binary_tree.dart';

import 'binary_node_mock.dart';

class BaseBinaryTreeMock<T> extends BaseBinaryTree<T, BinaryNodeMock<T>> {
  BaseBinaryTreeMock(Comparator<T> compare, [Iterable<T> items = const []]) {
    final tree = _BaseBinarySearchTreeMock(compare);
    items.forEach(tree.insert);
    root = tree.root;
  }
}

class _BaseBinarySearchTreeMock<T>
    extends BaseBinarySearchTree<T, BinaryNodeMock<T>> {
  _BaseBinarySearchTreeMock(Comparator<T> compare)
      : super((value) => BinaryNodeMock(value), compare);
}
