import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';

void main() {
  final random = Random();

  group('CodeUnitProbabilities', () {
    test('should return counts with correct indirect parameters', () {
      const precision = 100000000000000;
      final text = random.nextString(500, 1000);
      final probabilities = text.codeUnitProbabilities;
      expect(
        (probabilities.values.reduce((a, b) => a + b) * precision).round(),
        precision,
      );
      expect(probabilities.keys, text.codeUnits.toSet());
    });

    test('should handle standard cases', () {
      const text = 'this is a test text';
      final target = {
        ...{' ': 4, 't': 5, 'h': 1, 'i': 2},
        ...{'s': 3, 'a': 1, 'e': 2, 'x': 1},
      }.map((key, value) => MapEntry(key.codeUnits.first, value / 19));
      expect(text.codeUnitProbabilities, target);
    });

    test('should handle edge cases', () {
      expect(''.codeUnitProbabilities, isEmpty);
    });
  });
}
