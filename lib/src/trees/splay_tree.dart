import '../commons/linked_binary_node.dart';
import 'base_binary_search_tree.dart';
import 'base_binary_tree.dart';

class SplayTree<T> extends BaseBinarySearchTree<T, _BinaryNode<T>> {
  SplayTree(this._compare, [Iterable<T> items = const []])
      : super(_createNode, _compare) {
    insertAll(items);
  }

  final Comparator<T> _compare;

  static _BinaryNode<T> _createNode<T>(T value) => _BinaryNode(value);

  @override
  T get(T item) {
    final node = getNode(item);
    _splay(node);
    return node.value;
  }

  @override
  T getClosestTo(T item) {
    final node = getNodeClosestTo(item);
    _splay(node);
    return node.value;
  }

  @override
  void insert(T item) {
    _splay(insertItem(item).current!);
  }

  @override
  T? remove(T item) {
    if (isEmpty) return null;
    final nodes = _splitNodes(item), first = nodes.first;
    if (first == null) return null;
    root = _mergeNodes(first.left, nodes.last);
    first.left = null;
    return first.value;
  }

  Iterable<_BinaryNode<T>?> _splitNodes(T item) {
    final node = getNodeClosestTo(item);
    if (areNotEqual(_compare(item, node.value))) return const [null, null];
    _splay(node);
    final nodes = [node, node.right];
    node.right = null;
    return nodes;
  }

  _BinaryNode<T>? _mergeNodes(_BinaryNode<T>? a, _BinaryNode<T>? b) {
    if (a == null) return b;
    if (b == null) return a;
    final node = a.rightmost;
    _splay(node);
    return node..right = b;
  }

  void _splay(_BinaryNode<T> x) {
    root = x;
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

class _BinaryNode<T> extends LinkedBinaryNode<T, _BinaryNode<T>> {
  _BinaryNode(T value) : super(value);
}
