part of 'binary_tree.dart';

class SplayTree<K, V> extends _BaseBinarySearchTree<K, V, _SplayNode<K, V>> {
  SplayTree(Comparator<K> compare, [Map<K, V> entries = const {}])
      : super(_nodeFactory, compare) {
    addAll(entries);
  }

  static _SplayNode<K, V> _nodeFactory<K, V>(K key, V value) =>
      _SplayNode(key, value);

  @override
  V operator [](K key) {
    final node = _getNode(key);
    _splay(node);
    return node.value;
  }

  @override
  MapEntry<K, V> getClosestTo(K key) {
    final node = _getNodeClosestTo(key);
    _splay(node);
    return node.toMapEntry();
  }

  @override
  void add(K key, V value) {
    _splay(_addItem(key, value).next!);
  }

  @override
  V? remove(K key) {
    if (isEmpty) return null;
    final node = _getNodeClosestTo(key);
    if (_compare.areNotEqual(key, node.key)) return null;
    _splay(node);
    final left = node.left, right = node.right;
    node.right = null;
    if (left == null || right == null) {
      _root = left ?? right;
    } else {
      _splay(left.rightmost);
      _root!.right = right;
    }
    node.left = null;
    return node.value;
  }

  void _splay(_SplayNode<K, V> x) {
    _root = x;
    while (x.hasParent) {
      final y = x.parent!;
      final isLeftXY = x.isLeftOf(y), isRightXY = x.isRightOf(y);
      if (y.hasNoParent) {
        if (isLeftXY) y.rotateRight();
        if (isRightXY) y.rotateLeft();
      } else {
        final z = y.parent!;
        final isLeftYZ = y.isLeftOf(z), isRightYZ = y.isRightOf(z);
        if (isLeftYZ && isLeftXY) {
          z.rotateRight();
          y.rotateRight();
        }
        if (isRightYZ && isRightXY) {
          z.rotateLeft();
          y.rotateLeft();
        }
        if (isLeftYZ && isRightXY) {
          y.rotateLeft();
          z.rotateRight();
        }
        if (isRightYZ && isLeftXY) {
          y.rotateRight();
          z.rotateLeft();
        }
      }
    }
  }
}

class _SplayNode<K, V> extends LinkedBinaryNode<K, V, _SplayNode<K, V>> {
  _SplayNode(K key, V value) : super(key, value);
}
