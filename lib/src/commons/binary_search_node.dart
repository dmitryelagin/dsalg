import 'binary_node.dart';

extension BinarySearchNode<T, N extends BinaryNode<T, N>> on N {
  N? getChildByRatio(int ratio) => ratio < 0 ? left : right;

  V setChildByRatio<V extends N?>(int ratio, V node) =>
      ratio < 0 ? left = node : right = node;

  void removeChildByRatio(int ratio) {
    setChildByRatio(ratio, null);
  }
}
