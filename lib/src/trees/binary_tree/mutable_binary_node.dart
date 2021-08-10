import 'binary_node.dart';

class MutableBinaryNode<K, V, N extends MutableBinaryNode<K, V, N>>
    extends BinaryNode<K, V> {
  MutableBinaryNode(this.key, this.value);

  @override
  K key;

  @override
  V value;

  @override
  N? left;

  @override
  N? right;

  @override
  N get leftmost => super.leftmost as N;

  @override
  N get rightmost => super.rightmost as N;

  @override
  N? get child => super.child as N?;

  void setEntryFrom(BinaryNode<K, V>? other) {
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
