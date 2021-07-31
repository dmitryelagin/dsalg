import 'node.dart';

class NodeChange<T, N extends Node<T, N>> {
  const NodeChange(this.previous, this.current, [this.parent]);

  const NodeChange.unchanged()
      : previous = null,
        current = null,
        parent = null;

  final N? previous;
  final N? current;
  final N? parent;
}
