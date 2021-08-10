import '../commons/node.dart';

abstract class BinaryNode<K, V> implements MapEntry<K, V>, Node {
  BinaryNode<K, V>? get left;
  BinaryNode<K, V>? get right;

  BinaryNode<K, V> get leftmost => left?.leftmost ?? this;
  BinaryNode<K, V> get rightmost => right?.rightmost ?? this;

  BinaryNode<K, V>? get child => left ?? right;

  bool get hasLeft => left != null;
  bool get hasRight => right != null;
  bool get hasChild => hasLeft || hasRight;
  bool get hasBothChildren => hasLeft && hasRight;
  bool get hasSingleChild => hasChild && !hasBothChildren;
  bool get hasNoChildren => !hasChild;

  bool isLeftOf(BinaryNode<K, V>? node) => this == node?.left;
  bool isRightOf(BinaryNode<K, V>? node) => this == node?.right;

  MapEntry<K, V> toMapEntry() => MapEntry(key, value);
}
