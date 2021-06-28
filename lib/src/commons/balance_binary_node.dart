import 'dart:math';

import 'binary_node.dart';

class BalanceBinaryNode<T, N extends BalanceBinaryNode<T, N>>
    extends BinaryNode<T, N> {
  BalanceBinaryNode(T value, [N? left, N? right]) : super(value, left, right);

  N? _left;
  N? _right;
  N? _parent;

  int _height = 0;

  @override
  N? get left => _left;

  @override
  set left(N? node) {
    if (_left?._parent == this) _left!._parent = null;
    node?._changeParent(this as N);
    _left = node;
    _alignHeight();
  }

  @override
  N? get right => _right;

  @override
  set right(N? node) {
    if (_right?._parent == this) _right!._parent = null;
    node?._changeParent(this as N);
    _right = node;
    _alignHeight();
  }

  N? get parent => _parent;
  N? get tallestChild => _heightDifference < 0 ? right : left;

  bool get isBalanced => _heightDifference.abs() <= 1;
  bool get isUnbalanced => !isBalanced;

  int get _heightDifference => (left?._height ?? -1) - (right?._height ?? -1);

  void _changeParent(N? parent) {
    if (_parent?.left == this) _parent!.left = null;
    if (_parent?.right == this) _parent!.right = null;
    _parent = parent;
  }

  void _alignHeight() {
    final height = _computeHeight();
    final isChangedHeight = _height != height;
    _height = height;
    if (isChangedHeight) _parent?._alignHeight();
  }

  int _computeHeight() {
    if (hasBothChildren) return max(left!._height, right!._height) + 1;
    if (hasSingleChild) return child!._height + 1;
    return 0;
  }
}
