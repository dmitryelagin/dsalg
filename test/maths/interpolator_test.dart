import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';
import '../utils/iterable_utils.dart';

void main() {
  final random = Random();

  List<double> getDoubleList(int length) => random
      .nextDoubleList(length)
      .map((item) => item * random.nextInt(100))
      .toList();

  group('Interpolator', () {
    var values = <num>[], targets = <double>[];

    num getValue(int i) => values[i];
    num getValueSafe(int i) => values.elementAtSafe(i);

    setUp(() {
      values = getDoubleList(100);
      targets = getDoubleList(10);
    });

    group('as IntegerInterpolator', () {
      test('should return correct value from rounded target', () {
        for (final target in targets) {
          expect(
            const IntegerInterpolator().interpolate(values, target),
            getValue(target.round()),
          );
        }
      });

      test('should throw when target is out of data range', () {
        expect(
          () => const IntegerInterpolator().interpolate(values, 200.5),
          throwsRangeError,
        );
        expect(
          () => const IntegerInterpolator().interpolate(values, -2),
          throwsRangeError,
        );
      });
    });

    group('as StandardInterpolator', () {
      test('should pass correct arguments to callback', () {
        num sa = 0, sb = 0, st = 0;
        final interpolator = StandardInterpolator((a, b, t) {
          sa = a;
          sb = b;
          st = t;
          return 0;
        });
        for (final target in targets) {
          interpolator.interpolate(values, target);
          final t = target.toInt();
          expect(sa, getValue(t));
          expect(sb, getValue(t + 1));
          expect(st, target - t);
        }
      });

      test('should throw when target is out of data range', () {
        final interpolator = StandardInterpolator((_, __, ___) => 0);
        expect(
          () => interpolator.interpolate(values, 200.5),
          throwsRangeError,
        );
        expect(
          () => interpolator.interpolate(values, -2),
          throwsRangeError,
        );
      });
    });

    group('as', () {
      CubicEntry<num> sdata = (0, 0, 0, 0);
      var st = 0.0;
      double interp(CubicEntry<num> data, double t) {
        sdata = data;
        st = t;
        return 0;
      }

      for (final entry in {
        'CubicInterpolator': CubicInterpolator(interp),
        'CubicCachedInterpolator': CubicCachedInterpolator(interp),
      }.entries) {
        final name = entry.key, interpolator = entry.value;

        test('$name should pass correct arguments to callback', () {
          for (final target in targets) {
            interpolator.interpolate(values, target);
            final t = target.toInt();
            expect(sdata.$1, getValueSafe(t - 1));
            expect(sdata.$2, getValueSafe(t));
            expect(sdata.$3, getValueSafe(t + 1));
            expect(sdata.$4, getValueSafe(t + 2));
            expect(st, target - t);
          }
        });

        test('$name should not throw when target is out of data range', () {
          expect(interpolator.interpolate(values, 200.5), 0);
          expect(interpolator.interpolate(values, -2), 0);
        });

        test('$name should throw when provided data is empty', () {
          expect(
            () => interpolator.interpolate([], 0),
            throwsStateError,
          );
        });
      }
    });
  });

  group('Interpolator2D', () {
    var values = <List<num>>[], targets = <double, double>{};

    num getValue(int x, int y) => values[x][y];
    num getValueSafe(int x, int y) => values.elementAtSafe(x).elementAtSafe(y);

    setUp(() {
      values = List.generate(100, (_) => getDoubleList(100));
      targets = Map.fromIterables(getDoubleList(10), getDoubleList(10));
    });

    group('as IntegerInterpolator2D', () {
      test('should return correct value from rounded target', () {
        for (final MapEntry(:key, :value) in targets.entries) {
          expect(
            const IntegerInterpolator2D().interpolate(values, key, value),
            getValue(key.round(), value.round()),
          );
        }
      });

      test('should throw when target is out of data range', () {
        expect(
          () => const IntegerInterpolator2D().interpolate(values, 200.5, 45),
          throwsRangeError,
        );
        expect(
          () => const IntegerInterpolator2D().interpolate(values, -2, 4),
          throwsRangeError,
        );
        expect(
          () => const IntegerInterpolator2D().interpolate(values, 20, -45),
          throwsRangeError,
        );
        expect(
          () => const IntegerInterpolator2D().interpolate(values, 2, 456),
          throwsRangeError,
        );
      });
    });

    group('as StandardInterpolator2D', () {
      test('should pass correct arguments to callback', () {
        num sa = 0, sb = 0, sc = 0, sd = 0, stx = 0, sty = 0;
        final interpolator = StandardInterpolator2D((a, b, c, d, tx, ty) {
          sa = a;
          sb = b;
          sc = c;
          sd = d;
          stx = tx;
          sty = ty;
          return 0;
        });
        for (final MapEntry(:key, :value) in targets.entries) {
          interpolator.interpolate(values, key, value);
          final x = key.toInt(), y = value.toInt();
          expect(sa, getValue(x, y));
          expect(sb, getValue(x + 1, y));
          expect(sc, getValue(x, y + 1));
          expect(sd, getValue(x + 1, y + 1));
          expect(stx, key - x);
          expect(sty, value - y);
        }
      });

      test('should throw when target is out of data range', () {
        final interpolator =
            StandardInterpolator2D((_, __, ___, ____, _____, ______) => 0);
        expect(
          () => interpolator.interpolate(values, 200.5, 45),
          throwsRangeError,
        );
        expect(
          () => interpolator.interpolate(values, -2, 4),
          throwsRangeError,
        );
        expect(
          () => interpolator.interpolate(values, 20, -45),
          throwsRangeError,
        );
        expect(
          () => interpolator.interpolate(values, 2, 456),
          throwsRangeError,
        );
      });
    });

    group('as', () {
      CubicEntry<CubicEntry<num>> sdata =
          ((0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0));
      var stx = 0.0, sty = 0.0;
      double interp(CubicEntry<CubicEntry<num>> data, double tx, double ty) {
        sdata = data;
        stx = tx;
        sty = ty;
        return 0;
      }

      for (final entry in {
        'CubicInterpolator2D': CubicInterpolator2D(interp),
        'CubicCachedInterpolator2D': CubicCachedInterpolator2D(interp),
      }.entries) {
        final name = entry.key, interpolator = entry.value;

        test('$name should pass correct arguments to callback', () {
          for (final MapEntry(:key, :value) in targets.entries) {
            interpolator.interpolate(values, key, value);
            final x = key.toInt(), y = value.toInt();
            expect(sdata.$1.$1, getValueSafe(x - 1, y - 1));
            expect(sdata.$1.$2, getValueSafe(x - 1, y));
            expect(sdata.$1.$3, getValueSafe(x - 1, y + 1));
            expect(sdata.$1.$4, getValueSafe(x - 1, y + 2));
            expect(sdata.$2.$1, getValueSafe(x, y - 1));
            expect(sdata.$2.$2, getValueSafe(x, y));
            expect(sdata.$2.$3, getValueSafe(x, y + 1));
            expect(sdata.$2.$4, getValueSafe(x, y + 2));
            expect(sdata.$3.$1, getValueSafe(x + 1, y - 1));
            expect(sdata.$3.$2, getValueSafe(x + 1, y));
            expect(sdata.$3.$3, getValueSafe(x + 1, y + 1));
            expect(sdata.$3.$4, getValueSafe(x + 1, y + 2));
            expect(sdata.$4.$1, getValueSafe(x + 2, y - 1));
            expect(sdata.$4.$2, getValueSafe(x + 2, y));
            expect(sdata.$4.$3, getValueSafe(x + 2, y + 1));
            expect(sdata.$4.$4, getValueSafe(x + 2, y + 2));
            expect(stx, key - x);
            expect(sty, value - y);
          }
        });

        test('$name should not throw when target is out of data range', () {
          expect(interpolator.interpolate(values, 200.5, 45), 0);
          expect(interpolator.interpolate(values, -2, 4), 0);
          expect(interpolator.interpolate(values, 20, -45), 0);
          expect(interpolator.interpolate(values, 2, 456), 0);
        });

        test('$name should throw when provided data is empty', () {
          expect(
            () => interpolator.interpolate([], 0, 0),
            throwsStateError,
          );
        });
      }
    });
  });
}
