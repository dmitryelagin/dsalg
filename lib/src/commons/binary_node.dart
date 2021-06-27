class BinaryNode<T, N extends BinaryNode<T, N>> {
  BinaryNode(this.value, [this.left, this.right]);

  final T value;

  N? left;
  N? right;

  N get leftmost => left?.leftmost ?? (this as N);
  N get rightmost => right?.rightmost ?? (this as N);

  N? get child => left ?? right;

  bool get hasNoChildren => left == null && right == null;
  bool get hasSingleChild => !hasNoChildren && !hasBothChildren;
  bool get hasBothChildren => left != null && right != null;

  void setChildrenFrom(N? other) {
    if (other == null) return;
    left = other.left;
    right = other.right;
  }
}
