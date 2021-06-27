import '../commons/binary_node.dart';
import 'base_binary_tree.dart';

abstract class BaseBinarySearchTree<T, N extends BinaryNode<T, N>>
    extends BaseBinaryTree<T, N> {
  BaseBinarySearchTree(this._getNode, this._compare);

  final N Function(T) _getNode;
  final Comparator<T> _compare;

  T get min {
    if (isNotEmpty) return root!.leftmost.value;
    throw StateError('Nothing to return');
  }

  T get max {
    if (isNotEmpty) return root!.rightmost.value;
    throw StateError('Nothing to return');
  }

  bool contains(T item) =>
      isNotEmpty && _areEqual(item, _getSearchPath(item).last);

  T get(T item) {
    if (isEmpty) throw StateError('Nothing to return');
    final value = _getSearchPath(item).last;
    if (_areEqual(item, value)) return value;
    throw StateError('Item is not found');
  }

  T getClosestTo(T item) {
    if (isEmpty) throw StateError('Nothing to return');
    final path = _getSearchPath(item);
    var target = path.first;
    for (final other in path.skip(1)) {
      if (_compare(item, other).abs() <= _compare(item, target).abs()) {
        target = other;
      }
    }
    return target;
  }

  void insert(T item) {
    final node = _getNode(item);
    if (isNotEmpty && _areNotEqual(item, root!.value)) {
      _insertChild(node, root!);
    } else {
      root = node..setChildrenFrom(root);
    }
  }

  void remove(T item) {
    if (isEmpty) return;
    if (_areNotEqual(item, root!.value)) {
      _removeChild(item, root!);
    } else {
      if (root!.hasNoChildren) root = null;
      if (root!.hasSingleChild) root = root!.child;
      if (root!.hasBothChildren) {
        final value = root!.right!.leftmost.value;
        _removeChild(value, root!);
        root = _getNode(value)..setChildrenFrom(root);
      }
    }
  }

  Iterable<T> _getSearchPath(T item) sync* {
    var node = root;
    while (node != null) {
      yield node.value;
      node = node.getChildByRatio(_compare(item, node.value));
    }
  }

  void _insertChild(N node, N parent) {
    final ratio = _compare(node.value, parent.value);
    final child = parent.getChildByRatio(ratio);
    if (child != null && _areNotEqual(node.value, child.value)) {
      _insertChild(node, child);
    } else {
      parent.setChildByRatio(ratio, node..setChildrenFrom(child));
    }
  }

  void _removeChild(T item, N parent) {
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
        parent.setChildByRatio(ratio, _getNode(value)..setChildrenFrom(child));
      }
    }
  }

  bool _areEqual(T a, T b) => _compare(a, b) == 0;
  bool _areNotEqual(T a, T b) => _compare(a, b) != 0;
}

extension _BinarySearchNode<T, N extends BinaryNode<T, N>> on N {
  N? getChildByRatio(int ratio) {
    if (ratio == 0) return null;
    return ratio < 0 ? left : right;
  }

  void setChildByRatio(int ratio, N? node) {
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
