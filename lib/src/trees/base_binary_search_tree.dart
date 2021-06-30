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
      isNotEmpty && _areEqual(compare(item, _getSearchPath(item).last));

  T get(T item) {
    if (isEmpty) throw StateError('Nothing to return');
    final value = _getSearchPath(item).last;
    if (_areEqual(compare(item, value))) return value;
    throw StateError('Item is not found');
  }

  T getClosestTo(T item) {
    if (isEmpty) throw StateError('Nothing to return');
    final path = _getSearchPath(item);
    var target = path.first, targetRatio = compare(item, target);
    for (final value in path.skip(1)) {
      if (compare(item, value).abs() > targetRatio.abs()) continue;
      target = value;
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

  N insertItem(T item) {
    if (isNotEmpty) {
      final ratio = compare(item, root!.value);
      if (_areNotEqual(ratio)) return _insertNode(item, root!, ratio);
    }
    return root = (_getNode(item)..setChildrenFrom(root));
  }

  N? removeItem(T item) {
    if (isEmpty) return null;
    final ratio = compare(item, root!.value);
    if (_areNotEqual(ratio)) return _removeNode(item, root!, ratio);
    if (root!.hasNoChildren) return root = null;
    if (root!.hasSingleChild) return root = root!.child;
    return _removeNode(root!.value = root!.right!.leftmost.value, root!, 0);
  }

  N _insertNode(T item, N parent, [int? ratio]) {
    ratio ??= compare(item, parent.value);
    final node = parent.getChildByRatio(ratio);
    if (node != null) {
      final nodeRatio = compare(item, node.value);
      if (_areNotEqual(nodeRatio)) return _insertNode(item, node, nodeRatio);
    }
    return parent.setChildByRatio(ratio, _getNode(item)..setChildrenFrom(node));
  }

  N? _removeNode(T item, N parent, [int? ratio]) {
    ratio ??= compare(item, parent.value);
    final node = parent.getChildByRatio(ratio);
    if (node == null) return null;
    final nodeRatio = compare(item, node.value);
    if (_areNotEqual(nodeRatio)) return _removeNode(item, node, nodeRatio);
    if (node.hasNoChildren) return parent..removeChildByRatio(ratio);
    if (node.hasSingleChild) return parent..setChildByRatio(ratio, node.child);
    return _removeNode(node.value = node.right!.leftmost.value, node, 0);
  }

  Iterable<T> _getSearchPath(T item) sync* {
    var node = root;
    while (node != null) {
      yield node.value;
      final ratio = compare(item, node.value);
      if (_areEqual(ratio)) break;
      node = node.getChildByRatio(ratio);
    }
  }

  bool _areEqual(int ratio) => ratio == 0;
  bool _areNotEqual(int ratio) => ratio != 0;
}
