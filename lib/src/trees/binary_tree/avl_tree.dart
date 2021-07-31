part of 'binary_tree.dart';

class AVLTree<T> extends _BaseBinarySearchTree<T, _AVLTreeNode<T>> {
  AVLTree(Comparator<T> compare, [Iterable<T> items = const []])
      : super(_createAVLTreeNode, compare) {
    insertAll(items);
  }

  static _AVLTreeNode<T> _createAVLTreeNode<T>(T value) => _AVLTreeNode(value);

  @override
  void insert(T item) {
    var node = _insertItem(item).current!;
    while (node.isBalanced) {
      if (node.hasNoParent) break;
      node = node.parent!;
    }
    _rebalance(node);
  }

  @override
  T? remove(T item) {
    final change = _removeItem(item);
    var node = change.current ?? change.parent;
    while (node != null) {
      _rebalance(node);
      node = node.parent;
    }
    return change.previous?.value;
  }

  void _rebalance(_AVLTreeNode<T>? z) {
    if (z == null || z.isBalanced) return;
    final y = z.tallestChild!, x = y.tallestChild!;
    final isLeftYZ = y.isLeftOf(z), isRightYZ = y.isRightOf(z);
    final isLeftXY = x.isLeftOf(y), isRightXY = x.isRightOf(y);
    if (isLeftYZ && isRightXY) y.rotateLeft();
    if (isRightYZ && isLeftXY) y.rotateRight();
    if (isLeftYZ) z.rotateRight();
    if (isRightYZ) z.rotateLeft();
    if (y.hasNoParent) _root = y;
    if (x.hasNoParent) _root = x;
  }
}

class _AVLTreeNode<T> extends BalanceBinaryNode<T, _AVLTreeNode<T>> {
  _AVLTreeNode(T value) : super(value);
}
