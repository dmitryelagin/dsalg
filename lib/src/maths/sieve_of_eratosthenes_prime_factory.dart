import 'dart:math';

class SieveOfEratosthenesPrimeFactory {
  static final instance = SieveOfEratosthenesPrimeFactory();

  final _checks = <bool>[];

  Iterable<int> getAllBelow(int limit) sync* {
    final lastCheckIndex = _checks.length - 1;
    if (limit > _checks.length) {
      _checks.addAll(List.filled(limit - _checks.length, true));
    }
    for (var i = 2; i < limit; i += 1) {
      if (!_checks[i]) continue;
      yield i;
      for (var j = max(i * i, lastCheckIndex ~/ i * i + i); j < limit; j += i) {
        _checks[j] = false;
      }
    }
  }

  void invalidate() {
    _checks.clear();
  }
}
