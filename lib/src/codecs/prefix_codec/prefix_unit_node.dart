import '../../trees/binary_tree/base_binary_node.dart';
import 'prefix_codec.dart';

class PrefixUnitNode<T> extends BaseBinaryNode<int, T, PrefixUnitNode<T>> {
  PrefixUnitNode(super.key, super.value);

  PrefixUnitNode.utility(T value) : super(-1, value);

  PrefixUnitNode.fromEntry(MapEntry<int, T> entry)
      : super(entry.key, entry.value);

  static PrefixUnitNode<void> blank() => PrefixUnitNode.utility(null);

  static PrefixUnitNode<void> fromDictionary(PrefixDictionary dictionary) {
    final root = PrefixUnitNode.blank();
    var node = root;
    for (final unit in dictionary.keys) {
      for (final isRight in dictionary[unit]!) {
        node = isRight
            ? node.right ??= PrefixUnitNode.blank()
            : node.left ??= PrefixUnitNode.blank();
      }
      node.key = unit;
      node = root;
    }
    return root;
  }
}
