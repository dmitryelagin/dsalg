part of 'binary_tree.dart';

abstract class _BaseBinaryTree<K, V> {
  BinaryNode<K, V>? get _root;

  bool get isEmpty => _root == null;
  bool get isNotEmpty => _root != null;

  Iterable<K> get keys => depthFirstInOrderTraversalKeys;
  Iterable<V> get values => depthFirstInOrderTraversalValues;
  Iterable<MapEntry<K, V>> get entries => depthFirstInOrderTraversalEntries;

  Iterable<K> get breadthFirstTraversalKeys =>
      _breadthFirstTraversal.map(_getKey);

  Iterable<K> get depthFirstPreOrderTraversalKeys =>
      _depthFirstPreOrderTraversal.map(_getKey);

  Iterable<K> get depthFirstInOrderTraversalKeys =>
      _depthFirstInOrderTraversal.map(_getKey);

  Iterable<K> get depthFirstPostOrderTraversalKeys =>
      _depthFirstPostOrderTraversal.map(_getKey);

  Iterable<V> get breadthFirstTraversalValues =>
      _breadthFirstTraversal.map(_getValue);

  Iterable<V> get depthFirstPreOrderTraversalValues =>
      _depthFirstPreOrderTraversal.map(_getValue);

  Iterable<V> get depthFirstInOrderTraversalValues =>
      _depthFirstInOrderTraversal.map(_getValue);

  Iterable<V> get depthFirstPostOrderTraversalValues =>
      _depthFirstPostOrderTraversal.map(_getValue);

  Iterable<MapEntry<K, V>> get breadthFirstTraversalEntries =>
      _breadthFirstTraversal.map(_getEntry);

  Iterable<MapEntry<K, V>> get depthFirstPreOrderTraversalEntries =>
      _depthFirstPreOrderTraversal.map(_getEntry);

  Iterable<MapEntry<K, V>> get depthFirstInOrderTraversalEntries =>
      _depthFirstInOrderTraversal.map(_getEntry);

  Iterable<MapEntry<K, V>> get depthFirstPostOrderTraversalEntries =>
      _depthFirstPostOrderTraversal.map(_getEntry);

  Iterable<BinaryNode<K, V>> get _breadthFirstTraversal =>
      _breadthFirstSearch(_root);

  Iterable<BinaryNode<K, V>> get _depthFirstPreOrderTraversal =>
      _depthFirstSearch(_DepthFirstSearchType.preOrder, _root);

  Iterable<BinaryNode<K, V>> get _depthFirstInOrderTraversal =>
      _depthFirstSearch(_DepthFirstSearchType.inOrder, _root);

  Iterable<BinaryNode<K, V>> get _depthFirstPostOrderTraversal =>
      _depthFirstSearch(_DepthFirstSearchType.postOrder, _root);

  K _getKey(BinaryNode<K, V> node) => node.key;
  V _getValue(BinaryNode<K, V> node) => node.value;
  MapEntry<K, V> _getEntry(BinaryNode<K, V> node) => node.toMapEntry();

  Iterable<BinaryNode<K, V>> _breadthFirstSearch(
    BinaryNode<K, V>? parent,
  ) sync* {
    final nodes = Queue([if (parent != null) parent]);
    while (nodes.isNotEmpty) {
      final node = nodes.extract();
      yield node;
      if (node.left != null) nodes.insert(node.left!);
      if (node.right != null) nodes.insert(node.right!);
    }
  }

  Iterable<BinaryNode<K, V>> _depthFirstSearch(
    _DepthFirstSearchType type,
    BinaryNode<K, V>? parent,
  ) sync* {
    if (parent == null) return;
    if (type == _DepthFirstSearchType.preOrder) yield parent;
    yield* _depthFirstSearch(type, parent.left);
    if (type == _DepthFirstSearchType.inOrder) yield parent;
    yield* _depthFirstSearch(type, parent.right);
    if (type == _DepthFirstSearchType.postOrder) yield parent;
  }
}

enum _DepthFirstSearchType {
  preOrder,
  inOrder,
  postOrder,
}
