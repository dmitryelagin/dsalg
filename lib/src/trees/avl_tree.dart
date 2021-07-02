import '../commons/balance_binary_node.dart';
import 'base_binary_search_tree.dart';
import 'base_binary_tree.dart';

class AVLTree<T> extends BaseBinarySearchTree<T, _BinaryNode<T>> {
  AVLTree(Comparator<T> compare, [Iterable<T> items = const []])
      : super(_getNode, compare) {
    insertAll(items);
  }

  static _BinaryNode<T> _getNode<T>(T value) => _BinaryNode(value);

  @override
  void insert(T item) {
    var node = insertItem(item).current!;
    while (node.isBalanced) {
      if (node.hasNoParent) break;
      node = node.parent!;
    }
    _rebalance(node);
  }

  @override
  void remove(T item) {
    final change = removeItem(item);
    var node = change.current ?? change.parent;
    while (node != null) {
      _rebalance(node);
      node = node.parent;
    }
  }

  void _rebalance(_BinaryNode<T>? z) {
    if (z == null || z.isBalanced) return;
    final y = z.tallestChild!, x = y.tallestChild!;
    if (y.isLeftOf(z) && x.isLeftOf(y)) z.rotateRight();
    if (y.isRightOf(z) && x.isRightOf(y)) z.rotateLeft();
    if (y.isLeftOf(z) && x.isRightOf(y)) {
      y.rotateLeft();
      z.rotateRight();
    }
    if (y.isRightOf(z) && x.isLeftOf(y)) {
      y.rotateRight();
      z.rotateLeft();
    }
    if (y.hasNoParent) root = y;
    if (x.hasNoParent) root = x;
  }
}

class _BinaryNode<T> extends BalanceBinaryNode<T, _BinaryNode<T>> {
  _BinaryNode(T value, [_BinaryNode<T>? left, _BinaryNode<T>? right])
      : super(value, left, right);
}
