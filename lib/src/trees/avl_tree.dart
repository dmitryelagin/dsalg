import '../commons/balance_binary_node.dart';
import 'base_binary_search_tree.dart';
import 'base_binary_tree.dart';

class AVLTree<T> extends BaseBinarySearchTree<T, _BinaryNode<T>> {
  AVLTree(Comparator<T> compare, [Iterable<T> items = const []])
      : super(_createNode, compare) {
    insertAll(items);
  }

  static _BinaryNode<T> _createNode<T>(T value) => _BinaryNode(value);

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
  T? remove(T item) {
    final change = removeItem(item);
    var node = change.current ?? change.parent;
    while (node != null) {
      _rebalance(node);
      node = node.parent;
    }
    return change.previous?.value;
  }

  void _rebalance(_BinaryNode<T>? z) {
    if (z == null || z.isBalanced) return;
    final y = z.tallestChild!, x = y.tallestChild!;
    final isLeftYZ = y.isLeftOf(z), isRightYZ = y.isRightOf(z);
    final isLeftXY = x.isLeftOf(y), isRightXY = x.isRightOf(y);
    if (isLeftYZ && isRightXY) y.rotateLeft();
    if (isRightYZ && isLeftXY) y.rotateRight();
    if (isLeftYZ) z.rotateRight();
    if (isRightYZ) z.rotateLeft();
    if (y.hasNoParent) root = y;
    if (x.hasNoParent) root = x;
  }
}

class _BinaryNode<T> extends BalanceBinaryNode<T, _BinaryNode<T>> {
  _BinaryNode(T value) : super(value);
}
