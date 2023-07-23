part of 'binary_tree.dart';

class AvlTree<K, V> extends _BaseBinarySearchTree<K, V, _AvlNode<K, V>> {
  AvlTree(Comparator<K> compare, [Map<K, V> entries = const {}])
      : super(_AvlNode.new, compare) {
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
    final (node, child, parent) = _removeItem(key);
    var relative = child ?? parent;
    while (relative != null) {
      _rebalance(relative);
      relative = relative.parent;
    }
    return node?.value;
  }

  void _rebalance(_AvlNode<K, V>? z) {
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

class _AvlNode<K, V> extends BalanceBinaryNode<K, V, _AvlNode<K, V>> {
  _AvlNode(super.key, super.value);
}
