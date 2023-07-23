part of 'travelling_salesperson_problem.dart';

class TravellingSalespersonProblemNearestNeighbor<T>
    extends TravellingSalespersonProblem<T> {
  const TravellingSalespersonProblemNearestNeighbor(super._getDistance);

  @override
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
