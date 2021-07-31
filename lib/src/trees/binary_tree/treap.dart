part of 'binary_tree.dart';

class Treap<T> extends _BaseBinarySearchTree<T, _TreapNode<T>> {
  Treap(Comparator<T> compare, [Iterable<T> items = const [], Random? random])
      : _random = random ?? _defaultRandom,
        super(_createTreapNodeFactory(random ?? _defaultRandom), compare) {
    insertAll(items);
  }

  static final _defaultRandom = Random();

  final Random _random;

  static _TreapNode<T> Function(T) _createTreapNodeFactory<T>(Random random) =>
      (value) => _TreapNode(value, random.nextDouble());

  @override
  void insert(T item) {
    _bubble(_insertItem(item).current!);
  }

  @override
  T? remove(T item) {
    if (isEmpty) return null;
    final node = _getNodeClosestTo(item);
    if (_compare.areNotEqual(node.value, item)) return null;
    _sink(node..priority = double.infinity);
    if (node == _root) clear();
    if (node.isLeftOf(node.parent)) node.parent!.left = null;
    if (node.isRightOf(node.parent)) node.parent!.right = null;
    return node.value;
  }

  Iterable<Treap<T>> split(T item) => [
        for (final node in _splitNodes(item))
          Treap(_compare, const [], _random).._root = node,
      ];

  void union(Treap<T> other) {
    _root = _unionNodes(_root, other._root);
    other.clear();
  }

  Iterable<_TreapNode<T>?> _splitNodes(T item) {
    final node = _insertItem(item).current!..priority = -double.infinity;
    _bubble(node);
    final nodes = [node.left, node.right];
    node.clearChildren();
    clear();
    return nodes;
  }

  _TreapNode<T>? _unionNodes(_TreapNode<T>? a, _TreapNode<T>? b) {
    if (a == null) return b;
    if (b == null) return a;
    _root = a.priority < b.priority ? b : a;
    final item = _root!.value;
    final highTrees = _splitNodes(item);
    _root = a.priority < b.priority ? a : b;
    final lowTrees = _splitNodes(item);
    final highNode = _unionNodes(highTrees.last, lowTrees.last);
    final lowNode = _unionNodes(highTrees.first, lowTrees.first);
    return _mergeNodes(lowNode, item, highNode);
  }

  _TreapNode<T>? _mergeNodes(_TreapNode<T>? a, T item, _TreapNode<T>? b) {
    clear();
    _insertItem(item).current!
      ..left = a
      ..right = b;
    _sink(_root!);
    final node = _root;
    clear();
    return node;
  }

  void _bubble(_TreapNode<T> node) {
    var parent = node.parent;
    while (node.hasParent && node.priority < parent!.priority) {
      if (node.isLeftOf(parent)) parent.rotateRight();
      if (node.isRightOf(parent)) parent.rotateLeft();
      parent = node.parent;
    }
    if (node.hasNoParent) _root = node;
  }

  void _sink(_TreapNode<T> node) {
    while (node.hasChild && node.priority > node.lowPriorityChild!.priority) {
      if (node.hasBothChildren && node.left!.priority < node.right!.priority ||
          node.hasSingleChild && node.hasLeft) {
        node.rotateRight();
      } else {
        node.rotateLeft();
      }
      if (node == _root) _root = node.parent;
    }
  }
}

class _TreapNode<T> extends PriorityBinaryNode<T, _TreapNode<T>> {
  _TreapNode(T value, double priority) : super(value, priority);
}
