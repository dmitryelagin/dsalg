class TravellingSalespersonProblemNearestNeighbor<T> {
  const TravellingSalespersonProblemNearestNeighbor(this._getDistance);

  final num Function(T a, T b) _getDistance;

  Iterable<T> findPath(Iterable<T> sites) sync* {
    if (sites.isEmpty) return;
    final availableSites = sites.skip(1).toList();
    var previousSite = sites.first;
    while (availableSites.isNotEmpty) {
      yield previousSite;
      num smallestDistance = double.infinity;
      var nearestNeighborIndex = -1;
      for (var i = 0; i < availableSites.length; i += 1) {
        final distance = _getDistance(previousSite, availableSites[i]);
        if (distance >= smallestDistance) continue;
        smallestDistance = distance;
        nearestNeighborIndex = i;
      }
      if (!nearestNeighborIndex.isNegative) {
        previousSite = availableSites.removeAt(nearestNeighborIndex);
      }
    }
    yield previousSite;
  }
}
