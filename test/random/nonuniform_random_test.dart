import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';
import '../utils/iterable_utils.dart';
import '../utils/random_utils.dart';

void main() {
  final standardRandom = Random();

  group('NonuniformRandom', () {
    late NonuniformRandom random;
    late List<int> currentDistributions, values, counters;

    setUp(() {
      const smallestDistribution = 5;
      currentDistributions = standardRandom
          .nextIntSet(8, 9, 1)
          .map((item) => item * smallestDistribution)
          .toList();
      values = List.filled(
        currentDistributions.sum.toInt() ~/ smallestDistribution,
        smallestDistribution,
      ).cumulativeSums.map((item) => item - 1).toInts().toList();
      random = NonuniformRandom(LoopRandomMock(values), currentDistributions);
      counters = List.filled(currentDistributions.length, 0);
    });

    test('should return values proportionally to the distributions', () {
      for (var i = 0; i < values.length * 5; i += 1) {
        counters[random.nextDistributedInt()] += 1;
      }
      expect(currentDistributions, counters);
    });

    test('should return doubles proportionally to the distributions', () {
      for (var i = 0; i < values.length * 5; i += 1) {
        final index =
            (random.nextDouble() * currentDistributions.length).toInt();
        counters[index] += 1;
      }
      expect(currentDistributions, counters);
    });

    test('should return integers proportionally to the distributions', () {
      for (var i = 0; i < values.length * 5; i += 1) {
        final multiplier = standardRandom.nextInt(4) + 1;
        final max = currentDistributions.length * multiplier;
        counters[random.nextInt(max) ~/ multiplier] += 1;
      }
      expect(currentDistributions, counters);
    });

    test('should return booleans proportionally to the distributions', () {
      final boolCounters = [0, 0];
      for (var i = 0; i < values.length * 5; i += 1) {
        boolCounters[random.nextBool() ? 1 : 0] += 1;
      }
      final boolDistributions = [
        currentDistributions.take(currentDistributions.length ~/ 2).sum,
        currentDistributions.skip(currentDistributions.length ~/ 2).sum,
      ];
      expect(boolDistributions, boolCounters);
    });
  });
}
