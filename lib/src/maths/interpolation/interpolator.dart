import 'dart:collection';

import '../../utils/iterable_utils.dart';
import 'interpolate.dart';

abstract class Interpolator1D {
  factory Interpolator1D.cubicCached() =>
      ExtendedCachedInterpolator1D(interpCubic);

  static const integer = IntegerInterpolator1D();
  static const linear = BaseInterpolator1D(interpLinear);
  static const cubic = ExtendedInterpolator1D(interpCubic);
  static const cubicS = BaseInterpolator1D(interpCubicS);
  static const cosineS = BaseInterpolator1D(interpCosineS);
  static const quinticS = BaseInterpolator1D(interpQuinticS);

  double interpolate(Iterable<num> data, double t);
}

abstract class Interpolator2D {
  factory Interpolator2D.biCubicCached() =>
      ExtendedCachedInterpolator2D(interpBiCubic);

  static const biInteger = IntegerInterpolator2D();
  static const biLinear = BaseInterpolator2D(interpBiLinear);
  static const biCubic = ExtendedInterpolator2D(interpBiCubic);
  static const biCubicS = BaseInterpolator2D(interpBiCubicS);
  static const biCosineS = BaseInterpolator2D(interpBiCosineS);
  static const biQuinticS = BaseInterpolator2D(interpBiQuinticS);

  double interpolate(Iterable<Iterable<num>> data, double tx, double ty);
}

class IntegerInterpolator1D implements Interpolator1D {
  const IntegerInterpolator1D();

  @override
  double interpolate(Iterable<num> data, double t) =>
      data.elementAt(t.round()).toDouble();
}

class IntegerInterpolator2D implements Interpolator2D {
  const IntegerInterpolator2D();

  @override
  double interpolate(Iterable<Iterable<num>> data, double tx, double ty) =>
      data.elementAt(tx.round()).elementAt(ty.round()).toDouble();
}

class BaseInterpolator1D implements Interpolator1D {
  const BaseInterpolator1D(this._interp);

  final double Function(num, num, double) _interp;

  @override
  double interpolate(Iterable<num> data, double t) {
    final i = t.toInt();
    return _interp(data.elementAt(i), data.elementAt(i + 1), t - i);
  }
}

class BaseInterpolator2D implements Interpolator2D {
  const BaseInterpolator2D(this._interp);

  final double Function(num, num, num, num, double, double) _interp;

  @override
  double interpolate(Iterable<Iterable<num>> data, double tx, double ty) {
    final x = tx.toInt(), y = ty.toInt();
    return _interp(
      data.elementAt(x).elementAt(y),
      data.elementAt(x + 1).elementAt(y),
      data.elementAt(x).elementAt(y + 1),
      data.elementAt(x + 1).elementAt(y + 1),
      tx - x,
      ty - y,
    );
  }
}

class ExtendedInterpolator1D implements Interpolator1D {
  const ExtendedInterpolator1D(this._interp);

  final double Function(List<num>, double) _interp;

  @override
  double interpolate(Iterable<num> data, double t) {
    final i = t.toInt();
    final values = [
      for (var j = 0; j < 4; j += 1) data.elementAtSafe(i + j - 1),
    ];
    return _interp(values, t - i);
  }
}

class ExtendedInterpolator2D implements Interpolator2D {
  const ExtendedInterpolator2D(this._interp);

  final double Function(List<List<num>>, double, double) _interp;

  @override
  double interpolate(Iterable<Iterable<num>> data, double tx, double ty) {
    final x = tx.toInt(), y = ty.toInt();
    final values = [
      for (var i = 0; i < 4; i += 1)
        [
          for (var j = 0; j < 4; j += 1)
            data.elementAtSafe(x + i - 1).elementAtSafe(y + j - 1),
        ],
    ];
    return _interp(values, tx - x, ty - y);
  }
}

class ExtendedCachedInterpolator1D extends ExtendedInterpolator1D {
  ExtendedCachedInterpolator1D(super.interp) {
    _cacheView = UnmodifiableListView(_cache);
  }

  final _cache = List<num>.filled(4, 0);

  late UnmodifiableListView<num> _cacheView;

  Iterable<num>? _prevData;

  var _prevI = 0;

  @override
  double interpolate(Iterable<num> data, double t) {
    final i = t.toInt();
    if (!identical(data, _prevData) || i != _prevI) {
      _prevData = data;
      _prevI = i;
      for (var j = 0; j < 4; j += 1) {
        _cache[j] = data.elementAtSafe(i + j - 1);
      }
    }
    return _interp(_cacheView, t - i);
  }

  void invalidate() {
    _prevData = null;
  }
}

class ExtendedCachedInterpolator2D extends ExtendedInterpolator2D {
  ExtendedCachedInterpolator2D(super.interp) {
    final innerCacheViews = _cache.map(UnmodifiableListView.new).toList();
    _cacheView = UnmodifiableListView(innerCacheViews);
  }

  final _cache = List.generate(4, (_) => List<num>.filled(4, 0));

  late UnmodifiableListView<List<num>> _cacheView;

  Iterable<Iterable<num>>? _prevData;

  var _prevX = 0, _prevY = 0;

  @override
  double interpolate(Iterable<Iterable<num>> data, double tx, double ty) {
    final x = tx.toInt(), y = ty.toInt();
    if (!identical(data, _prevData) || x != _prevX || y != _prevY) {
      _prevData = data;
      _prevX = x;
      _prevY = y;
      for (var i = 0; i < 4; i += 1) {
        for (var j = 0; j < 4; j += 1) {
          _cache[i][j] = data.elementAtSafe(x + i - 1).elementAtSafe(y + j - 1);
        }
      }
    }
    return _interp(_cacheView, tx - x, ty - y);
  }

  void invalidate() {
    _prevData = null;
  }
}
