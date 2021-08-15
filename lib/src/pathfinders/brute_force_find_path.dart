import '../helpers/permutations.dart';
import '../utils/iterable_utils.dart';

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
      final totalDistance = permutation.foldBinary(0, _accumulateDistance) +
          _getDistance(sites.first, permutation.first) +
          _getDistance(sites.first, permutation.last);
      if (totalDistance >= smallestDistance) continue;
      smallestDistance = totalDistance;
      result = permutation;
    }
    return [sites.first, ...result];
  }

  num _accumulateDistance(num total, T a, T b) => total + _getDistance(a, b);
}
