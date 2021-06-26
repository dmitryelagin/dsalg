import '../collections/queue.dart';
import '../commons/binary_node.dart';

abstract class BaseBinaryTree<T> {
  BinaryNode<T>? _root;

  bool get isEmpty => _root == null;
  bool get isNotEmpty => _root != null;

  Iterable<T> get breadthFirstTraversal =>
      _breadthFirstTraversal(root).map((node) => node.value);

  Iterable<T> get depthFirstPreOrderTraversal =>
      _depthFirstTraversal(_DepthFirstTraversalType.preOrder, root)
          .map((node) => node.value);

  Iterable<T> get depthFirstInOrderTraversal =>
      _depthFirstTraversal(_DepthFirstTraversalType.inOrder, root)
          .map((node) => node.value);

  Iterable<T> get depthFirstPostOrderTraversal =>
      _depthFirstTraversal(_DepthFirstTraversalType.postOrder, root)
          .map((node) => node.value);

  static Iterable<BinaryNode<T>> _breadthFirstTraversal<T>(
    BinaryNode<T>? parent,
  ) sync* {
    final nodes = Queue([if (parent != null) parent]);
    while (nodes.isNotEmpty) {
      final node = nodes.extract();
      yield node;
      if (node.left != null) nodes.insert(node.left!);
      if (node.right != null) nodes.insert(node.right!);
    }
  }

  static Iterable<BinaryNode<T>> _depthFirstTraversal<T>(
    _DepthFirstTraversalType type,
    BinaryNode<T>? parent,
  ) sync* {
    if (parent == null) return;
    if (type == _DepthFirstTraversalType.preOrder) yield parent;
    yield* _depthFirstTraversal(type, parent.left);
    if (type == _DepthFirstTraversalType.inOrder) yield parent;
    yield* _depthFirstTraversal(type, parent.right);
    if (type == _DepthFirstTraversalType.postOrder) yield parent;
  }
}

extension ProtectedBaseBinaryTree<T> on BaseBinaryTree<T> {
  BinaryNode<T>? get root => _root;

  set root(BinaryNode<T>? value) {
    _root = value;
  }
}

enum _DepthFirstTraversalType {
  preOrder,
  inOrder,
  postOrder,
}
