import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

void main() {
  const sites = [1, 2, 3, 4, 5];
  num getDistanceFive(int a, int b) => const [
        [0.0, 3.0, 4.0, 2.0, 7.0],
        [3.0, 0.0, 4.0, 6.0, 3.0],
        [4.0, 4.0, 0.0, 5.0, 8.0],
        [2.0, 6.0, 5.0, 0.0, 6.0],
        [7.0, 3.0, 8.0, 6.0, 0.0],
      ][a - 1][b - 1];

  group('TravellingSalespersonProblemBruteForce', () {
    final fivePathfinder =
        TravellingSalespersonProblemBruteForce(getDistanceFive);

    test('should return optimal path for FIVE test data set', () {
      expect(fivePathfinder.findPath(sites), const [1, 3, 2, 5, 4]);
    });

    test('should return correct path for smallest data sets', () {
      expect(fivePathfinder.findPath(const []), isEmpty);
      expect(fivePathfinder.findPath(const [1]), const [1]);
      expect(fivePathfinder.findPath(const [1, 2]), const [1, 2]);
    });
  });
}
