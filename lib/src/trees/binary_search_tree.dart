import '../commons/binary_node.dart';
import 'base_binary_tree.dart';

class BinarySearchTree<T> extends BaseBinaryTree<T> {
  BinarySearchTree(this._compare, [Iterable<T> items = const []]) {
    items.forEach(insert);
  }

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
      isNotEmpty && _areEqual(item, _getItemCloseTo(item, root!));

  T get(T item) {
    if (isEmpty) throw StateError('Nothing to return');
    final value = _getItemCloseTo(item, root!);
    if (_areEqual(item, value)) return value;
    throw StateError('Item is not found');
  }

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

  T _getItemCloseTo(T item, BinaryNode<T> parent) {
    final child = parent.getChildByRatio(_compare(item, parent.value));
    return child == null ? parent.value : _getItemCloseTo(item, child);
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

  bool _areEqual(T a, T b) => _compare(a, b) == 0;
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
