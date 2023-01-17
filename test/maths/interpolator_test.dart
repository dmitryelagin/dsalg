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

    setUp(() {
      values = getDoubleList(100);
      targets = getDoubleList(10);
    });

    group('as IntegerInterpolator', () {
      test('should return correct value from rounded target', () {
        for (final target in targets) {
          expect(
            const IntegerInterpolator().interpolate(values, target),
            values[target.round()],
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

    group('as BaseInterpolator', () {
      test('should pass correct arguments to callback', () {
        num sa = 0, sb = 0, st = 0;
        final interpolator = BaseInterpolator((a, b, t) {
          sa = a;
          sb = b;
          st = t;
          return 0;
        });
        for (final target in targets) {
          interpolator.interpolate(values, target);
          final t = target.toInt();
          expect(sa, values[t]);
          expect(sb, values[t + 1]);
          expect(st, target - t);
        }
      });

      test('should throw when target is out of data range', () {
        final interpolator = BaseInterpolator((_, __, ___) => 0);
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
      var sdata = <num>[], st = 0.0;
      double interp(List<num> data, double t) {
        sdata = data;
        st = t;
        return 0;
      }

      for (final entry in {
        'ExtendedInterpolator': ExtendedInterpolator(interp),
        'ExtendedCachedInterpolator': ExtendedCachedInterpolator(interp),
      }.entries) {
        final name = entry.key, interpolator = entry.value;

        test('$name should pass correct arguments to callback', () {
          for (final target in targets) {
            interpolator.interpolate(values, target);
            final t = target.toInt();
            expect(sdata.length, 4);
            for (var i = 0; i < 4; i += 1) {
              expect(sdata[i], values.elementAtSafe(t + i - 1));
            }
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

    setUp(() {
      values = List.generate(100, (_) => getDoubleList(100));
      targets = Map.fromIterables(getDoubleList(10), getDoubleList(10));
    });

    group('as IntegerInterpolator2D', () {
      test('should return correct value from rounded target', () {
        for (final target in targets.entries) {
          expect(
            const IntegerInterpolator2D()
                .interpolate(values, target.key, target.value),
            values[target.key.round()][target.value.round()],
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

    group('as BaseInterpolator2D', () {
      test('should pass correct arguments to callback', () {
        num sa = 0, sb = 0, sc = 0, sd = 0, stx = 0, sty = 0;
        final interpolator = BaseInterpolator2D((a, b, c, d, tx, ty) {
          sa = a;
          sb = b;
          sc = c;
          sd = d;
          stx = tx;
          sty = ty;
          return 0;
        });
        for (final target in targets.entries) {
          interpolator.interpolate(values, target.key, target.value);
          final x = target.key.toInt(), y = target.value.toInt();
          expect(sa, values[x][y]);
          expect(sb, values[x + 1][y]);
          expect(sc, values[x][y + 1]);
          expect(sd, values[x + 1][y + 1]);
          expect(stx, target.key - x);
          expect(sty, target.value - y);
        }
      });

      test('should throw when target is out of data range', () {
        final interpolator =
            BaseInterpolator2D((_, __, ___, ____, _____, ______) => 0);
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
      var sdata = <List<num>>[], stx = 0.0, sty = 0.0;
      double interp(List<List<num>> data, double tx, double ty) {
        sdata = data;
        stx = tx;
        sty = ty;
        return 0;
      }

      for (final entry in {
        'ExtendedInterpolator2D': ExtendedInterpolator2D(interp),
        'ExtendedCachedInterpolator2D': ExtendedCachedInterpolator2D(interp),
      }.entries) {
        final name = entry.key, interpolator = entry.value;

        test('$name should pass correct arguments to callback', () {
          for (final target in targets.entries) {
            interpolator.interpolate(values, target.key, target.value);
            final x = target.key.toInt(), y = target.value.toInt();
            expect(sdata.map((list) => list.length).sum, 16);
            for (var i = 0; i < 4; i += 1) {
              for (var j = 0; j < 4; j += 1) {
                expect(
                  sdata[i][j],
                  values.elementAtSafe(x + i - 1).elementAtSafe(y + j - 1),
                );
              }
            }
            expect(stx, target.key - x);
            expect(sty, target.value - y);
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
