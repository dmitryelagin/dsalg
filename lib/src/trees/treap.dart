import 'dart:math';

import '../commons/priority_binary_node.dart';
import 'base_binary_search_tree.dart';
import 'base_binary_tree.dart';

class Treap<T> extends BaseBinarySearchTree<T, _BinaryNode<T>> {
  Treap(Comparator<T> compare, [Iterable<T> items = const [], Random? random])
      : super(_getNodeFactory(random ?? Random()), compare) {
    insertAll(items);
  }

  static _BinaryNode<T> Function(T) _getNodeFactory<T>(Random random) =>
      (value) => _BinaryNode(value, random.nextDouble());

  @override
  void insert(T item) {
    final node = insertItem(item).current!;
    var parent = node.parent;
    while (node.hasParent && node.priority < parent!.priority) {
      if (node.isLeftOf(parent)) parent.rotateRight();
      if (node.isRightOf(parent)) parent.rotateLeft();
      parent = node.parent;
    }
    if (node.hasNoParent) root = node;
  }

  @override
  void remove(T item) {
    if (isEmpty) return;
    final node = getSearchPath(item).last;
    if (areNotEqual(compare(node.value, item))) return;
    while (node.hasChild) {
      if (node.hasBothChildren && node.left!.priority < node.right!.priority ||
          node.hasSingleChild && node.hasLeft) {
        node.rotateRight();
      } else {
        node.rotateLeft();
      }
      if (node == root) root = node.parent;
    }
    if (node == root) root = null;
    if (node.isLeftOf(node.parent)) node.parent!.left = null;
    if (node.isRightOf(node.parent)) node.parent!.right = null;
  }
}

class _BinaryNode<T> extends PriorityBinaryNode<T, _BinaryNode<T>> {
  _BinaryNode(T value, double priority) : super(value, priority);
}
