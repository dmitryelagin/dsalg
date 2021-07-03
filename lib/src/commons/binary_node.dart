import 'node.dart';

class BinaryNode<T, N extends BinaryNode<T, N>> implements Node<T, N> {
  BinaryNode(this.value);

  @override
  T value;

  N? left;
  N? right;

  N get leftmost => left?.leftmost ?? (this as N);
  N get rightmost => right?.rightmost ?? (this as N);

  N? get child => left ?? right;

  bool get hasLeft => left != null;
  bool get hasRight => right != null;
  bool get hasChild => child != null;
  bool get hasNoChildren => child == null;
  bool get hasBothChildren => hasLeft && hasRight;
  bool get hasSingleChild => !hasNoChildren && !hasBothChildren;

  bool isLeftOf(N? node) => this == node?.left;
  bool isRightOf(N? node) => this == node?.right;

  void setChildrenFrom(N? other) {
    if (other == null) return;
    left = other.left;
    right = other.right;
  }

  void clearChildren() {
    left = null;
    right = null;
  }
}
