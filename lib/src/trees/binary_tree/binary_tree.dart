import 'dart:math';

import '../../collections/queue.dart';
import '../../helpers/comparator.dart';
import '../../helpers/tuple.dart';
import '../../utils/iterable_utils.dart';
import 'balance_binary_node.dart';
import 'base_binary_node.dart';
import 'linked_binary_node.dart';
import 'priority_binary_node.dart';

part 'avl_tree.dart';
part 'binary_search_tree.dart';
part 'base_binary_tree.dart';
part 'base_binary_search_tree.dart';
part 'splay_tree.dart';
part 'treap.dart';

class BinaryTree<K, V> extends _BaseBinaryTree<K, V, BinaryNode<K, V>> {
  BinaryTree(BinaryNode<K, V> root) {
    _root = root;
  }
}

class BinaryNode<K, V> extends BaseBinaryNode<K, V, BinaryNode<K, V>> {
  BinaryNode(super.key, super.value);
}

abstract class BaseBinaryTree<K, V> {
  bool get isEmpty;
  bool get isNotEmpty;
  Iterable<K> get keys;
  Iterable<V> get values;
  Iterable<MapEntry<K, V>> get entries;
  Iterable<K> get breadthFirstTraversalKeys;
  Iterable<K> get depthFirstPreOrderTraversalKeys;
  Iterable<K> get depthFirstInOrderTraversalKeys;
  Iterable<K> get depthFirstPostOrderTraversalKeys;
  Iterable<V> get breadthFirstTraversalValues;
  Iterable<V> get depthFirstPreOrderTraversalValues;
  Iterable<V> get depthFirstInOrderTraversalValues;
  Iterable<V> get depthFirstPostOrderTraversalValues;
  Iterable<MapEntry<K, V>> get breadthFirstTraversalEntries;
  Iterable<MapEntry<K, V>> get depthFirstPreOrderTraversalEntries;
  Iterable<MapEntry<K, V>> get depthFirstInOrderTraversalEntries;
  Iterable<MapEntry<K, V>> get depthFirstPostOrderTraversalEntries;
  void invert();
  void clear();
}

abstract class BaseBinarySearchTree<K, V> extends BaseBinaryTree<K, V> {
  MapEntry<K, V> get min;
  MapEntry<K, V> get max;
  V operator [](K key);
  void operator []=(K key, V value);
  MapEntry<K, V> getClosestTo(K key);
  bool containsKey(K key);
  void add(K key, V value);
  void addAll(Map<K, V> entries);
  V? remove(K key);
  Iterable<V> removeAll(Iterable<K> keys);
}
