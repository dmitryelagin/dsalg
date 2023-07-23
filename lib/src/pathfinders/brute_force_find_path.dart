part of 'travelling_salesperson_problem.dart';

class TravellingSalespersonProblemBruteForce<T>
    extends TravellingSalespersonProblem<T> {
  const TravellingSalespersonProblemBruteForce(super._getDistance);

  @override
  Iterable<T> findPath(Iterable<T> sites) {
    if (sites.isEmpty) return const [];
    final targets = sites.skip(1);
    if (targets.isEmpty) return [sites.first];
    num smallestDistance = double.infinity;
    Iterable<T> result = const [];
    for (final permutation in targets.permutations) {
      var totalDistance = _getDistance(sites.first, permutation.last);
      var previousSite = sites.first;
      for (final site in permutation) {
        totalDistance += _getDistance(previousSite, previousSite = site);
        if (totalDistance >= smallestDistance) break;
      }
      if (totalDistance >= smallestDistance) continue;
      smallestDistance = totalDistance;
      result = permutation;
    }
    return [sites.first, ...result];
  }
}
