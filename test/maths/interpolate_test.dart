import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/compare_utils.dart';
import '../utils/data_utils.dart';
import '../utils/matchers.dart';
import '../utils/test_utils.dart';

void main() {
  final random = Random();

  late int multiplier;
  late double a, b, c, d;

  double nextValue() => random.nextDouble() * multiplier;

  setUp(() {
    multiplier = random.nextInt(1000);
    a = nextValue();
    b = nextValue();
    c = nextValue();
    d = nextValue();
  });

  group('interpLinear', () {
    test('should return interpolated value between numbers', () {
      expect(interpLinear(1, 2, 0.3).roundTo(5), 1.3);
      expect(interpLinear(17, 12, 0.6).roundTo(5), 14.0);
      expect(interpLinear(1.7, -12, 0.6).roundTo(5), -6.52);
      expect(interpLinear(-7.4, 1.2, 0.82).roundTo(5), -0.348);
      expect(interpLinear(-7.4, 1.2, -0.4).roundTo(5), -10.84);
      expect(interpLinear(-7.4, 1.2, 2).roundTo(5), 9.8);
    });

    test('should return accurate numbers when case is edge case', () {
      expect(interpLinear(a, b, 0), a);
      expect(interpLinear(a, b, 1), b);
    });
  });

  group('interpBiLinear', () {
    test('should return interpolated value between numbers', () {
      expect(interpBiLinear(1, 2, 3, 4, 0.3, 0.6).roundTo(5), 2.5);
      expect(interpBiLinear(1, 2, 3, 4, 0.6, 0.7).roundTo(5), 3.0);
      expect(interpBiLinear(11, 2, 34, 47, 0.6, 0.75).roundTo(5), 32.75);
      expect(interpBiLinear(-11, 2, 34, -47, 0.1, 0.75).roundTo(5), 17);
      expect(interpBiLinear(-8, 2, 5, -4.5, 0.8, -0.4).roundTo(5), 1.04);
      expect(interpBiLinear(-8, 2, 5, -4.5, 3, 0.4).roundTo(5), 3.8);
      expect(interpBiLinear(-11, 2, 34, -47, 0.6, 0.75).roundTo(5), -11.75);
      expect(interpBiLinear(-8, 2.3, 3.5, -4.7, 0.1, 0.4).roundTo(5), -3.11);
    });

    test('should return accurate numbers when case is edge case', () {
      expect(interpBiLinear(a, b, c, d, 0, 0), a);
      expect(interpBiLinear(a, b, c, d, 1, 0), b);
      expect(interpBiLinear(a, b, c, d, 0, 1), c);
      expect(interpBiLinear(a, b, c, d, 1, 1), d);
    });
  });

  group('interpCubic', () {
    test('should return interpolated value between numbers', () {
      const firstData = [-3, 4, 8, 0];
      expect(interpCubic(firstData, 0.2).roundTo(5), 5.184);
      expect(interpCubic(firstData, 0.8).roundTo(5), 8.016);
      const secondData = [1, 32, 9.75, -24];
      expect(interpCubic(secondData, 0.2).roundTo(5), 31.142);
      expect(interpCubic(secondData, 0.8).roundTo(5), 15.788);
    });

    test('should return accurate numbers when case is edge case', () {
      final data = [a, b, c, d];
      expect(interpCubic(data, 0).roundTo(10), b.roundTo(10));
      expect(interpCubic(data, 1).roundTo(10), c.roundTo(10));
    });

    test('should throw when there was not enough data provided', () {
      expect(() => interpCubic([1, 2, 3], 0), throwsAssertionError);
      expect(() => interpCubic([], 0), throwsAssertionError);
    });
  });

  group('interpBiCubic', () {
    test('should return interpolated value between numbers', () {
      const data = [
        [-3, 4, 8, 0],
        [12, 5.25, 7, 8],
        [4.5, -4.5, 0, -6],
        [1, 32, 9.75, -24],
      ];
      expect(interpBiCubic(data, 0.2, 0.2).roundTo(5), 3.07024);
      expect(interpBiCubic(data, 0.8, 0.2).roundTo(5), -5.14256);
      expect(interpBiCubic(data, 0.2, 0.8).roundTo(5), 5.14432);
      expect(interpBiCubic(data, 0.8, 0.8).roundTo(5), -0.4412);
    });

    test('should return accurate numbers when case is edge case', () {
      final data = [
        [nextValue(), nextValue(), nextValue(), nextValue()],
        [nextValue(), a, c, nextValue()],
        [nextValue(), b, d, nextValue()],
        [nextValue(), nextValue(), nextValue(), nextValue()],
      ];
      expect(interpBiCubic(data, 0, 0).roundTo(10), a.roundTo(10));
      expect(interpBiCubic(data, 1, 0).roundTo(10), b.roundTo(10));
      expect(interpBiCubic(data, 0, 1).roundTo(10), c.roundTo(10));
      expect(interpBiCubic(data, 1, 1).roundTo(10), d.roundTo(10));
    });

    test('should throw when there was not enough data provided', () {
      const invalidData = [
        [1, 2, 3, 4],
        [1, 2, 3, 4],
        [1, 2, 3, 4],
        [1, 2, 3]
      ];
      expect(() => interpBiCubic(invalidData, 0, 1), throwsAssertionError);
      expect(() => interpBiCubic([], 0, 1), throwsAssertionError);
    });
  });

  group('interpCosineS', () {
    test('should return interpolated value between numbers', () {
      expect(interpCosineS(1, 2, 0.25).roundTo(5), 1.14645);
      expect(interpCosineS(1, 2, 0.75).roundTo(5), 1.85355);
    });

    test('should return correct value relative to other S-curves', () {
      final a = random.nextInt(100), b = random.nextInt(100) + 100;
      final t = random.nextDouble() / 2, value = interpCosineS(a, b, t);
      expect(value, lessThan(interpLinear(a, b, t)));
      expect(value, lessThan(interpCubicS(a, b, t)));
      expect(value, greaterThan(interpQuinticS(a, b, t)));
    });

    test('should return accurate numbers when case is edge or middle case', () {
      expect(interpCosineS(a, b, 0), a);
      expect(interpCosineS(a, b, 1), b);
      expect(
        interpCosineS(a, b, 0.5).roundTo(5),
        interpLinear(a, b, 0.5).roundTo(5),
      );
    });
  });

  group('interpBiCosineS', () {
    test('should return interpolated value between numbers', () {
      expect(interpBiCosineS(1, 2, 3, 4, 0.25, 0.25).roundTo(5), 1.43934);
      expect(interpBiCosineS(1, 2, 3, 4, 0.75, 0.25).roundTo(5), 2.14645);
      expect(interpBiCosineS(1, 2, 3, 4, 0.25, 0.75).roundTo(5), 2.85355);
      expect(interpBiCosineS(1, 2, 3, 4, 0.75, 0.75).roundTo(5), 3.56066);
    });

    test('should return accurate numbers when case is edge or middle case', () {
      expect(interpBiCosineS(a, b, c, d, 0, 0), a);
      expect(interpBiCosineS(a, b, c, d, 1, 0), b);
      expect(interpBiCosineS(a, b, c, d, 0, 1), c);
      expect(interpBiCosineS(a, b, c, d, 1, 1), d);
      expect(
        interpBiCosineS(a, b, c, d, 0.5, 0.5).roundTo(5),
        interpBiLinear(a, b, c, d, 0.5, 0.5).roundTo(5),
      );
    });
  });

  group('interpCubicS', () {
    test('should return interpolated value between numbers', () {
      expect(interpCubicS(1, 2, 0.25).roundTo(5), 1.15625);
      expect(interpCubicS(1, 2, 0.75).roundTo(5), 1.84375);
    });

    test('should return correct value relative to other S-curves', () {
      final a = random.nextInt(100), b = random.nextInt(100) + 100;
      final t = random.nextDouble() / 2, value = interpCubicS(a, b, t);
      expect(value, lessThan(interpLinear(a, b, t)));
      expect(value, greaterThan(interpCosineS(a, b, t)));
      expect(value, greaterThan(interpQuinticS(a, b, t)));
    });

    test('should return accurate numbers when case is edge or middle case', () {
      expect(interpCubicS(a, b, 0), a);
      expect(interpCubicS(a, b, 1), b);
      expect(
        interpCubicS(a, b, 0.5).roundTo(5),
        interpLinear(a, b, 0.5).roundTo(5),
      );
    });
  });

  group('interpBiCubicS', () {
    test('should return interpolated value between numbers', () {
      expect(interpBiCubicS(1, 2, 3, 4, 0.25, 0.25).roundTo(5), 1.46875);
      expect(interpBiCubicS(1, 2, 3, 4, 0.75, 0.25).roundTo(5), 2.15625);
      expect(interpBiCubicS(1, 2, 3, 4, 0.25, 0.75).roundTo(5), 2.84375);
      expect(interpBiCubicS(1, 2, 3, 4, 0.75, 0.75).roundTo(5), 3.53125);
    });

    test('should return accurate numbers when case is edge or middle case', () {
      expect(interpBiCubicS(a, b, c, d, 0, 0), a);
      expect(interpBiCubicS(a, b, c, d, 1, 0), b);
      expect(interpBiCubicS(a, b, c, d, 0, 1), c);
      expect(interpBiCubicS(a, b, c, d, 1, 1), d);
      expect(
        interpBiCubicS(a, b, c, d, 0.5, 0.5).roundTo(5),
        interpBiLinear(a, b, c, d, 0.5, 0.5).roundTo(5),
      );
    });
  });

  group('interpQuinticS', () {
    test('should return interpolated value between numbers', () {
      expect(interpQuinticS(1, 2, 0.25).roundTo(5), 1.10352);
      expect(interpQuinticS(1, 2, 0.75).roundTo(5), 1.89648);
    });

    test('should return correct value relative to other S-curves', () {
      final a = random.nextInt(100), b = random.nextInt(100) + 100;
      final t = random.nextDouble() / 2, value = interpQuinticS(a, b, t);
      expect(value, lessThan(interpLinear(a, b, t)));
      expect(value, lessThan(interpCosineS(a, b, t)));
      expect(value, lessThan(interpCubicS(a, b, t)));
    });

    test('should return accurate numbers when case is edge or middle case', () {
      expect(interpQuinticS(a, b, 0), a);
      expect(interpQuinticS(a, b, 1), b);
      expect(
        interpQuinticS(a, b, 0.5).roundTo(5),
        interpLinear(a, b, 0.5).roundTo(5),
      );
    });
  });

  group('interpBiQuinticS', () {
    test('should return interpolated value between numbers', () {
      expect(interpBiQuinticS(1, 2, 3, 4, 0.25, 0.25).roundTo(5), 1.31055);
      expect(interpBiQuinticS(1, 2, 3, 4, 0.75, 0.25).roundTo(5), 2.10352);
      expect(interpBiQuinticS(1, 2, 3, 4, 0.25, 0.75).roundTo(5), 2.89648);
      expect(interpBiQuinticS(1, 2, 3, 4, 0.75, 0.75).roundTo(5), 3.68945);
    });

    test('should return accurate numbers when case is edge or middle case', () {
      expect(interpBiQuinticS(a, b, c, d, 0, 0), a);
      expect(interpBiQuinticS(a, b, c, d, 1, 0), b);
      expect(interpBiQuinticS(a, b, c, d, 0, 1), c);
      expect(interpBiQuinticS(a, b, c, d, 1, 1), d);
      expect(
        interpBiQuinticS(a, b, c, d, 0.5, 0.5).roundTo(5),
        interpBiLinear(a, b, c, d, 0.5, 0.5).roundTo(5),
      );
    });
  });

  group('interpRecursive', () {
    test('should apply interpolation callback recursively', () {
      repeat(times: 100, () {
        final items = random.nextIntList(4, 500, -500);
        final t = random.nextDouble() * 2 - 0.5;
        final a = interpLinear(items[0], items[1], t);
        final b = interpLinear(items[1], items[2], t);
        final c = interpLinear(items[2], items[3], t);
        final d = interpLinear(a, b, t);
        final e = interpLinear(b, c, t);
        expect(
          interpRecursive(interpLinear, items, t),
          interpLinear(d, e, t),
        );
      });
      expect(interpRecursive(interpLinear, [1, 5, 9, 6, 9], 0.5), 6.75);
      expect(interpRecursive(interpLinear, [2, 6, 8, 4, 7, 9], 0.5), 6.125);
    });

    test('should return terminal results when case is edge case', () {
      final items = random.nextIntList(1000, 500, -500);
      expect(interpRecursive(interpLinear, items, 0), items.first);
      expect(interpRecursive(interpLinear, items, 1), items.last);
    });

    test('should throw when items collection is empty', () {
      expect(
        () => interpRecursive<num>(interpLinear, const [], 1),
        throwsStateError,
      );
    });
  });
}
