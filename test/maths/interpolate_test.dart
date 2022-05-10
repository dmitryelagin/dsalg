import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';
import '../utils/test_utils.dart';

void main() {
  final random = Random();

  late int multiplier;
  late double a, b, c, d;

  double roundDouble5(double value) => double.parse(value.toStringAsFixed(5));
  double roundDouble10(double value) => double.parse(value.toStringAsFixed(10));
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
      expect(roundDouble5(interpLinear(1, 2, 0.3)), 1.3);
      expect(roundDouble5(interpLinear(17, 12, 0.6)), 14.0);
      expect(roundDouble5(interpLinear(1.7, -12, 0.6)), -6.52);
      expect(roundDouble5(interpLinear(-7.4, 1.2, 0.82)), -0.348);
      expect(roundDouble5(interpLinear(-7.4, 1.2, -0.4)), -10.84);
      expect(roundDouble5(interpLinear(-7.4, 1.2, 2)), 9.8);
    });

    test('should return accurate numbers when case is edge case', () {
      expect(interpLinear(a, b, 0), a);
      expect(interpLinear(a, b, 1), b);
    });
  });

  group('interpBiLinear', () {
    test('should return interpolated value between numbers', () {
      expect(roundDouble5(interpBiLinear(1, 2, 3, 4, 0.3, 0.6)), 2.5);
      expect(roundDouble5(interpBiLinear(1, 2, 3, 4, 0.6, 0.7)), 3.0);
      expect(roundDouble5(interpBiLinear(11, 2, 34, 47, 0.6, 0.75)), 32.75);
      expect(roundDouble5(interpBiLinear(-11, 2, 34, -47, 0.6, 0.75)), -11.75);
      expect(roundDouble5(interpBiLinear(-11, 2, 34, -47, 0.1, 0.75)), 17);
      expect(roundDouble5(interpBiLinear(-8, 2.3, 3.5, -4.7, 0.1, 0.4)), -3.11);
      expect(roundDouble5(interpBiLinear(-8, 2, 5, -4.5, 0.8, -0.4)), 1.04);
      expect(roundDouble5(interpBiLinear(-8, 2, 5, -4.5, 3, 0.4)), 3.8);
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
      expect(roundDouble5(interpCubic(firstData, 0.2)), 5.184);
      expect(roundDouble5(interpCubic(firstData, 0.8)), 8.016);
      const secondData = [1, 32, 9.75, -24];
      expect(roundDouble5(interpCubic(secondData, 0.2)), 31.142);
      expect(roundDouble5(interpCubic(secondData, 0.8)), 15.788);
    });

    test('should return accurate numbers when case is edge case', () {
      final data = [a, b, c, d];
      expect(roundDouble10(interpCubic(data, 0)), roundDouble10(b));
      expect(roundDouble10(interpCubic(data, 1)), roundDouble10(c));
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
      expect(roundDouble5(interpBiCubic(data, 0.2, 0.2)), 3.07024);
      expect(roundDouble5(interpBiCubic(data, 0.8, 0.2)), -5.14256);
      expect(roundDouble5(interpBiCubic(data, 0.2, 0.8)), 5.14432);
      expect(roundDouble5(interpBiCubic(data, 0.8, 0.8)), -0.4412);
    });

    test('should return accurate numbers when case is edge case', () {
      final data = [
        [nextValue(), nextValue(), nextValue(), nextValue()],
        [nextValue(), a, c, nextValue()],
        [nextValue(), b, d, nextValue()],
        [nextValue(), nextValue(), nextValue(), nextValue()],
      ];
      expect(roundDouble10(interpBiCubic(data, 0, 0)), roundDouble10(a));
      expect(roundDouble10(interpBiCubic(data, 1, 0)), roundDouble10(b));
      expect(roundDouble10(interpBiCubic(data, 0, 1)), roundDouble10(c));
      expect(roundDouble10(interpBiCubic(data, 1, 1)), roundDouble10(d));
    });
  });

  group('interpCosineS', () {
    test('should return interpolated value between numbers', () {
      expect(roundDouble5(interpCosineS(1, 2, 0.25)), 1.14645);
      expect(roundDouble5(interpCosineS(1, 2, 0.75)), 1.85355);
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
        roundDouble5(interpCosineS(a, b, 0.5)),
        roundDouble5(interpLinear(a, b, 0.5)),
      );
    });
  });

  group('interpBiCosineS', () {
    test('should return interpolated value between numbers', () {
      expect(roundDouble5(interpBiCosineS(1, 2, 3, 4, 0.25, 0.25)), 1.43934);
      expect(roundDouble5(interpBiCosineS(1, 2, 3, 4, 0.75, 0.25)), 2.14645);
      expect(roundDouble5(interpBiCosineS(1, 2, 3, 4, 0.25, 0.75)), 2.85355);
      expect(roundDouble5(interpBiCosineS(1, 2, 3, 4, 0.75, 0.75)), 3.56066);
    });

    test('should return accurate numbers when case is edge or middle case', () {
      expect(interpBiCosineS(a, b, c, d, 0, 0), a);
      expect(interpBiCosineS(a, b, c, d, 1, 0), b);
      expect(interpBiCosineS(a, b, c, d, 0, 1), c);
      expect(interpBiCosineS(a, b, c, d, 1, 1), d);
      expect(
        roundDouble5(interpBiCosineS(a, b, c, d, 0.5, 0.5)),
        roundDouble5(interpBiLinear(a, b, c, d, 0.5, 0.5)),
      );
    });
  });

  group('interpCubicS', () {
    test('should return interpolated value between numbers', () {
      expect(roundDouble5(interpCubicS(1, 2, 0.25)), 1.15625);
      expect(roundDouble5(interpCubicS(1, 2, 0.75)), 1.84375);
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
        roundDouble5(interpCubicS(a, b, 0.5)),
        roundDouble5(interpLinear(a, b, 0.5)),
      );
    });
  });

  group('interpBiCubicS', () {
    test('should return interpolated value between numbers', () {
      expect(roundDouble5(interpBiCubicS(1, 2, 3, 4, 0.25, 0.25)), 1.46875);
      expect(roundDouble5(interpBiCubicS(1, 2, 3, 4, 0.75, 0.25)), 2.15625);
      expect(roundDouble5(interpBiCubicS(1, 2, 3, 4, 0.25, 0.75)), 2.84375);
      expect(roundDouble5(interpBiCubicS(1, 2, 3, 4, 0.75, 0.75)), 3.53125);
    });

    test('should return accurate numbers when case is edge or middle case', () {
      expect(interpBiCubicS(a, b, c, d, 0, 0), a);
      expect(interpBiCubicS(a, b, c, d, 1, 0), b);
      expect(interpBiCubicS(a, b, c, d, 0, 1), c);
      expect(interpBiCubicS(a, b, c, d, 1, 1), d);
      expect(
        roundDouble5(interpBiCubicS(a, b, c, d, 0.5, 0.5)),
        roundDouble5(interpBiLinear(a, b, c, d, 0.5, 0.5)),
      );
    });
  });

  group('interpQuinticS', () {
    test('should return interpolated value between numbers', () {
      expect(roundDouble5(interpQuinticS(1, 2, 0.25)), 1.10352);
      expect(roundDouble5(interpQuinticS(1, 2, 0.75)), 1.89648);
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
        roundDouble5(interpQuinticS(a, b, 0.5)),
        roundDouble5(interpLinear(a, b, 0.5)),
      );
    });
  });

  group('interpBiQuinticS', () {
    test('should return interpolated value between numbers', () {
      expect(roundDouble5(interpBiQuinticS(1, 2, 3, 4, 0.25, 0.25)), 1.31055);
      expect(roundDouble5(interpBiQuinticS(1, 2, 3, 4, 0.75, 0.25)), 2.10352);
      expect(roundDouble5(interpBiQuinticS(1, 2, 3, 4, 0.25, 0.75)), 2.89648);
      expect(roundDouble5(interpBiQuinticS(1, 2, 3, 4, 0.75, 0.75)), 3.68945);
    });

    test('should return accurate numbers when case is edge or middle case', () {
      expect(interpBiQuinticS(a, b, c, d, 0, 0), a);
      expect(interpBiQuinticS(a, b, c, d, 1, 0), b);
      expect(interpBiQuinticS(a, b, c, d, 0, 1), c);
      expect(interpBiQuinticS(a, b, c, d, 1, 1), d);
      expect(
        roundDouble5(interpBiQuinticS(a, b, c, d, 0.5, 0.5)),
        roundDouble5(interpBiLinear(a, b, c, d, 0.5, 0.5)),
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
