import 'binary_node.dart';

class LinkedBinaryNode<T, N extends LinkedBinaryNode<T, N>>
    extends BinaryNode<T, N> {
  LinkedBinaryNode(T value, [N? left, N? right]) : super(value, left, right);

  N? _left;
  N? _right;
  N? _parent;

  @override
  N? get left => _left;

  @override
  set left(N? node) {
    if (_left?._parent == this) _left!._parent = null;
    node?._changeParent(this as N);
    _left = node;
  }

  @override
  N? get right => _right;

  @override
  set right(N? node) {
    if (_right?._parent == this) _right!._parent = null;
    node?._changeParent(this as N);
    _right = node;
  }

  N? get parent => _parent;

  N? get sibling {
    if (_parent == null) return null;
    return _parent!.left == this ? _parent!.right : _parent!.left;
  }

  void _changeParent(N? parent) {
    if (_parent?.left == this) _parent!.left = null;
    if (_parent?.right == this) _parent!.right = null;
    _parent = parent;
  }
}
