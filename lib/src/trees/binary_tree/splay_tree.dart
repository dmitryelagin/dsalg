part of 'binary_tree.dart';

class SplayTree<T> extends _BaseBinarySearchTree<T, _SplayTreeNode<T>> {
  SplayTree(Comparator<T> compare, [Iterable<T> items = const []])
      : super(_createSplayTreeNode, compare) {
    insertAll(items);
  }

  static _SplayTreeNode<T> _createSplayTreeNode<T>(T value) =>
      _SplayTreeNode(value);

  @override
  T get(T item) {
    final node = _getNode(item);
    _splay(node);
    return node.value;
  }

  @override
  T getClosestTo(T item) {
    final node = _getNodeClosestTo(item);
    _splay(node);
    return node.value;
  }

  @override
  void insert(T item) {
    _splay(_insertItem(item).current!);
  }

  @override
  T? remove(T item) {
    if (isEmpty) return null;
    final nodes = _splitNodes(item), first = nodes.first;
    if (first == null) return null;
    _root = _mergeNodes(first.left, nodes.last);
    first.left = null;
    return first.value;
  }

  Iterable<_SplayTreeNode<T>?> _splitNodes(T item) {
    final node = _getNodeClosestTo(item);
    if (_compare.areNotEqual(item, node.value)) return const [null, null];
    _splay(node);
    final nodes = [node, node.right];
    node.right = null;
    return nodes;
  }

  _SplayTreeNode<T>? _mergeNodes(_SplayTreeNode<T>? a, _SplayTreeNode<T>? b) {
    if (a == null) return b;
    if (b == null) return a;
    final node = a.rightmost;
    _splay(node);
    return node..right = b;
  }

  void _splay(_SplayTreeNode<T> x) {
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

class _SplayTreeNode<T> extends LinkedBinaryNode<T, _SplayTreeNode<T>> {
  _SplayTreeNode(T value) : super(value);
}
