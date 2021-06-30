import 'binary_node.dart';
import 'node_change.dart';

extension BinarySearchNode<T, N extends BinaryNode<T, N>> on BinaryNode<T, N> {
  N? getChildByRatio(int ratio) => ratio < 0 ? left : right;

  NodeChange<T, N> setChildByRatio(int ratio, N? node) => NodeChange(
        getChildByRatio(ratio),
        ratio < 0 ? left = node : right = node,
        this as N,
      );

  NodeChange<T, N> removeChildByRatio(int ratio) =>
      setChildByRatio(ratio, null);
}
