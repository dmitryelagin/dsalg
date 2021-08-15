import '../helpers/permutations.dart';

class TravellingSalespersonProblemBruteForce<T> {
  const TravellingSalespersonProblemBruteForce(this._getDistance);

  final num Function(T a, T b) _getDistance;

  Iterable<T> findPath(Iterable<T> sites) {
    num smallestDistance = double.infinity;
    if (sites.isEmpty) return const [];
    final targets = sites.skip(1);
    if (targets.isEmpty) return [sites.first];
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
