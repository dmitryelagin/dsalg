class BinaryNode<T> {
  BinaryNode(this.value, [this.left, this.right]);

  BinaryNode.from(this.value, BinaryNode<T>? other)
      : left = other?.left,
        right = other?.right;

  final T value;

  BinaryNode<T>? left;
  BinaryNode<T>? right;

  BinaryNode<T> get leftmost {
    var node = this;
    while (node.left != null) {
      node = node.left!;
    }
    return node;
  }

  BinaryNode<T> get rightmost {
    var node = this;
    while (node.right != null) {
      node = node.right!;
    }
    return node;
  }

  BinaryNode<T>? get child => left ?? right;

  bool get hasNoChildren => left == null && right == null;
  bool get hasSingleChild => !hasNoChildren && !hasBothChildren;
  bool get hasBothChildren => left != null && right != null;

  void setChildrenFrom(BinaryNode<T>? other) {
    if (other == null) return;
    left = other.left;
    right = other.right;
  }
}
