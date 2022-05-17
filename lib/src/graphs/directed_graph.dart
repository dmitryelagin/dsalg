import '../helpers/tuple.dart';

class DirectedGraph<K, N, E> {
  final _nodes = <K, N>{};
  final _edges = <Pair<K, K>, E>{};

  Iterable<K> get keys => _nodes.keys;

  bool hasNode(K target) => _nodes.containsKey(target);
  bool hasEdge(K from, K to) => _edges.containsKey(Pair(from, to));

  bool hasEdges(K target) => _getRelatedKeys(target).isNotEmpty;

  N getNode(K target) => _nodes[target]!;
  E getEdge(K from, K to) => _edges[Pair(from, to)]!;

  Iterable<E> getEdges(K target) =>
      {for (final key in _getRelatedKeys(target)) _edges[key]!};

  void setNode(K target, N node) {
    _nodes[target] = node;
  }

  bool setEdge(K from, K to, E edge) {
    if (!hasNode(from) || !hasNode(to)) return false;
    _edges[Pair(from, to)] = edge;
    return true;
  }

  Pair<N?, Iterable<E>> removeNode(K target) {
    final node = _nodes.remove(target);
    if (node == null) return const Pair(null, {});
    return Pair(node, {
      for (final key in _getRelatedKeys(target)) _edges.remove(key)!,
    });
  }

  E? removeEdge(K from, K to) => _edges.remove(Pair(from, to));

  Iterable<Pair<K, K>> _getRelatedKeys(K target) =>
      _edges.keys.where((key) => key.first == target || key.second == target);
}
