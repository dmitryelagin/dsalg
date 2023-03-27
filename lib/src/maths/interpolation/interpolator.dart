import '../../utils/list_utils.dart';
import 'interpolate.dart';

abstract class Interpolator {
  factory Interpolator.cubic() => ExtendedInterpolator(interpCubic);

  factory Interpolator.cubicCached() => ExtendedCachedInterpolator(interpCubic);

  static const integer = IntegerInterpolator();
  static const linear = BaseInterpolator(interpLinear);
  static const cubicS = BaseInterpolator(interpCubicS);
  static const cosineS = BaseInterpolator(interpCosineS);
  static const quinticS = BaseInterpolator(interpQuinticS);

  num interpolate(List<num> data, double t);
}

abstract class Interpolator2D {
  factory Interpolator2D.biCubic() => ExtendedInterpolator2D(interpBiCubic);

  factory Interpolator2D.biCubicCached() =>
      ExtendedCachedInterpolator2D(interpBiCubic);

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

class ExtendedInterpolator implements Interpolator {
  ExtendedInterpolator(this._interp);

  final num Function(List<num>, double) _interp;

  final _values = List<num>.filled(4, 0);

  @override
  num interpolate(List<num> data, double t) {
    final i = t.toInt();
    for (var j = 0; j < 4; j += 1) {
      _values[j] = data.getSafeTerminal(i + j - 1);
    }
    return _interp(_values, t - i);
  }
}

class ExtendedInterpolator2D implements Interpolator2D {
  ExtendedInterpolator2D(this._interp);

  final num Function(List<List<num>>, double, double) _interp;

  final _values = List.generate(4, (_) => List<num>.filled(4, 0));

  @override
  num interpolate(List<List<num>> data, double tx, double ty) {
    final x = tx.toInt(), y = ty.toInt();
    for (var i = 0; i < 4; i += 1) {
      for (var j = 0; j < 4; j += 1) {
        _values[i][j] =
            data.getSafeTerminal(x + i - 1).getSafeTerminal(y + j - 1);
      }
    }
    return _interp(_values, tx - x, ty - y);
  }
}

class ExtendedCachedInterpolator extends ExtendedInterpolator {
  ExtendedCachedInterpolator(super.interp);

  List<num>? _prevData;

  var _prevI = 0;

  @override
  num interpolate(List<num> data, double t) {
    final i = t.toInt();
    if (!identical(data, _prevData) || i != _prevI) {
      _prevData = data;
      _prevI = i;
      return super.interpolate(data, t);
    }
    return _interp(_values, t - i);
  }

  void invalidate() {
    _prevData = null;
  }
}

class ExtendedCachedInterpolator2D extends ExtendedInterpolator2D {
  ExtendedCachedInterpolator2D(super.interp);

  List<List<num>>? _prevData;

  var _prevX = 0, _prevY = 0;

  @override
  num interpolate(List<List<num>> data, double tx, double ty) {
    final x = tx.toInt(), y = ty.toInt();
    if (!identical(data, _prevData) || x != _prevX || y != _prevY) {
      _prevData = data;
      _prevX = x;
      _prevY = y;
      return super.interpolate(data, tx, ty);
    }
    return _interp(_values, tx - x, ty - y);
  }

  void invalidate() {
    _prevData = null;
  }
}
