import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';

void main() {
  group('lerp', () {
    test('should return interpolated value between numbers', () {
      final random = Random();
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
  });
}
