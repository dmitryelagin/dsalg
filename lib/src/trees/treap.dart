import 'dart:math';

import '../commons/priority_binary_node.dart';
import 'base_binary_search_tree.dart';
import 'base_binary_tree.dart';

class Treap<T> extends BaseBinarySearchTree<T, _BinaryNode<T>> {
  Treap(this._compare, [Iterable<T> items = const [], Random? random])
      : _random = random ?? _defaultRandom,
        super(_getNodeFactory(random ?? _defaultRandom), _compare) {
    insertAll(items);
  }

  static final _defaultRandom = Random();

  final Comparator<T> _compare;
  final Random _random;

  static _BinaryNode<T> Function(T) _getNodeFactory<T>(Random random) =>
      (value) => _BinaryNode(value, random.nextDouble());

  @override
  void insert(T item) {
    _bubble(insertItem(item).current!);
  }

  @override
  T? remove(T item) {
    if (isEmpty) return null;
    final node = getSearchPath(item).last;
    if (areNotEqual(_compare(node.value, item))) return null;
    _sink(node..priority = double.infinity);
    if (node == root) clear();
    if (node.isLeftOf(node.parent)) node.parent!.left = null;
    if (node.isRightOf(node.parent)) node.parent!.right = null;
    return node.value;
  }

  Iterable<Treap<T>> split(T item) => [
        for (final node in _splitNodes(item))
          Treap(_compare, const [], _random)..root = node,
      ];

  void union(Treap<T> other) {
    root = _unionNodes(root, other.root);
    other.clear();
  }

  Iterable<_BinaryNode<T>?> _splitNodes(T item) {
    final node = insertItem(item).current!..priority = -double.infinity;
    _bubble(node);
    final nodes = [node.left, node.right];
    node.clearChildren();
    clear();
    return nodes;
  }

  _BinaryNode<T>? _unionNodes(_BinaryNode<T>? a, _BinaryNode<T>? b) {
    if (a == null) return b;
    if (b == null) return a;
    root = a.priority < b.priority ? b : a;
    final item = root!.value;
    final highTrees = _splitNodes(item);
    root = a.priority < b.priority ? a : b;
    final lowTrees = _splitNodes(item);
    final highNode = _unionNodes(highTrees.last, lowTrees.last);
    final lowNode = _unionNodes(highTrees.first, lowTrees.first);
    return _mergeNodes(lowNode, item, highNode);
  }

  _BinaryNode<T>? _mergeNodes(_BinaryNode<T>? a, T item, _BinaryNode<T>? b) {
    clear();
    insertItem(item).current!
      ..left = a
      ..right = b;
    _sink(root!);
    final node = root;
    clear();
    return node;
  }

  void _bubble(_BinaryNode<T> node) {
    var parent = node.parent;
    while (node.hasParent && node.priority < parent!.priority) {
      if (node.isLeftOf(parent)) parent.rotateRight();
      if (node.isRightOf(parent)) parent.rotateLeft();
      parent = node.parent;
    }
    if (node.hasNoParent) root = node;
  }

  void _sink(_BinaryNode<T> node) {
    while (node.hasChild && node.priority > node.lowPriorityChild!.priority) {
      if (node.hasBothChildren && node.left!.priority < node.right!.priority ||
          node.hasSingleChild && node.hasLeft) {
        node.rotateRight();
      } else {
        node.rotateLeft();
      }
      if (node == root) root = node.parent;
    }
  }
}

class _BinaryNode<T> extends PriorityBinaryNode<T, _BinaryNode<T>> {
  _BinaryNode(T value, double priority) : super(value, priority);
}
