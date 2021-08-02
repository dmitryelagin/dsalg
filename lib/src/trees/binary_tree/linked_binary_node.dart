import 'binary_node.dart';

class LinkedBinaryNode<K, V, N extends LinkedBinaryNode<K, V, N>>
    extends BinaryNode<K, V, N> {
  LinkedBinaryNode(K key, V value) : super(key, value);

  N? _left;
  N? _right;
  N? _parent;

  @override
  N? get left => _left;

  @override
  set left(N? node) {
    if (_left?.parent == this) _left!._parent = null;
    node?._changeParent(this as N);
    _left = node;
  }

  @override
  N? get right => _right;

  @override
  set right(N? node) {
    if (_right?.parent == this) _right!._parent = null;
    node?._changeParent(this as N);
    _right = node;
  }

  N? get parent => _parent;

  N? get sibling {
    if (isLeftOf(parent)) return parent!.right;
    if (isRightOf(parent)) return parent!.left;
  }

  bool get hasParent => !hasNoParent;
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
