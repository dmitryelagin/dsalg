import '../commons/balance_binary_node.dart';
import '../commons/binary_search_node.dart';
import 'base_binary_search_tree.dart';
import 'base_binary_tree.dart';

class AVLTree<T> extends BaseBinarySearchTree<T, _BinaryNode<T>> {
  AVLTree(this._compare, [Iterable<T> items = const []])
      : super(_getNode, _compare) {
    items.forEach(insert);
  }

  final Comparator<T> _compare;

  static _BinaryNode<T> _getNode<T>(T value) => _BinaryNode(value);

  @override
  void insert(T item) {
    var node = insertItem(item);
    while (node.isBalanced) {
      if (node.parent == null) break;
      node = node.parent!;
    }
    _rebalance(node);
  }

  @override
  void remove(T item) {
    var node = removeItem(item);
    while (node != null) {
      _rebalance(node);
      node = node.parent;
    }
  }

  void _rebalance(_BinaryNode<T>? z) {
    if (z == null || z.isBalanced) return;
    final y = z.tallestChild!, x = y.tallestChild!, p = z.parent;
    final isLeftChildXY = _isLeftChild(x, y);
    final isLeftChildYZ = _isLeftChild(y, z);
    final isRightChildXY = _isRightChild(x, y);
    final isRightChildYZ = _isRightChild(y, z);
    if (isLeftChildYZ && isLeftChildXY) {
      _rotateRight(y, z, p);
    }
    if (isLeftChildYZ && isRightChildXY) {
      _rotateLeft(x, y, z);
      _rotateRight(x, z, p);
    }
    if (isRightChildYZ && isRightChildXY) {
      _rotateLeft(y, z, p);
    }
    if (isRightChildYZ && isLeftChildXY) {
      _rotateRight(x, y, z);
      _rotateLeft(x, z, p);
    }
  }

  void _rotateLeft(_BinaryNode<T> x, _BinaryNode<T> y, _BinaryNode<T>? p) {
    y.right = x.left;
    x.left = y;
    _changeChild(x, p);
  }

  void _rotateRight(_BinaryNode<T> x, _BinaryNode<T> y, _BinaryNode<T>? p) {
    y.left = x.right;
    x.right = y;
    _changeChild(x, p);
  }

  void _changeChild(_BinaryNode<T> x, _BinaryNode<T>? p) {
    if (p != null) {
      p.setChildByRatio(_compare(x.value, p.value), x);
    } else {
      root = x;
    }
  }

  bool _isLeftChild(_BinaryNode<T> a, _BinaryNode<T> b) =>
      b.left != null && areEqual(a.value, b.left!.value);

  bool _isRightChild(_BinaryNode<T> a, _BinaryNode<T> b) =>
      b.right != null && areEqual(a.value, b.right!.value);
}

class _BinaryNode<T> extends BalanceBinaryNode<T, _BinaryNode<T>> {
  _BinaryNode(T value, [_BinaryNode<T>? left, _BinaryNode<T>? right])
      : super(value, left, right);
}
