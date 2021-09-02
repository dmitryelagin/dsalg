import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';

void main() {
  group('lerp', () {
    final random = Random();

    test('should return interpolated value between numbers', () {
      final firstItems = createIntList(1000, 500, -500);
      final secondItems = createIntList(1000, 500, -500);
      for (var i = 0; i < firstItems.length; i += 1) {
        final t = random.nextDouble() * 2 - 0.5;
        final a = firstItems[i], b = secondItems[i];
        final result = lerp(a, b, t);
        if (a == b) {
          expect(result, a);
        } else {
          final c = (result - a) / (b - a);
          expect(c.toStringAsPrecision(10), t.toStringAsPrecision(10));
        }
      }
    });

    test('should return accurate numbers when case is edge case', () {
      final multiplier = random.nextInt(1 << 32);
      final a = random.nextDouble() * multiplier;
      final b = random.nextDouble() * multiplier;
      expect(lerp(a, b, 0), a);
      expect(lerp(a, b, 1), b);
    });
  });
}
