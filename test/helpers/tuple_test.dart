import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';
import '../utils/test_utils.dart';

void main() {
  final random = Random();

  group('Tuple', () {
    test('should stay with the provided values', () {
      repeat(times: 10, () {
        var values = random.nextStringList(2, 5, 10);
        final pair = Pair(values[0], values[1]);
        expect(pair.first, values[0]);
        expect(pair.second, values[1]);
        values = random.nextStringList(3, 5, 10);
        final result = Trio(values[0], values[1], values[2]);
        expect(result.first, values[0]);
        expect(result.second, values[1]);
        expect(result.third, values[2]);
      });
    });

    test('should be equal to other tuple with the same members', () {
      final a = Object(), b = Object(), c = Object(), d = Object();
      expect(Pair(0, 1) == Pair(0, 1), isTrue);
      expect(Pair(a, b) == Pair(a, b), isTrue);
      expect(Pair(a, b) == Pair(a, c), isFalse);
      expect(Pair(a, b) == Pair(b, a), isFalse);
      expect(Trio(0, 1, 2) == Trio(0, 1, 2), isTrue);
      expect(Trio(a, b, c) == Trio(a, b, c), isTrue);
      expect(Trio(a, b, c) == Trio(a, b, d), isFalse);
      expect(Trio(a, b, c) == Trio(c, b, a), isFalse);
    });
  });
}
