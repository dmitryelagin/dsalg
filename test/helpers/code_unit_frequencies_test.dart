import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';

void main() {
  final random = Random();

  group('CodeUnitFrequencies', () {
    test('should return counts with correct indirect parameters', () {
      final text = random.nextString(500, 1000);
      final frequences = text.codeUnitFrequencies;
      expect(frequences.values.reduce((a, b) => a + b), text.length);
      expect(frequences.keys, text.codeUnits.toSet());
    });

    test('should handle standard cases', () {
      const text = 'this is a test text';
      final target = {
        ...{' ': 4, 't': 5, 'h': 1, 'i': 2},
        ...{'s': 3, 'a': 1, 'e': 2, 'x': 1},
      }.map((key, value) => MapEntry(key.codeUnits.first, value));
      expect(text.codeUnitFrequencies, target);
    });

    test('should handle edge cases', () {
      expect(''.codeUnitFrequencies, isEmpty);
    });
  });
}
