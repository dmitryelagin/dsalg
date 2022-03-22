import 'binary_node.dart';

class LinkedBinaryNode<K, V, N extends LinkedBinaryNode<K, V, N>>
    extends BinaryNode<K, V, N> {
  LinkedBinaryNode(super.key, super.value);

  N? _parent;

  @override
  set left(N? node) {
    if (left?.parent == this) left!._parent = null;
    node?._changeParent(this as N);
    super.left = node;
  }

  @override
  set right(N? node) {
    if (right?.parent == this) right!._parent = null;
    node?._changeParent(this as N);
    super.right = node;
  }

  N? get parent => _parent;

  N? get sibling {
    if (isLeftOf(parent)) return parent!.right;
    if (isRightOf(parent)) return parent!.left;
    return null;
  }

  bool get hasParent => parent != null;
  bool get hasNoParent => parent == null;

  void rotateLeft() {
    final node = right;
    if (node == null) throw StateError('No right child, can not left-rotate');
    if (isLeftOf(parent)) parent!.left = node;
    if (isRightOf(parent)) parent!.right = node;
    node.left = (this as N)..right = node.left;
  }

  void rotateRight() {
    final node = left;
    if (node == null) throw StateError('No left child, can not right-rotate');
    if (isLeftOf(parent)) parent!.left = node;
    if (isRightOf(parent)) parent!.right = node;
    node.right = (this as N)..left = node.right;
  }

  void _changeParent(N? node) {
    if (isLeftOf(parent)) parent!.left = null;
    if (isRightOf(parent)) parent!.right = null;
    _parent = node;
  }
}
