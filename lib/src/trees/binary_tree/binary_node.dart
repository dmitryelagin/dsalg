import '../commons/node.dart';

class BinaryNode<K, V, N extends BinaryNode<K, V, N>> implements Node {
  BinaryNode(this.key, this.value);

  K key;
  V value;

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

  MapEntry<K, V> toEntry() => MapEntry(key, value);

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
