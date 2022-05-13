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
        final trio = Trio(values[0], values[1], values[2]);
        expect(trio.first, values[0]);
        expect(trio.second, values[1]);
        expect(trio.third, values[2]);
        values = random.nextStringList(4, 5, 10);
        final quartet = Quartet(values[0], values[1], values[2], values[3]);
        expect(quartet.first, values[0]);
        expect(quartet.second, values[1]);
        expect(quartet.third, values[2]);
        expect(quartet.fourth, values[3]);
      });
    });

    test('should be equal to other tuple with the same members', () {
      final a = Object(), b = Object(), c = Object();
      final d = Object(), e = Object();
      expect(const Pair(0, 1) == const Pair(0, 1), isTrue);
      expect(Pair(a, b) == Pair(a, b), isTrue);
      expect(Pair(a, b) == Pair(a, c), isFalse);
      expect(Pair(a, b) == Pair(b, a), isFalse);
      expect(const Trio(0, 1, 2) == const Trio(0, 1, 2), isTrue);
      expect(Trio(a, b, c) == Trio(a, b, c), isTrue);
      expect(Trio(a, b, c) == Trio(a, b, d), isFalse);
      expect(Trio(a, b, c) == Trio(c, b, a), isFalse);
      expect(const Quartet(0, 1, 2, 3) == const Quartet(0, 1, 2, 3), isTrue);
      expect(Quartet(a, b, c, d) == Quartet(a, b, c, d), isTrue);
      expect(Quartet(a, b, c, d) == Quartet(a, b, e, d), isFalse);
      expect(Quartet(a, b, c, d) == Quartet(d, c, b, a), isFalse);
    });
  });
}
