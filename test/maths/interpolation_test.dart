import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';
import '../utils/test_utils.dart';

void main() {
  final random = Random();

  double roundDouble(double value) => double.parse(value.toStringAsFixed(5));

  late double a, b, c, d;

  setUp(() {
    final multiplier = random.nextInt(1000);
    a = random.nextDouble() * multiplier;
    b = random.nextDouble() * multiplier;
    c = random.nextDouble() * multiplier;
    d = random.nextDouble() * multiplier;
  });

  group('interp.linear', () {
    test('should return interpolated value between numbers', () {
      expect(roundDouble(interp.linear(1, 2, 0.3)), 1.3);
      expect(roundDouble(interp.linear(17, 12, 0.6)), 14.0);
      expect(roundDouble(interp.linear(1.7, -12, 0.6)), -6.52);
      expect(roundDouble(interp.linear(-7.4, 1.2, 0.82)), -0.348);
      expect(roundDouble(interp.linear(-7.4, 1.2, -0.4)), -10.84);
      expect(roundDouble(interp.linear(-7.4, 1.2, 2)), 9.8);
    });

    test('should return accurate numbers when case is edge case', () {
      expect(interp.linear(a, b, 0), a);
      expect(interp.linear(a, b, 1), b);
    });
  });

  group('interp.bilinear', () {
    test('should return interpolated value between numbers', () {
      expect(roundDouble(interp.bilinear(1, 2, 3, 4, 0.3, 0.6)), 2.5);
      expect(roundDouble(interp.bilinear(1, 2, 3, 4, 0.6, 0.7)), 3.0);
      expect(roundDouble(interp.bilinear(11, 2, 34, 47, 0.6, 0.75)), 32.75);
      expect(roundDouble(interp.bilinear(-11, 2, 34, -47, 0.6, 0.75)), -11.75);
      expect(roundDouble(interp.bilinear(-11, 2, 34, -47, 0.1, 0.75)), 17);
      expect(roundDouble(interp.bilinear(-8, 2.3, 3.5, -4.7, 0.1, 0.4)), -3.11);
      expect(roundDouble(interp.bilinear(-8, 2, 5, -4.5, 0.8, -0.4)), 1.04);
      expect(roundDouble(interp.bilinear(-8, 2, 5, -4.5, 3, 0.4)), 3.8);
    });

    test('should return accurate numbers when case is edge case', () {
      expect(interp.bilinear(a, b, c, d, 0, 0), a);
      expect(interp.bilinear(a, b, c, d, 1, 0), b);
      expect(interp.bilinear(a, b, c, d, 0, 1), c);
      expect(interp.bilinear(a, b, c, d, 1, 1), d);
    });
  });

  group('interp.cosineS', () {
    test('should return interpolated value between numbers', () {
      expect(roundDouble(interp.cosineS(1, 2, 0.25)), 1.14645);
      expect(roundDouble(interp.cosineS(1, 2, 0.75)), 1.85355);
    });

    test('should return correct value relative to other functions', () {
      final a = random.nextInt(100), b = random.nextInt(100) + 100;
      final t = random.nextDouble() / 2, value = interp.cosineS(a, b, t);
      expect(value, lessThan(interp.linear(a, b, t)));
      expect(value, lessThan(interp.cubicS(a, b, t)));
      expect(value, greaterThan(interp.quinticS(a, b, t)));
    });

    test('should return accurate numbers when case is edge or middle case', () {
      expect(interp.cosineS(a, b, 0), a);
      expect(interp.cosineS(a, b, 1), b);
      expect(
        roundDouble(interp.cosineS(a, b, 0.5)),
        roundDouble(interp.linear(a, b, 0.5)),
      );
    });
  });

  group('interp.bicosineS', () {
    test('should return interpolated value between numbers', () {
      expect(roundDouble(interp.bicosineS(1, 2, 3, 4, 0.25, 0.25)), 1.43934);
      expect(roundDouble(interp.bicosineS(1, 2, 3, 4, 0.75, 0.25)), 2.14645);
      expect(roundDouble(interp.bicosineS(1, 2, 3, 4, 0.25, 0.75)), 2.85355);
      expect(roundDouble(interp.bicosineS(1, 2, 3, 4, 0.75, 0.75)), 3.56066);
    });

    test('should return accurate numbers when case is edge or middle case', () {
      expect(interp.bicosineS(a, b, c, d, 0, 0), a);
      expect(interp.bicosineS(a, b, c, d, 1, 0), b);
      expect(interp.bicosineS(a, b, c, d, 0, 1), c);
      expect(interp.bicosineS(a, b, c, d, 1, 1), d);
      expect(
        roundDouble(interp.bicosineS(a, b, c, d, 0.5, 0.5)),
        roundDouble(interp.bilinear(a, b, c, d, 0.5, 0.5)),
      );
    });
  });

  group('interp.cubicS', () {
    test('should return interpolated value between numbers', () {
      expect(roundDouble(interp.cubicS(1, 2, 0.25)), 1.15625);
      expect(roundDouble(interp.cubicS(1, 2, 0.75)), 1.84375);
    });

    test('should return correct value relative to other functions', () {
      final a = random.nextInt(100), b = random.nextInt(100) + 100;
      final t = random.nextDouble() / 2, value = interp.cubicS(a, b, t);
      expect(value, lessThan(interp.linear(a, b, t)));
      expect(value, greaterThan(interp.cosineS(a, b, t)));
      expect(value, greaterThan(interp.quinticS(a, b, t)));
    });

    test('should return accurate numbers when case is edge or middle case', () {
      expect(interp.cubicS(a, b, 0), a);
      expect(interp.cubicS(a, b, 1), b);
      expect(
        roundDouble(interp.cubicS(a, b, 0.5)),
        roundDouble(interp.linear(a, b, 0.5)),
      );
    });
  });

  group('interp.bicubicS', () {
    test('should return interpolated value between numbers', () {
      expect(roundDouble(interp.bicubicS(1, 2, 3, 4, 0.25, 0.25)), 1.46875);
      expect(roundDouble(interp.bicubicS(1, 2, 3, 4, 0.75, 0.25)), 2.15625);
      expect(roundDouble(interp.bicubicS(1, 2, 3, 4, 0.25, 0.75)), 2.84375);
      expect(roundDouble(interp.bicubicS(1, 2, 3, 4, 0.75, 0.75)), 3.53125);
    });

    test('should return accurate numbers when case is edge or middle case', () {
      expect(interp.bicubicS(a, b, c, d, 0, 0), a);
      expect(interp.bicubicS(a, b, c, d, 1, 0), b);
      expect(interp.bicubicS(a, b, c, d, 0, 1), c);
      expect(interp.bicubicS(a, b, c, d, 1, 1), d);
      expect(
        roundDouble(interp.bicubicS(a, b, c, d, 0.5, 0.5)),
        roundDouble(interp.bilinear(a, b, c, d, 0.5, 0.5)),
      );
    });
  });

  group('interp.quinticS', () {
    test('should return interpolated value between numbers', () {
      expect(roundDouble(interp.quinticS(1, 2, 0.25)), 1.10352);
      expect(roundDouble(interp.quinticS(1, 2, 0.75)), 1.89648);
    });

    test('should return correct value relative to other functions', () {
      final a = random.nextInt(100), b = random.nextInt(100) + 100;
      final t = random.nextDouble() / 2, value = interp.quinticS(a, b, t);
      expect(value, lessThan(interp.linear(a, b, t)));
      expect(value, lessThan(interp.cosineS(a, b, t)));
      expect(value, lessThan(interp.cubicS(a, b, t)));
    });

    test('should return accurate numbers when case is edge or middle case', () {
      expect(interp.quinticS(a, b, 0), a);
      expect(interp.quinticS(a, b, 1), b);
      expect(
        roundDouble(interp.quinticS(a, b, 0.5)),
        roundDouble(interp.linear(a, b, 0.5)),
      );
    });
  });

  group('interp.biquinticS', () {
    test('should return interpolated value between numbers', () {
      expect(roundDouble(interp.biquinticS(1, 2, 3, 4, 0.25, 0.25)), 1.31055);
      expect(roundDouble(interp.biquinticS(1, 2, 3, 4, 0.75, 0.25)), 2.10352);
      expect(roundDouble(interp.biquinticS(1, 2, 3, 4, 0.25, 0.75)), 2.89648);
      expect(roundDouble(interp.biquinticS(1, 2, 3, 4, 0.75, 0.75)), 3.68945);
    });

    test('should return accurate numbers when case is edge or middle case', () {
      expect(interp.biquinticS(a, b, c, d, 0, 0), a);
      expect(interp.biquinticS(a, b, c, d, 1, 0), b);
      expect(interp.biquinticS(a, b, c, d, 0, 1), c);
      expect(interp.biquinticS(a, b, c, d, 1, 1), d);
      expect(
        roundDouble(interp.biquinticS(a, b, c, d, 0.5, 0.5)),
        roundDouble(interp.bilinear(a, b, c, d, 0.5, 0.5)),
      );
    });
  });

  group('interp.recursive', () {
    test('should apply interpolation callback recursively', () {
      repeat(times: 100, () {
        final items = random.nextIntList(4, 500, -500);
        final t = random.nextDouble() * 2 - 0.5;
        final a = interp.linear(items[0], items[1], t);
        final b = interp.linear(items[1], items[2], t);
        final c = interp.linear(items[2], items[3], t);
        final d = interp.linear(a, b, t);
        final e = interp.linear(b, c, t);
        expect(
          interp.recursive(interp.linear, items, t),
          interp.linear(d, e, t),
        );
      });
      expect(interp.recursive(interp.linear, [1, 5, 9, 6, 9], 0.5), 6.75);
      expect(interp.recursive(interp.linear, [2, 6, 8, 4, 7, 9], 0.5), 6.125);
    });

    test('should return terminal results when case is edge case', () {
      final items = random.nextIntList(1000, 500, -500);
      expect(interp.recursive(interp.linear, items, 0), items.first);
      expect(interp.recursive(interp.linear, items, 1), items.last);
    });

    test('should throw when items collection is empty', () {
      expect(
        () => interp.recursive<num>(interp.linear, const [], 1),
        throwsStateError,
      );
    });
  });
}
