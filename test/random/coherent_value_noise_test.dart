import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/iterable_utils.dart';
import '../utils/matchers.dart';

void main() {
  final random = Random();

  group('CoherentValueNoise', () {
    test('should generate correct amount of random noise values', () {
      final valuesAmount = random.nextInt(100) + 50;
      final noise1D = random.nextCoherent1DValueNoise(valuesAmount);
      expect(noise1D.length, valuesAmount);
      expect(noise1D.minValue, greaterThanOrEqualTo(0));
      expect(noise1D.maxValue, lessThan(1));
      final noise2D =
          random.nextCoherent2DValueNoise(valuesAmount, valuesAmount);
      expect(noise2D.length, valuesAmount);
      for (final noise1D in noise2D) {
        expect(noise1D.length, valuesAmount);
        expect(noise1D.minValue, greaterThanOrEqualTo(0));
        expect(noise1D.maxValue, lessThan(1));
      }
    });

    test('should handle edge noise lengths cases', () {
      expect(random.nextCoherent1DValueNoise(0), const <double>[]);
      expect(random.nextCoherent2DValueNoise(0, 0), const <List<double>>[]);
    });

    test('should throw on negative length cases', () {
      expect(
        () => random.nextCoherent1DValueNoise(-1),
        throwsAssertionError,
      );
      expect(
        () => random.nextCoherent2DValueNoise(-1, -1),
        throwsAssertionError,
      );
    });
  });
}
