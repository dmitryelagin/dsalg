part of 'binary_tree.dart';

class RedBlackTree<K, V>
    extends _BaseBinarySearchTree<K, V, _RedBlackNode<K, V>> {
  RedBlackTree(Comparator<K> compare, [Map<K, V> entries = const {}])
      : super(_RedBlackNode.new, compare) {
    addAll(entries);
  }

  @override
  void add(K key, V value) {
    final node = _addItem(key, value);
    if (node.parent == null) node.isBlack = true;
    _rebalanceAdd(node);
  }

  @override
  V? remove(K key) {
    final change = _removeItem(key), node = change.second;
    if (node.isRed || change.first.isRed) {
      node.isBlack = true;
    } else {
      _rebalanceRemove(node, change.third);
    }
    return change.first?.value;
  }

  void _rebalanceAdd(_RedBlackNode<K, V> x) {
    final y = x.parent, z = y?.parent;
    if (z == null || y.isBlack) return;
    if (y!.sibling.isRed) {
      _recolorRedBlackUp(x);
    } else {
      if (y.isLeftOf(z) && x.isLeftOf(y)) {
        z.rotateRight();
        y.recolor();
        z.recolor();
      }
      if (y.isLeftOf(z) && x.isRightOf(y)) {
        y.rotateLeft();
        z.rotateRight();
        x.recolor();
        z.recolor();
      }
      if (y.isRightOf(z) && x.isRightOf(y)) {
        z.rotateLeft();
        y.recolor();
        z.recolor();
      }
      if (y.isRightOf(z) && x.isLeftOf(y)) {
        y.rotateRight();
        z.rotateLeft();
        x.recolor();
        z.recolor();
      }
    }
  }

  void _rebalanceRemove(_RedBlackNode<K, V>? n, _RedBlackNode<K, V>? z) {
    final y = n?.sibling ?? z?.child;
    if (y == null || z == null) return;
    if (y.isRed) {
      if (y.isLeftOf(z)) z.rotateRight();
      if (y.isRightOf(z)) z.rotateLeft();
      y.recolor();
      z.recolor();
      _rebalanceRemove(n, z);
    } else if (y.isBlack && y.left.isBlack && y.right.isBlack) {
      y.recolor();
      if (z.isBlack) _rebalanceRemove(z, z.parent);
    } else {
      if (y.isLeftOf(z) && y.left.isRed) {
        final x = y.left!;
        z.rotateRight();
        x.recolor();
      }
      if (y.isLeftOf(z) && y.right.isRed && y.left.isBlack) {
        final x = y.right!;
        y.rotateLeft();
        z.rotateRight();
        x.recolor();
      }
      if (y.isRightOf(z) && y.right.isRed) {
        final x = y.right!;
        z.rotateLeft();
        x.recolor();
      }
      if (y.isRightOf(z) && y.left.isRed && y.right.isBlack) {
        final x = y.left!;
        y.rotateRight();
        z.rotateLeft();
        x.recolor();
      }
    }
  }

  void _recolorRedBlackUp(_RedBlackNode<K, V> node) {
    node
      ..isRed = true
      ..parent.isBlack = true
      ..parent?.sibling.isBlack = true;
    final grandparent = node.parent?.parent;
    if (grandparent != null && grandparent != _root) {
      _recolorRedBlackUp(grandparent);
    }
  }
}

class _RedBlackNode<K, V> extends LinkedBinaryNode<K, V, _RedBlackNode<K, V>> {
  _RedBlackNode(super.key, super.value);

  bool _isBlack = false;
}

extension _RedBlackNodeUtils<K, V> on _RedBlackNode<K, V>? {
  bool get isBlack => this?._isBlack ?? true;
  bool get isRed => !isBlack;

  set isBlack(bool value) {
    this?._isBlack = value;
  }

  set isRed(bool value) {
    this?._isBlack = !value;
  }

  void recolor() {
    this?._isBlack = isRed;
  }
}
