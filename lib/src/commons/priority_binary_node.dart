import 'linked_binary_node.dart';

class PriorityBinaryNode<T, N extends PriorityBinaryNode<T, N>>
    extends LinkedBinaryNode<T, N> {
  PriorityBinaryNode(T value, this.priority) : super(value);

  double priority;

  N? get lowPriorityChild {
    if (!hasBothChildren) return child;
    return right!.priority > left!.priority ? left : right;
  }
}
