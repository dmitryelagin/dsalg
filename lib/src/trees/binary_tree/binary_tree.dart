import 'dart:math';

import '../../collections/queue.dart';
import '../../helpers/comparator.dart';
import '../../utils/iterable_utils.dart';
import '../commons/node_tuple.dart';
import 'balance_binary_node.dart';
import 'binary_node.dart';
import 'linked_binary_node.dart';
import 'mutable_binary_node.dart';
import 'priority_binary_node.dart';

part 'avl_tree.dart';
part 'binary_search_tree.dart';
part 'base_binary_tree.dart';
part 'base_binary_search_tree.dart';
part 'base_mutable_binary_tree.dart';
part 'splay_tree.dart';
part 'treap.dart';

abstract class BinaryTree<K, V> implements _BaseBinaryTree<K, V> {}
