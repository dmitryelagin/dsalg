import 'dart:math';

import 'linked_binary_node.dart';

class BalanceBinaryNode<K, V, N extends BalanceBinaryNode<K, V, N>>
    extends LinkedBinaryNode<K, V, N> {
  BalanceBinaryNode(super.key, super.value);

  var _height = 0;

  @override
  set left(N? node) {
    super.left = node;
    _alignHeight();
  }

  @override
  set right(N? node) {
    super.right = node;
    _alignHeight();
  }

  N? get tallestChild {
    if (_heightDifference == 0) return isLeftOf(parent) ? left : right;
    return _heightDifference > 0 ? left : right;
  }

  bool get isBalanced => _heightDifference.abs() <= 1;
  bool get isUnbalanced => _heightDifference.abs() > 1;

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
