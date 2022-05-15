import 'dart:math';
import 'dart:typed_data';

import '../maths/interpolation/interpolate.dart';
import '../utils/iterable_utils.dart';

const _doubleFractionBitsAmount = 53;

final _epsilon256 = pow(2, 8 - _doubleFractionBitsAmount);
final _lessThan256 = pow(2, 8) - _epsilon256;

extension MapDynamicRange<T extends num> on Iterable<T> {
  Uint8List mapDynamicRangeToUint8List() {
    final result = Uint8List(length);
    var i = -1;
    for (final item in mapDynamicRange(0, _lessThan256)) {
      result[i += 1] = item.toInt();
    }
    return result;
  }

  Iterable<num> mapDynamicRange(num min, num max) {
    if (isEmpty) return const Iterable.empty();
    num flatten([Object? _]) => min;
    if (min == max) return map(flatten);
    assert(min < max);
    final currentMin = minValue, currentMax = maxValue;
    if (currentMin == currentMax) return map(flatten);
    final divider = currentMax - currentMin;
    return map((item) => interpLinear(min, max, (item - currentMin) / divider));
  }
}

extension MapNestedDynamicRange<T extends num> on Iterable<Iterable<T>> {
  Uint8List mapDynamicRangeToUint8List() {
    final result = Uint8List(fold(0, (sum, list) => sum + list.length));
    var i = -1;
    for (final list in mapDynamicRange(0, _lessThan256)) {
      for (final item in list) {
        result[i += 1] = item.toInt();
      }
    }
    return result;
  }

  Iterable<Iterable<num>> mapDynamicRange(num min, num max) {
    if (isEmpty) return const Iterable.empty();
    Iterable<num> flatten(Iterable<T> list) => list.mapDynamicRange(min, max);
    if (min == max) return map(flatten);
    assert(min < max);
    num currentMin = double.infinity, currentMax = -double.infinity;
    for (final list in this) {
      assert(list.isNotEmpty);
      for (final item in list) {
        if (item < currentMin) currentMin = item;
        if (item > currentMax) currentMax = item;
      }
    }
    if (currentMin == currentMax) return map(flatten);
    final divider = currentMax - currentMin;
    num interp(T item) => interpLinear(min, max, (item - currentMin) / divider);
    return map((list) => list.map(interp));
  }
}
