part of 'binary_tree.dart';

class Treap<K, V> extends _BaseBinarySearchTree<K, V, _TreapNode<K, V>> {
  Treap(Comparator<K> compare, [Map<K, V> entries = const {}, Random? random])
      : _random = random ?? _defaultRandom,
        super(_getNodeFactory(random ?? _defaultRandom), compare) {
    addAll(entries);
  }

  static final _defaultRandom = Random();

  final Random _random;

  static _TreapNode<K, V> Function(K, V) _getNodeFactory<K, V>(Random random) =>
      (key, value) => _TreapNode(key, value, random.nextDouble());

  @override
  void add(K key, V value) {
    _bubble(_addItem(key, value));
  }

  @override
  V? remove(K key) {
    if (isEmpty) return null;
    final node = _getNodeClosestTo(key);
    if (_compare.areNotEqual(node.key, key)) return null;
    _sink(node..priority = double.infinity);
    if (node == _root) clear();
    if (node.isLeftOf(node.parent)) node.parent!.left = null;
    if (node.isRightOf(node.parent)) node.parent!.right = null;
    return node.value;
  }

  Treap<K, V> split(K key) =>
      Treap(_compare, const {}, _random).._root = _split(key);

  void union(Treap<K, V> other) {
    _union(_root, other._root);
    other.clear();
  }

  _TreapNode<K, V>? _split(K key) {
    if (isEmpty) return null;
    final node = _addItem(key, _root!.value)..priority = -double.infinity;
    _bubble(node);
    _root = node.left;
    final right = node.right;
    node.clearChildren();
    return right;
  }

  void _union(_TreapNode<K, V>? a, _TreapNode<K, V>? b) {
    if (a == null || b == null) {
      _root = a ?? b;
    } else {
      _root = a.priority < b.priority ? b : a;
      final key = _root!.key, value = _root!.value;
      final highRight = _split(key), highLeft = _root;
      _root = a.priority < b.priority ? a : b;
      final lowRight = _split(key), lowLeft = _root;
      _union(highRight, lowRight);
      final highNode = _root;
      _union(highLeft, lowLeft);
      final lowNode = _root;
      clear();
      _addItem(key, value)
        ..left = lowNode
        ..right = highNode;
      _sink(_root!);
    }
  }

  void _bubble(_TreapNode<K, V> node) {
    var parent = node.parent;
    while (node.hasParent && node.priority < parent!.priority) {
      if (node.isLeftOf(parent)) parent.rotateRight();
      if (node.isRightOf(parent)) parent.rotateLeft();
      parent = node.parent;
    }
    if (node.hasNoParent) _root = node;
  }

  void _sink(_TreapNode<K, V> node) {
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

class _TreapNode<K, V> extends PriorityBinaryNode<K, V, _TreapNode<K, V>> {
  _TreapNode(K key, V value, double priority) : super(key, value, priority);
}
