import 'directed_graph.dart';

class UnirectedGraph<K, N, E> extends DirectedGraph<K, N, E> {
  @override
  bool setEdge(K from, K to, E edge) {
    super.setEdge(from, to, edge);
    return super.setEdge(to, from, edge);
  }

  @override
  E? removeEdge(K from, K to) {
    super.removeEdge(from, to);
    return super.removeEdge(to, from);
  }
}
