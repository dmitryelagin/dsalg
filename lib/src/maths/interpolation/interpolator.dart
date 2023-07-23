import '../../utils/list_utils.dart';
import 'interpolate.dart';

abstract class Interpolator {
  factory Interpolator.cubic() => CubicInterpolator(interpCubic);

  factory Interpolator.cubicCached() => CubicCachedInterpolator(interpCubic);

  static const integer = IntegerInterpolator();
  static const linear = BaseInterpolator(interpLinear);
  static const cubicS = BaseInterpolator(interpCubicS);
  static const cosineS = BaseInterpolator(interpCosineS);
  static const quinticS = BaseInterpolator(interpQuinticS);

  num interpolate(List<num> data, double t);
}

abstract class Interpolator2D {
  factory Interpolator2D.biCubic() => CubicInterpolator2D(interpBiCubic);

  factory Interpolator2D.biCubicCached() =>
      CubicCachedInterpolator2D(interpBiCubic);

  static const biInteger = IntegerInterpolator2D();
  static const biLinear = BaseInterpolator2D(interpBiLinear);
  static const biCubicS = BaseInterpolator2D(interpBiCubicS);
  static const biCosineS = BaseInterpolator2D(interpBiCosineS);
  static const biQuinticS = BaseInterpolator2D(interpBiQuinticS);

  num interpolate(List<List<num>> data, double tx, double ty);
}

class IntegerInterpolator implements Interpolator {
  const IntegerInterpolator();

  @override
  num interpolate(List<num> data, double t) => data[t.round()];
}

class IntegerInterpolator2D implements Interpolator2D {
  const IntegerInterpolator2D();

  @override
  num interpolate(List<List<num>> data, double tx, double ty) =>
      data[tx.round()][ty.round()];
}

class BaseInterpolator implements Interpolator {
  const BaseInterpolator(this._interp);

  final num Function(num, num, double) _interp;

  @override
  num interpolate(List<num> data, double t) {
    final i = t.toInt();
    return _interp(data[i], data[i + 1], t - i);
  }
}

class BaseInterpolator2D implements Interpolator2D {
  const BaseInterpolator2D(this._interp);

  final num Function(num, num, num, num, double, double) _interp;

  @override
  num interpolate(List<List<num>> data, double tx, double ty) {
    final x = tx.toInt(), y = ty.toInt();
    return _interp(
      data[x][y],
      data[x + 1][y],
      data[x][y + 1],
      data[x + 1][y + 1],
      tx - x,
      ty - y,
    );
  }
}

class CubicInterpolator implements Interpolator {
  CubicInterpolator(this._interp);

  final num Function(CubicEntry<num>, double) _interp;

  @override
  num interpolate(List<num> data, double t) {
    final i = t.toInt();
    return _interp(data.getCubicValues(i), t - i);
  }
}

class CubicInterpolator2D implements Interpolator2D {
  CubicInterpolator2D(this._interp);

  final num Function(CubicEntry<CubicEntry<num>>, double, double) _interp;

  @override
  num interpolate(List<List<num>> data, double tx, double ty) {
    final x = tx.toInt(), y = ty.toInt();
    return _interp(data.getCubicValues(x, y), tx - x, ty - y);
  }
}

class CubicCachedInterpolator extends CubicInterpolator {
  CubicCachedInterpolator(super.interp);

  List<num>? _prevData;

  var _prevI = 0;

  CubicEntry<num> _values = (0, 0, 0, 0);

  @override
  num interpolate(List<num> data, double t) {
    final i = t.toInt();
    if (!identical(data, _prevData) || i != _prevI) {
      _prevData = data;
      _prevI = i;
      _values = data.getCubicValues(i);
    }
    return _interp(_values, t - i);
  }

  void invalidate() {
    _prevData = null;
  }
}

class CubicCachedInterpolator2D extends CubicInterpolator2D {
  CubicCachedInterpolator2D(super.interp);

  List<List<num>>? _prevData;

  var _prevX = 0, _prevY = 0;

  CubicEntry<CubicEntry<num>> _values =
      ((0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0));

  @override
  num interpolate(List<List<num>> data, double tx, double ty) {
    final x = tx.toInt(), y = ty.toInt();
    if (!identical(data, _prevData) || x != _prevX || y != _prevY) {
      _prevData = data;
      _prevX = x;
      _prevY = y;
      _values = data.getCubicValues(x, y);
    }
    return _interp(_values, tx - x, ty - y);
  }

  void invalidate() {
    _prevData = null;
  }
}

extension _CubicListUtils on List<num> {
  CubicEntry<num> getCubicValues(int i) => (
        getSafeTerminal(i - 1),
        getSafeTerminal(i),
        getSafeTerminal(i + 1),
        getSafeTerminal(i + 2),
      );
}

extension _CubicList2DUtils on List<List<num>> {
  CubicEntry<CubicEntry<num>> getCubicValues(int x, int y) => (
        getSafeTerminal(x - 1).getCubicValues(y),
        getSafeTerminal(x).getCubicValues(y),
        getSafeTerminal(x + 1).getCubicValues(y),
        getSafeTerminal(x + 2).getCubicValues(y),
      );
}
