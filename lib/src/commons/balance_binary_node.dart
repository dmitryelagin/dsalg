import 'dart:math';

import 'linked_binary_node.dart';

class BalanceBinaryNode<T, N extends BalanceBinaryNode<T, N>>
    extends LinkedBinaryNode<T, N> {
  BalanceBinaryNode(T value, [N? left, N? right]) : super(value, left, right);

  int _height = 0;

  @override
  N? get left => super.left;

  @override
  set left(N? node) {
    super.left = node;
    _alignHeight();
  }

  @override
  N? get right => super.right;

  @override
  set right(N? node) {
    super.right = node;
    _alignHeight();
  }

  N? get tallestChild => _heightDifference < 0 ? right : left;

  bool get isBalanced => _heightDifference.abs() <= 1;
  bool get isUnbalanced => !isBalanced;

  int get _heightDifference => (left?._height ?? -1) - (right?._height ?? -1);

  void _alignHeight() {
    final height = _computeHeight();
    final isChangedHeight = _height != height;
    _height = height;
    if (isChangedHeight) parent?._alignHeight();
  }

  int _computeHeight() {
    if (hasBothChildren) return max(left!._height, right!._height) + 1;
    if (hasSingleChild) return child!._height + 1;
    return 0;
  }
}
