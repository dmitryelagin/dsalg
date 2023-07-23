import '../helpers/permutations.dart';

part 'brute_force_find_path.dart';
part 'nearest_neighbor_find_path.dart';

abstract class TravellingSalespersonProblem<T> {
  const TravellingSalespersonProblem(this._getDistance);

  final num Function(T a, T b) _getDistance;

  Iterable<T> findPath(Iterable<T> sites);
}
