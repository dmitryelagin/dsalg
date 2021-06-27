import '../collections/queue.dart';
import '../commons/binary_node.dart';

abstract class BaseBinaryTree<T, N extends BinaryNode<T, N>> {
  N? _root;

  bool get isEmpty => _root == null;
  bool get isNotEmpty => _root != null;

  Iterable<T> get breadthFirstTraversal =>
      _breadthFirstSearch(root).map((node) => node.value);

  Iterable<T> get depthFirstPreOrderTraversal =>
      _depthFirstSearch(_DepthFirstSearchType.preOrder, root)
          .map((node) => node.value);

  Iterable<T> get depthFirstInOrderTraversal =>
      _depthFirstSearch(_DepthFirstSearchType.inOrder, root)
          .map((node) => node.value);

  Iterable<T> get depthFirstPostOrderTraversal =>
      _depthFirstSearch(_DepthFirstSearchType.postOrder, root)
          .map((node) => node.value);

  Iterable<N> _breadthFirstSearch(N? parent) sync* {
    final nodes = Queue([if (parent != null) parent]);
    while (nodes.isNotEmpty) {
      final node = nodes.extract();
      yield node;
      if (node.left != null) nodes.insert(node.left!);
      if (node.right != null) nodes.insert(node.right!);
    }
  }

  Iterable<N> _depthFirstSearch(_DepthFirstSearchType type, N? parent) sync* {
    if (parent == null) return;
    if (type == _DepthFirstSearchType.preOrder) yield parent;
    yield* _depthFirstSearch(type, parent.left);
    if (type == _DepthFirstSearchType.inOrder) yield parent;
    yield* _depthFirstSearch(type, parent.right);
    if (type == _DepthFirstSearchType.postOrder) yield parent;
  }
}

extension ProtectedBaseBinaryTree<T, N extends BinaryNode<T, N>>
    on BaseBinaryTree<T, N> {
  N? get root => _root;

  set root(N? value) {
    _root = value;
  }
}

enum _DepthFirstSearchType {
  preOrder,
  inOrder,
  postOrder,
}
