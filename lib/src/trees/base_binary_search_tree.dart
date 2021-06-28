import '../commons/binary_node.dart';
import '../commons/binary_search_node.dart';
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
      isNotEmpty && areEqual(item, _getSearchPath(item).last);

  T get(T item) {
    if (isEmpty) throw StateError('Nothing to return');
    final value = _getSearchPath(item).last;
    if (areEqual(item, value)) return value;
    throw StateError('Item is not found');
  }

  T getClosestTo(T item) {
    if (isEmpty) throw StateError('Nothing to return');
    final path = _getSearchPath(item);
    var target = path.first;
    for (final value in path.skip(1)) {
      if (_compare(item, value).abs() <= _compare(item, target).abs()) {
        target = value;
      }
    }
    return target;
  }

  void insert(T item) {
    insertItem(item);
  }

  void insertAll(Iterable<T> items) {
    items.forEach(insertItem);
  }

  void remove(T item) {
    removeItem(item);
  }

  void removeAll(Iterable<T> items) {
    items.forEach(removeItem);
  }
}

extension BaseBinarySearchTreeUtils<T, N extends BinaryNode<T, N>>
    on BaseBinarySearchTree<T, N> {
  bool areEqual(T a, T b) => _compare(a, b) == 0;
  bool areNotEqual(T a, T b) => _compare(a, b) != 0;

  N insertItem(T item) {
    final node = _getNode(item);
    if (isNotEmpty && areNotEqual(item, root!.value)) {
      return _insertNode(node, root!);
    } else {
      return root = node..setChildrenFrom(root);
    }
  }

  N? removeItem(T item) {
    if (isEmpty) return null;
    if (areNotEqual(item, root!.value)) {
      return _removeNode(item, root!);
    } else {
      if (root!.hasNoChildren) root = null;
      if (root!.hasSingleChild) root = root!.child;
      if (root!.hasBothChildren) {
        final value = root!.right!.leftmost.value;
        _removeNode(value, root!);
        root = _getNode(value)..setChildrenFrom(root);
      }
      return root;
    }
  }

  N _insertNode(N node, N parent) {
    final ratio = _compare(node.value, parent.value);
    final child = parent.getChildByRatio(ratio);
    if (child != null && areNotEqual(node.value, child.value)) {
      return _insertNode(node, child);
    } else {
      parent.setChildByRatio(ratio, node..setChildrenFrom(child));
      return node;
    }
  }

  N? _removeNode(T item, N parent) {
    final ratio = _compare(item, parent.value);
    final child = parent.getChildByRatio(ratio);
    if (child == null) return null;
    if (areNotEqual(item, child.value)) {
      return _removeNode(item, child);
    } else {
      if (child.hasNoChildren) parent.removeChildByRatio(ratio);
      if (child.hasSingleChild) parent.setChildByRatio(ratio, child.child);
      if (child.hasBothChildren) {
        final value = child.right!.leftmost.value;
        _removeNode(value, child);
        parent.setChildByRatio(ratio, _getNode(value)..setChildrenFrom(child));
      }
      return parent.getChildByRatio(ratio) ?? parent;
    }
  }

  Iterable<T> _getSearchPath(T item) sync* {
    var node = root;
    while (node != null) {
      yield node.value;
      node = node.getChildByRatio(_compare(item, node.value));
    }
  }
}
