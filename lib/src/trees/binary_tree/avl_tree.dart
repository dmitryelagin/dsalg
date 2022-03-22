part of 'binary_tree.dart';

class AVLTree<K, V> extends _BaseBinarySearchTree<K, V, _AVLNode<K, V>> {
  AVLTree(Comparator<K> compare, [Map<K, V> entries = const {}])
      : super(_AVLNode.new, compare) {
    addAll(entries);
  }

  @override
  void add(K key, V value) {
    var node = _addItem(key, value);
    while (node.isBalanced) {
      if (node.hasNoParent) break;
      node = node.parent!;
    }
    _rebalance(node);
  }

  @override
  V? remove(K key) {
    final change = _removeItem(key);
    var node = change.next ?? change.parent;
    while (node != null) {
      _rebalance(node);
      node = node.parent;
    }
    return change.first?.value;
  }

  void _rebalance(_AVLNode<K, V>? z) {
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

class _AVLNode<K, V> extends BalanceBinaryNode<K, V, _AVLNode<K, V>> {
  _AVLNode(super.key, super.value);
}
