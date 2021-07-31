part of 'binary_tree.dart';

abstract class _BaseBinarySearchTree<T, N extends BinaryNode<T, N>>
    extends _BaseBinaryTree<T, N> {
  _BaseBinarySearchTree(this._createNode, Comparator<T> compare)
      : _compare = Comparator(compare);

  final N Function(T) _createNode;
  final Comparator<T> _compare;

  T get min {
    if (isNotEmpty) return _root!.leftmost.value;
    throw StateError('Nothing to return');
  }

  T get max {
    if (isNotEmpty) return _root!.rightmost.value;
    throw StateError('Nothing to return');
  }

  bool contains(T item) =>
      isNotEmpty && _compare.areEqual(item, getClosestTo(item));

  T get(T item) => _getNode(item).value;

  T getClosestTo(T item) => _getNodeClosestTo(item).value;

  void insert(T item) {
    _insertItem(item);
  }

  void insertAll(Iterable<T> items) {
    items.forEach(insert);
  }

  T? remove(T item) => _removeItem(item).previous?.value;

  Iterable<T> removeAll(Iterable<T> items) =>
      items.map(remove).whereNotNull.toList();

  @override
  void invert() {
    _compare.invert();
    super.invert();
  }

  N _getNode(T item) {
    if (isEmpty) throw StateError('Nothing to return');
    final node = _getSearchPath(item).last;
    if (_compare.areEqual(item, node.value)) return node;
    throw StateError('Item is not found');
  }

  N _getNodeClosestTo(T item) {
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

  Iterable<N> _getSearchPath(T item) sync* {
    var node = _root;
    while (node != null) {
      yield node;
      final ratio = _compare(item, node.value);
      if (ratio == 0) break;
      node = node.getChildByRatio(ratio);
    }
  }

  NodeChange<T, N> _insertItem(T item) {
    if (isNotEmpty && _compare.areNotEqual(item, _root!.value)) {
      return _insertChild(item, _root!);
    }
    final node = _createNode(item)..setChildrenFrom(_root);
    return NodeChange(_root, _root = node);
  }

  NodeChange<T, N> _insertChild(T item, N parent) {
    final ratio = _compare(item, parent.value);
    final node = parent.getChildByRatio(ratio);
    if (node != null && _compare.areNotEqual(item, node.value)) {
      return _insertChild(item, node);
    }
    final child = _createNode(item)..setChildrenFrom(node);
    return parent.setChildByRatio(ratio, child);
  }

  NodeChange<T, N> _removeItem(T item) {
    if (isEmpty) return const NodeChange.unchanged();
    if (_compare.areNotEqual(item, _root!.value)) {
      return _removeChild(item, _root!);
    }
    if (_root!.hasNoChildren) return NodeChange(_root, _root = null);
    if (_root!.hasSingleChild) return NodeChange(_root, _root = _root!.child);
    return _removeChild(_root!.value = _root!.right!.leftmost.value, _root!);
  }

  NodeChange<T, N> _removeChild(T item, N parent) {
    final ratio = _compare(item, parent.value);
    final node = parent.getChildByRatio(ratio);
    if (node == null) return const NodeChange.unchanged();
    if (_compare.areNotEqual(item, node.value)) {
      return _removeChild(item, node);
    }
    if (node.hasNoChildren) return parent.setChildByRatio(ratio, null);
    if (node.hasSingleChild) return parent.setChildByRatio(ratio, node.child);
    return _removeChild(node.value = node.right!.leftmost.value, node);
  }
}

extension _BaseBinarySearchTreeNodeUtils<T, N extends BinaryNode<T, N>>
    on BinaryNode<T, N> {
  N? getChildByRatio(int ratio) => ratio < 0 ? left : right;

  NodeChange<T, N> setChildByRatio(int ratio, N? node) => NodeChange(
        getChildByRatio(ratio),
        ratio < 0 ? left = node : right = node,
        this as N,
      );
}
