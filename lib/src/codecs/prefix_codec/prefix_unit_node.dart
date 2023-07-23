import '../../trees/binary_tree/base_binary_node.dart';

class PrefixUnitNode<T> extends BaseBinaryNode<int, T, PrefixUnitNode<T>> {
  PrefixUnitNode(super.key, super.value);

  PrefixUnitNode.utility(T value) : super(-1, value);

  PrefixUnitNode.fromMapEntry(MapEntry<int, T> entry)
      : super(entry.key, entry.value);
}
