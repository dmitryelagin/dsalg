import '../commons/binary_node.dart';
import '../commons/binary_search_node.dart';
import '../commons/node_change.dart';
import '../utils/iterable_utils.dart';
import 'base_binary_tree.dart';

abstract class BaseBinarySearchTree<T, N extends BinaryNode<T, N>>
    extends BaseBinaryTree<T, N> {
  BaseBinarySearchTree(this._createNode, this._compare);

  final N Function(T) _createNode;
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
      isNotEmpty && areEqual(_compare(item, getClosestTo(item)));

  T get(T item) => getNode(item).value;

  T getClosestTo(T item) => getNodeClosestTo(item).value;

  void insert(T item) {
    insertItem(item);
  }

  void insertAll(Iterable<T> items) {
    items.forEach(insert);
  }

  T? remove(T item) => removeItem(item).previous?.value;

  Iterable<T> removeAll(Iterable<T> items) =>
      items.map(remove).whereNotNull.toList();
}

extension ProtectedBaseBinarySearchTree<T, N extends BinaryNode<T, N>>
    on BaseBinarySearchTree<T, N> {
  bool areEqual(int ratio) => ratio == 0;
  bool areNotEqual(int ratio) => ratio != 0;

  N getNode(T item) {
    if (isEmpty) throw StateError('Nothing to return');
    final node = _getSearchPath(item).last;
    if (areEqual(_compare(item, node.value))) return node;
    throw StateError('Item is not found');
  }

  N getNodeClosestTo(T item) {
    if (isEmpty) throw StateError('Nothing to return');
    final path = _getSearchPath(item);
    var target = path.first, targetRatio = _compare(item, target.value);
    for (final node in path.skip(1)) {
      if (_compare(item, node.value).abs() > targetRatio.abs()) continue;
      target = node;
      targetRatio = _compare(item, target.value);
    }
    return target;
  }

  NodeChange<T, N> insertItem(T item) {
    if (isNotEmpty) {
      final ratio = _compare(item, root!.value);
      if (areNotEqual(ratio)) return _insertNode(item, root!, ratio);
    }
    final node = _createNode(item)..setChildrenFrom(root);
    return NodeChange(root, root = node);
  }

  NodeChange<T, N> removeItem(T item) {
    if (isEmpty) return const NodeChange.unchanged();
    final ratio = _compare(item, root!.value);
    if (areNotEqual(ratio)) return _removeNode(item, root!, ratio);
    if (root!.hasNoChildren) return NodeChange(root, root = null);
    if (root!.hasSingleChild) return NodeChange(root, root = root!.child);
    return _removeNode(root!.value = root!.right!.leftmost.value, root!, 0);
  }

  Iterable<N> _getSearchPath(T item) sync* {
    var node = root;
    while (node != null) {
      yield node;
      final ratio = _compare(item, node.value);
      if (areEqual(ratio)) break;
      node = node.getChildByRatio(ratio);
    }
  }

  NodeChange<T, N> _insertNode(T item, N parent, [int? ratio]) {
    ratio ??= _compare(item, parent.value);
    final node = parent.getChildByRatio(ratio);
    if (node != null) {
      final nodeRatio = _compare(item, node.value);
      if (areNotEqual(nodeRatio)) return _insertNode(item, node, nodeRatio);
    }
    final child = _createNode(item)..setChildrenFrom(node);
    return parent.setChildByRatio(ratio, child);
  }

  NodeChange<T, N> _removeNode(T item, N parent, [int? ratio]) {
    ratio ??= _compare(item, parent.value);
    final node = parent.getChildByRatio(ratio);
    if (node == null) return const NodeChange.unchanged();
    final nodeRatio = _compare(item, node.value);
    if (areNotEqual(nodeRatio)) return _removeNode(item, node, nodeRatio);
    if (node.hasNoChildren) return parent.removeChildByRatio(ratio);
    if (node.hasSingleChild) return parent.setChildByRatio(ratio, node.child);
    return _removeNode(node.value = node.right!.leftmost.value, node, 0);
  }
}
