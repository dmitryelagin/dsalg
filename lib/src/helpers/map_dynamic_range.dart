import 'dart:math';
import 'dart:typed_data';

import '../../helpers.dart';
import '../maths/interpolation/interpolate.dart';
import '../utils/iterable_utils.dart';

const _doubleFractionBitsAmount = 53;

final _epsilon256 = pow(2, 8 - _doubleFractionBitsAmount);
final _lessThan256 = pow(2, 8) - _epsilon256;

extension MapDynamicRange<T extends num> on Iterable<T> {
  Uint8List mapDynamicRangeToUint8List() =>
      mapDynamicRange(0, _lessThan256).toUint8List();

  Iterable<num> mapDynamicRange(num min, num max) {
    if (isEmpty) return const Iterable.empty();
    num flatten([Object? _]) => min;
    if (min == max) return map(flatten);
    assert(min < max);
    final actualMinMax = minMaxValue;
    final actualMin = actualMinMax.first, actualMax = actualMinMax.second;
    if (actualMin == actualMax) return map(flatten);
    final divider = actualMax - actualMin;
    return map((item) => interpLinear(min, max, (item - actualMin) / divider));
  }
}

extension Map2DDynamicRange<T extends num> on Iterable<Iterable<T>> {
  Uint8List mapDynamicRangeToUint8List() =>
      mapDynamicRange(0, _lessThan256).toUint8List();

  Iterable<Iterable<num>> mapDynamicRange(num min, num max) {
    if (isEmpty) return const Iterable.empty();
    Iterable<num> flatten(Iterable<T> list) => list.mapDynamicRange(min, max);
    if (min == max) return map(flatten);
    assert(min < max);
    final actualMinMax = minMaxValue;
    final actualMin = actualMinMax.first, actualMax = actualMinMax.second;
    if (actualMin == actualMax) return map(flatten);
    final divider = actualMax - actualMin;
    num interp(T item) => interpLinear(min, max, (item - actualMin) / divider);
    return map((list) => list.map(interp));
  }
}
