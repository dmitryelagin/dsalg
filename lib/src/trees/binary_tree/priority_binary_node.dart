import 'linked_binary_node.dart';

class PriorityBinaryNode<K, V, N extends PriorityBinaryNode<K, V, N>>
    extends LinkedBinaryNode<K, V, N> {
  PriorityBinaryNode(super.key, super.value, this.priority);

  double priority;

  N? get lowPriorityChild {
    if (!hasBothChildren) return child;
    return right!.priority > left!.priority ? left : right;
  }
}
