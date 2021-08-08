part of 'binary_tree.dart';

abstract class _BaseBinarySearchTree<K, V, N extends BinaryNode<K, V, N>>
    extends _BaseBinaryTree<K, V, N> {
  _BaseBinarySearchTree(this._createNode, this._compare);

  final N Function(K, V) _createNode;
  final Comparator<K> _compare;

  MapEntry<K, V> get min {
    _assertIsNotEmpty();
    return _root!.leftmost.toMapEntry();
  }

  MapEntry<K, V> get max {
    _assertIsNotEmpty();
    return _root!.rightmost.toMapEntry();
  }

  V operator [](K key) => _getNode(key).value;

  void operator []=(K key, V value) {
    add(key, value);
  }

  MapEntry<K, V> getClosestTo(K key) => _getNodeClosestTo(key).toMapEntry();

  bool containsKey(K key) =>
      isNotEmpty && _compare.areEqual(key, _getNodeClosestTo(key).key);

  void add(K key, V value) {
    _addItem(key, value);
  }

  void addAll(Map<K, V> entries) {
    entries.forEach(add);
  }

  V? remove(K key) => _removeItem(key).first?.value;

  Iterable<V> removeAll(Iterable<K> keys) =>
      keys.map(remove).whereNotNull.toList();

  @override
  void invert() {
    _compare.invert();
    super.invert();
  }

  N _getNode(K key) {
    _assertIsNotEmpty();
    final node = _getSearchPath(key).last;
    if (_compare.areEqual(key, node.key)) return node;
    throw StateError('Item is not found');
  }

  N _getNodeClosestTo(K key) {
    _assertIsNotEmpty();
    final path = _getSearchPath(key);
    var target = path.first, targetRatio = _compare(key, target.key).abs();
    for (final node in path.skip(1)) {
      if (_compare(key, node.key).abs() > targetRatio) continue;
      target = node;
      targetRatio = _compare(key, target.key).abs();
    }
    return target;
  }

  Iterable<N> _getSearchPath(K key) sync* {
    var node = _root;
    while (node != null) {
      yield node;
      final ratio = _compare(key, node.key);
      if (ratio == 0) break;
      node = node.getChildByRatio(ratio);
    }
  }

  NodeTuple<N> _addItem(K key, V value) {
    if (isNotEmpty && _compare.areNotEqual(key, _root!.key)) {
      return _addChild(key, value, _root!);
    }
    final node = _createNode(key, value)..setChildrenFrom(_root);
    return NodeTuple(_root, _root = node);
  }

  NodeTuple<N> _addChild(K key, V value, N parent) {
    final ratio = _compare(key, parent.key);
    final node = parent.getChildByRatio(ratio);
    if (node != null && _compare.areNotEqual(key, node.key)) {
      return _addChild(key, value, node);
    }
    final child = _createNode(key, value)..setChildrenFrom(node);
    return parent.setChildByRatio(ratio, child);
  }

  NodeTuple<N> _removeItem(K key) {
    if (isEmpty) return const NodeTuple.empty();
    if (_compare.areNotEqual(key, _root!.key)) {
      return _removeChild(key, _root!);
    }
    if (_root!.hasNoChildren) return NodeTuple(_root, _root = null);
    if (_root!.hasSingleChild) return NodeTuple(_root, _root = _root!.child);
    _root!.setEntryFrom(_root!.right!.leftmost);
    return _removeChild(_root!.key, _root!);
  }

  NodeTuple<N> _removeChild(K key, N parent) {
    final ratio = _compare(key, parent.key);
    final node = parent.getChildByRatio(ratio);
    if (node == null) return const NodeTuple.empty();
    if (_compare.areNotEqual(key, node.key)) {
      return _removeChild(key, node);
    }
    if (node.hasNoChildren) return parent.setChildByRatio(ratio, null);
    if (node.hasSingleChild) return parent.setChildByRatio(ratio, node.child);
    node.setEntryFrom(node.right!.leftmost);
    return _removeChild(node.key, node);
  }

  void _assertIsNotEmpty() {
    if (isEmpty) throw StateError('Nothing to return');
  }
}

extension _BaseBinarySearchTreeNodeUtils<K, V, N extends BinaryNode<K, V, N>>
    on BinaryNode<K, V, N> {
  N? getChildByRatio(int ratio) => ratio < 0 ? left : right;

  NodeTuple<N> setChildByRatio(int ratio, N? node) => NodeTuple(
        getChildByRatio(ratio),
        ratio < 0 ? left = node : right = node,
        this as N,
      );
}
