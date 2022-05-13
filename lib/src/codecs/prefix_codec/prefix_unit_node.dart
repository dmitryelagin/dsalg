import '../../trees/binary_tree/base_binary_node.dart';

class PrefixUnitNode<T> extends BaseBinaryNode<int, T, PrefixUnitNode<T>> {
  PrefixUnitNode(super.key, super.value);

  PrefixUnitNode.utility(T value) : super(-1, value);

  PrefixUnitNode.fromEntry(MapEntry<int, T> entry)
      : super(entry.key, entry.value);

  static PrefixUnitNode<void> blank() => PrefixUnitNode.utility(null);
}
