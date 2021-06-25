import '../collections/queue.dart';
import '../commons/binary_node.dart';

class BinarySearchTree<T> {
  BinarySearchTree(this._compare, [Iterable<T> items = const []]) {
    items.forEach(insert);
  }

  final Comparator<T> _compare;

  BinaryNode<T>? _root;

  bool get isEmpty => _root == null;
  bool get isNotEmpty => _root != null;

  T get min {
    if (isEmpty) throw StateError('Nothing to find');
    return _root!.leftmost.value;
  }

  T get max {
    if (isEmpty) throw StateError('Nothing to find');
    return _root!.rightmost.value;
  }

  Iterable<T> get breadthFirstTraversal =>
      _breadthFirstTraversal(_root).map((node) => node.value);

  Iterable<T> get depthFirstPreOrderTraversal =>
      _depthFirstTraversal(_DepthFirstTraversalType.preOrder, _root)
          .map((node) => node.value);

  Iterable<T> get depthFirstInOrderTraversal =>
      _depthFirstTraversal(_DepthFirstTraversalType.inOrder, _root)
          .map((node) => node.value);

  Iterable<T> get depthFirstPostOrderTraversal =>
      _depthFirstTraversal(_DepthFirstTraversalType.postOrder, _root)
          .map((node) => node.value);

  static Iterable<BinaryNode<T>> _breadthFirstTraversal<T>(
    BinaryNode<T>? parent,
  ) sync* {
    final nodes = Queue([if (parent != null) parent]);
    while (nodes.isNotEmpty) {
      final node = nodes.extract();
      yield node;
      if (node.left != null) nodes.insert(node.left!);
      if (node.right != null) nodes.insert(node.right!);
    }
  }

  static Iterable<BinaryNode<T>> _depthFirstTraversal<T>(
    _DepthFirstTraversalType type,
    BinaryNode<T>? parent,
  ) sync* {
    if (parent == null) return;
    if (type == _DepthFirstTraversalType.preOrder) yield parent;
    yield* _depthFirstTraversal(type, parent.left);
    if (type == _DepthFirstTraversalType.inOrder) yield parent;
    yield* _depthFirstTraversal(type, parent.right);
    if (type == _DepthFirstTraversalType.postOrder) yield parent;
  }

  bool contains(T item) => _findNode(item, _root) != null;

  void insert(T item) {
    final node = BinaryNode(item);
    if (isNotEmpty && _areNotEqual(item, _root!.value)) {
      _insertChild(node, _root!);
    } else {
      _root = node..setChildrenFrom(_root);
    }
  }

  void remove(T item) {
    if (isEmpty) return;
    if (_areNotEqual(item, _root!.value)) {
      _removeChild(item, _root!);
    } else {
      if (_root!.hasNoChildren) _root = null;
      if (_root!.hasSingleChild) _root = _root!.child;
      if (_root!.hasBothChildren) {
        final value = _root!.right!.leftmost.value;
        _removeChild(value, _root!);
        _root = BinaryNode.from(value, _root);
      }
    }
  }

  BinaryNode<T>? _findNode(T item, BinaryNode<T>? parent) {
    if (parent == null) return null;
    final ratio = _compare(item, parent.value);
    if (ratio == 0) return parent;
    return _findNode(item, parent.getChildByRatio(ratio));
  }

  void _insertChild(BinaryNode<T> node, BinaryNode<T> parent) {
    final ratio = _compare(node.value, parent.value);
    final child = parent.getChildByRatio(ratio);
    if (child != null && _areNotEqual(node.value, child.value)) {
      _insertChild(node, child);
    } else {
      parent.setChildByRatio(ratio, node..setChildrenFrom(child));
    }
  }

  void _removeChild(T item, BinaryNode<T> parent) {
    final ratio = _compare(item, parent.value);
    final child = parent.getChildByRatio(ratio);
    if (child == null) return;
    if (_areNotEqual(item, child.value)) {
      _removeChild(item, child);
    } else {
      if (child.hasNoChildren) parent.removeChildByRatio(ratio);
      if (child.hasSingleChild) parent.setChildByRatio(ratio, child.child);
      if (child.hasBothChildren) {
        final value = child.right!.leftmost.value;
        _removeChild(value, child);
        parent.setChildByRatio(ratio, BinaryNode.from(value, child));
      }
    }
  }

  bool _areNotEqual(T a, T b) => _compare(a, b) != 0;
}

extension _BinarySearchTreeNode<T> on BinaryNode<T> {
  BinaryNode<T>? getChildByRatio(int ratio) {
    if (ratio == 0) return null;
    return ratio < 0 ? left : right;
  }

  void setChildByRatio(int ratio, BinaryNode<T>? node) {
    if (ratio == 0) return;
    if (ratio < 0) {
      left = node;
    } else {
      right = node;
    }
  }

  void removeChildByRatio(int ratio) {
    setChildByRatio(ratio, null);
  }
}

enum _DepthFirstTraversalType {
  preOrder,
  inOrder,
  postOrder,
}
