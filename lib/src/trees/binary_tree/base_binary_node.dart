abstract class BaseBinaryNode<K, V, N extends BaseBinaryNode<K, V, N>>
    implements MapEntry<K, V> {
  BaseBinaryNode(this.key, this.value);

  BaseBinaryNode.fromMapEntry(MapEntry<K, V> entry)
      : key = entry.key,
        value = entry.value;

  @override
  K key;

  @override
  V value;

  N? left, right;

  N get leftmost => left?.leftmost ?? (this as N);
  N get rightmost => right?.rightmost ?? (this as N);

  N? get child => left ?? right;

  bool get hasLeft => left != null;
  bool get hasRight => right != null;
  bool get hasChild => hasLeft || hasRight;
  bool get hasBothChildren => hasLeft && hasRight;
  bool get hasSingleChild => hasChild && !hasBothChildren;
  bool get hasNoChildren => !hasChild;

  bool isLeftOf(N? node) => this == node?.left;
  bool isRightOf(N? node) => this == node?.right;

  MapEntry<K, V> toMapEntry() => MapEntry(key, value);

  void setEntryFrom(N? other) {
    if (other == null) return;
    key = other.key;
    value = other.value;
  }

  void setChildrenFrom(N? other) {
    if (other == null) return;
    left = other.left;
    right = other.right;
  }

  void swapChildren() {
    final node = left;
    left = right;
    right = node;
  }

  void clearChildren() {
    left = null;
    right = null;
  }
}
