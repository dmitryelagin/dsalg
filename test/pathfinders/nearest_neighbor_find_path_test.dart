import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/iterable_utils.dart';

void main() {
  const fiveSites = [1, 2, 3, 4, 5];
  num getDistanceFive(int a, int b) => const [
        [0.0, 3.0, 4.0, 2.0, 7.0],
        [3.0, 0.0, 4.0, 6.0, 3.0],
        [4.0, 4.0, 0.0, 5.0, 8.0],
        [2.0, 6.0, 5.0, 0.0, 6.0],
        [7.0, 3.0, 8.0, 6.0, 0.0],
      ][a - 1][b - 1];
  const att48Sites = [
    Point(6734, 1453),
    Point(2233, 10),
    Point(5530, 1424),
    Point(401, 841),
    Point(3082, 1644),
    Point(7608, 4458),
    Point(7573, 3716),
    Point(7265, 1268),
    Point(6898, 1885),
    Point(1112, 2049),
    Point(5468, 2606),
    Point(5989, 2873),
    Point(4706, 2674),
    Point(4612, 2035),
    Point(6347, 2683),
    Point(6107, 669),
    Point(7611, 5184),
    Point(7462, 3590),
    Point(7732, 4723),
    Point(5900, 3561),
    Point(4483, 3369),
    Point(6101, 1110),
    Point(5199, 2182),
    Point(1633, 2809),
    Point(4307, 2322),
    Point(675, 1006),
    Point(7555, 4819),
    Point(7541, 3981),
    Point(3177, 756),
    Point(7352, 4506),
    Point(7545, 2801),
    Point(3245, 3305),
    Point(6426, 3173),
    Point(4608, 1198),
    Point(23, 2216),
    Point(7248, 3779),
    Point(7762, 4595),
    Point(7392, 2244),
    Point(3484, 2829),
    Point(6271, 2135),
    Point(4985, 140),
    Point(1916, 1569),
    Point(7280, 4899),
    Point(7509, 3239),
    Point(10, 2676),
    Point(6807, 2993),
    Point(5185, 3258),
    Point(3023, 1942),
  ];
  num getDistanceAtt48(Point<int> a, Point<int> b) => a.distanceTo(b);
  num getTotalDistance<T>(Iterable<T> sites, num Function(T, T) getDistance) =>
      getDistance(sites.first, sites.last) +
      sites.foldBinary(0, (total, a, b) => total + getDistance(a, b));

  group('TravellingSalespersonProblemNearestNeighbor', () {
    final fivePathfinder =
        TravellingSalespersonProblemNearestNeighbor(getDistanceFive);
    final att48Pathfinder =
        TravellingSalespersonProblemNearestNeighbor(getDistanceAtt48);

    test('should return optimized path for FIVE test data set', () {
      const result = [1, 4, 3, 2, 5];
      expect(fivePathfinder.findPath(fiveSites), result);
      expect(
        getTotalDistance(fiveSites, getDistanceFive),
        greaterThan(getTotalDistance(result, getDistanceFive)),
      );
    });

    test('should return correct path for smallest data sets', () {
      expect(fivePathfinder.findPath(const []), isEmpty);
      expect(fivePathfinder.findPath(const [1]), const [1]);
      expect(fivePathfinder.findPath(const [1, 2]), const [1, 2]);
    });

    test('should return optimized path for ATT48 test data set', () {
      const result = [
        ...[1, 9, 38, 31, 44, 18, 7, 28, 36, 30, 6, 37, 19, 27, 43, 17, 46],
        ...[33, 15, 12, 11, 23, 14, 25, 13, 21, 47, 20, 40, 3, 22, 16, 41],
        ...[34, 29, 5, 48, 39, 32, 24, 10, 42, 26, 4, 35, 45, 2, 8],
      ];
      expect(
        att48Pathfinder
            .findPath(att48Sites)
            .map((site) => att48Sites.indexOf(site) + 1),
        result,
      );
      expect(
        getTotalDistance(att48Sites, getDistanceAtt48),
        greaterThan(
          getTotalDistance(
            result.map((i) => att48Sites[i - 1]),
            getDistanceAtt48,
          ),
        ),
      );
    });
  });
}
