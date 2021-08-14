import 'dart:math';

import '../bits/bit_array.dart';

class SieveOfEratosthenesPrimeSeriesFactory {
  static final instance = SieveOfEratosthenesPrimeSeriesFactory();

  final _checks = BitArray();

  Iterable<int> getAllBelow(int limit) sync* {
    final lastCheckIndex = _checks.length - 1;
    _checks.tryGrowFor(limit);
    for (var i = 2; i < _checks.length; i += 1) {
      if (_checks.isSetBit(i)) continue;
      if (i <= limit) yield i;
      final startIndex = max(i * i, lastCheckIndex ~/ i * i + i);
      for (var j = startIndex; j < _checks.length; j += i) {
        _checks.setBit(j);
      }
    }
  }

  void invalidate() {
    _checks.reset();
  }
}
