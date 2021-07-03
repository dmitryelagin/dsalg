import '../commons/binary_node.dart';
import '../commons/binary_search_node.dart';
import '../commons/node_change.dart';
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
      isNotEmpty && areEqual(compare(item, getSearchPath(item).last.value));

  T get(T item) {
    if (isEmpty) throw StateError('Nothing to return');
    final value = getSearchPath(item).last.value;
    if (areEqual(compare(item, value))) return value;
    throw StateError('Item is not found');
  }

  T getClosestTo(T item) {
    if (isEmpty) throw StateError('Nothing to return');
    final path = getSearchPath(item);
    var target = path.first.value, targetRatio = compare(item, target);
    for (final node in path.skip(1)) {
      if (compare(item, node.value).abs() > targetRatio.abs()) continue;
      target = node.value;
      targetRatio = compare(item, target);
    }
    return target;
  }

  void insert(T item) {
    insertItem(item);
  }

  void insertAll(Iterable<T> items) {
    items.forEach(insert);
  }

  void remove(T item) {
    removeItem(item);
  }

  void removeAll(Iterable<T> items) {
    items.forEach(remove);
  }
}

extension BaseBinarySearchTreeUtils<T, N extends BinaryNode<T, N>>
    on BaseBinarySearchTree<T, N> {
  int compare(T a, T b) => _compare(a, b);

  bool areEqual(int ratio) => ratio == 0;
  bool areNotEqual(int ratio) => ratio != 0;

  Iterable<N> getSearchPath(T item) sync* {
    var node = root;
    while (node != null) {
      yield node;
      final ratio = compare(item, node.value);
      if (areEqual(ratio)) break;
      node = node.getChildByRatio(ratio);
    }
  }

  NodeChange<T, N> insertItem(T item) {
    if (isNotEmpty) {
      final ratio = compare(item, root!.value);
      if (areNotEqual(ratio)) return _insertNode(item, root!, ratio);
    }
    final node = _getNode(item)..setChildrenFrom(root);
    return NodeChange(root, root = node);
  }

  NodeChange<T, N> removeItem(T item) {
    if (isEmpty) return const NodeChange.unchanged();
    final ratio = compare(item, root!.value);
    if (areNotEqual(ratio)) return _removeNode(item, root!, ratio);
    if (root!.hasNoChildren) return NodeChange(root, root = null);
    if (root!.hasSingleChild) return NodeChange(root, root = root!.child);
    return _removeNode(root!.value = root!.right!.leftmost.value, root!, 0);
  }

  NodeChange<T, N> _insertNode(T item, N parent, [int? ratio]) {
    ratio ??= compare(item, parent.value);
    final node = parent.getChildByRatio(ratio);
    if (node != null) {
      final nodeRatio = compare(item, node.value);
      if (areNotEqual(nodeRatio)) return _insertNode(item, node, nodeRatio);
    }
    return parent.setChildByRatio(ratio, _getNode(item)..setChildrenFrom(node));
  }

  NodeChange<T, N> _removeNode(T item, N parent, [int? ratio]) {
    ratio ??= compare(item, parent.value);
    final node = parent.getChildByRatio(ratio);
    if (node == null) return const NodeChange.unchanged();
    final nodeRatio = compare(item, node.value);
    if (areNotEqual(nodeRatio)) return _removeNode(item, node, nodeRatio);
    if (node.hasNoChildren) return parent.removeChildByRatio(ratio);
    if (node.hasSingleChild) return parent.setChildByRatio(ratio, node.child);
    return _removeNode(node.value = node.right!.leftmost.value, node, 0);
  }
}
