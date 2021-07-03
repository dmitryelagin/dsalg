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

  Treap.merge(this._compare, Treap<T> l, T item, Treap<T> r, [Random? random])
      : _random = random ?? _defaultRandom,
        super(_getNodeFactory(random ?? _defaultRandom), _compare) {
    if ((l.isNotEmpty && _compare(l.max, item) < 0) &&
        (r.isNotEmpty && _compare(item, r.min) < 0)) {
      final node = insertItem(item).current!
        ..left = l._extractRoot()
        ..right = r._extractRoot();
      _sink(node);
    } else {
      if (l.isEmpty && r.isNotEmpty) root = r._extractRoot();
      if (r.isEmpty && l.isNotEmpty) root = l._extractRoot();
      insert(item);
    }
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
  void remove(T item) {
    if (isEmpty) return;
    final node = getSearchPath(item).last;
    if (areNotEqual(_compare(node.value, item))) return;
    _sink(node..priority = double.infinity);
    if (node == root) clear();
    if (node.isLeftOf(node.parent)) node.parent!.left = null;
    if (node.isRightOf(node.parent)) node.parent!.right = null;
  }

  Iterable<Treap<T>> split(T item) {
    final node = insertItem(item).current!..priority = -double.infinity;
    _bubble(node);
    final left = node.left, right = node.right;
    node.clearChildren();
    clear();
    return [
      Treap(_compare, const [], _random)..root = left,
      Treap(_compare, const [], _random)..root = right,
    ];
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

  _BinaryNode<T>? _extractRoot() {
    final node = root;
    clear();
    return node;
  }
}

class _BinaryNode<T> extends PriorityBinaryNode<T, _BinaryNode<T>> {
  _BinaryNode(T value, double priority) : super(value, priority);
}
