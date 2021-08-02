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
    return node.toEntry();
  }

  @override
  void add(K key, V value) {
    _splay(_addItem(key, value).next!);
  }

  @override
  V? remove(K key) {
    if (isEmpty) return null;
    final nodes = _splitNodes(key), first = nodes.first;
    if (first == null) return null;
    _root = _mergeNodes(first.left, nodes.next);
    first.left = null;
    return first.value;
  }

  NodeTuple<_SplayNode<K, V>> _splitNodes(K key) {
    final node = _getNodeClosestTo(key);
    if (_compare.areNotEqual(key, node.key)) return const NodeTuple.empty();
    _splay(node);
    final nodes = NodeTuple(node, node.right);
    node.right = null;
    return nodes;
  }

  _SplayNode<K, V>? _mergeNodes(_SplayNode<K, V>? a, _SplayNode<K, V>? b) {
    if (a == null) return b;
    if (b == null) return a;
    final node = a.rightmost;
    _splay(node);
    return node..right = b;
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
