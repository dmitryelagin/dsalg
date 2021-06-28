import 'binary_node.dart';

extension BinarySearchNode<T, N extends BinaryNode<T, N>> on N {
  N? getChildByRatio(int ratio) {
    if (ratio == 0) return null;
    return ratio < 0 ? left : right;
  }

  void setChildByRatio(int ratio, N? node) {
    if (ratio == 0) return;
    if (ratio < 0) {
      left = node;
    } else {
      right = node;
    }
  }

  void removeChildByRatio(int ratio) {
    setChildByRatio(ratio, null);
  }
}
