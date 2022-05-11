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

  Iterable<double> mapDynamicRange(num min, num max) {
    if (isEmpty) return const Iterable.empty();
    double toMinDouble([Object? _]) => min.toDouble();
    if (min == max) return map(toMinDouble);
    assert(min < max);
    final currentMin = minValue, currentMax = maxValue;
    if (currentMin == currentMax) return map(toMinDouble);
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

  Iterable<Iterable<double>> mapDynamicRange(num min, num max) {
    if (isEmpty) return const Iterable.empty();
    Iterable<double> toMinDouble(Iterable<T> list) =>
        list.mapDynamicRange(min, max);
    if (min == max) return map(toMinDouble);
    assert(min < max);
    num currentMin = double.infinity, currentMax = -double.infinity;
    for (final list in this) {
      assert(list.isNotEmpty);
      for (final item in list) {
        if (item < currentMin) currentMin = item;
        if (item > currentMax) currentMax = item;
      }
    }
    if (currentMin == currentMax) return map(toMinDouble);
    final divider = currentMax - currentMin;
    double mapItem(T item) =>
        interpLinear(min, max, (item - currentMin) / divider);
    return map((list) => list.map(mapItem));
  }
}
