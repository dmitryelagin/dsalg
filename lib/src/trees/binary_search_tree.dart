import '../commons/binary_node.dart';
import 'base_binary_tree.dart';

class BinarySearchTree<T> extends BaseBinaryTree<T> {
  BinarySearchTree(this._compare, [Iterable<T> items = const []]) {
    items.forEach(insert);
  }

  final Comparator<T> _compare;

  T get min {
    if (isEmpty) throw StateError('Nothing to find');
    return root!.leftmost.value;
  }

  T get max {
    if (isEmpty) throw StateError('Nothing to find');
    return root!.rightmost.value;
  }

  bool contains(T item) => _findNode(item, root) != null;

  void insert(T item) {
    final node = BinaryNode(item);
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
        root = BinaryNode.from(value, root);
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

extension _BinarySearchNode<T> on BinaryNode<T> {
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
