import '../commons/binary_search_node.dart';
import '../commons/linked_binary_node.dart';
import 'base_binary_search_tree.dart';
import 'base_binary_tree.dart';

extension BaseLinkedBinarySearchTree<T, N extends LinkedBinaryNode<T, N>>
    on BaseBinarySearchTree<T, N> {
  void rotateLeft(N node) {
    final parent = node.parent!.parent;
    node.left = node.parent!..right = node.left;
    _changeChild(node, parent);
  }

  void rotateRight(N node) {
    final parent = node.parent!.parent;
    node.right = node.parent!..left = node.right;
    _changeChild(node, parent);
  }

  void _changeChild(N node, N? parent) {
    if (parent != null) {
      parent.setChildByRatio(compare(node.value, parent.value), node);
    } else {
      root = node;
    }
  }
}
