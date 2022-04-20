import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';
import '../utils/test_utils.dart';

void main() {
  final random = Random();

  group('lerp', () {
    test('should return interpolated value between numbers', () {
      final firstItems = random.nextIntList(1000, 500, -500);
      final secondItems = random.nextIntList(1000, 500, -500);
      for (var i = 0; i < firstItems.length; i += 1) {
        final t = random.nextDouble() * 2 - 0.5;
        final a = firstItems[i], b = secondItems[i];
        final result = lerp(a, b, t);
        if (a == b) {
          expect(result, a);
        } else {
          final c = (result - a) / (b - a);
          expect(c.toStringAsPrecision(8), t.toStringAsPrecision(8));
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

  group('lerpRecursive', () {
    test('should apply lerp callback recursively', () {
      repeat(times: 100, () {
        final items = random.nextIntList(4, 500, -500);
        final t = random.nextDouble() * 2 - 0.5;
        final a = lerp(items[0], items[1], t);
        final b = lerp(items[1], items[2], t);
        final c = lerp(items[2], items[3], t);
        final d = lerp(a, b, t);
        final e = lerp(b, c, t);
        expect(lerpRecursive(lerp, items, t), lerp(d, e, t));
      });
      expect(lerpRecursive(lerp, [1, 5, 9, 6, 9], 0.5), 6.75);
      expect(lerpRecursive(lerp, [2, 6, 8, 4, 7, 9], 0.5), 6.125);
    });

    test('should return terminal results when case is edge case', () {
      final items = random.nextIntList(1000, 500, -500);
      expect(lerpRecursive(lerp, items, 0), items.first);
      expect(lerpRecursive(lerp, items, 1), items.last);
    });

    test('should throw when items collection is empty', () {
      expect(() => lerpRecursive<num>(lerp, const [], 1), throwsStateError);
    });
  });
}
