import 'linked_binary_node.dart';

abstract class PriorityBinaryNode<K, V, N extends PriorityBinaryNode<K, V, N>>
    extends LinkedBinaryNode<K, V, N> {
  PriorityBinaryNode(super.key, super.value, this.priority);

  num priority;

  N? get lowPriorityChild {
    if (!hasBothChildren) return child;
    return right!.priority > left!.priority ? left : right;
  }
}
