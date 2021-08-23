import 'node.dart';

class NodeTuple<N extends Node> {
  const NodeTuple(this.first, this.next, [this.parent]);

  const NodeTuple.empty()
      : first = null,
        next = null,
        parent = null;

  final N? first, next, parent;
}
