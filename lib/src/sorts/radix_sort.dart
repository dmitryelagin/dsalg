import 'dart:math';

import 'utils/int_utils.dart';

extension RadixSort on List<int> {
  static final _buckets = {for (var i = 0; i <= 9; i += 1) i: <int>[]};

  void radixSort() {
    var pass = 0, passesAmount = 1;
    while (pass < passesAmount) {
      for (final item in this) {
        if (pass == 0) passesAmount = max(passesAmount, item.length);
        _buckets[item.getDigit(pass)]!.add(item);
      }
      clear();
      for (final bucket in _buckets.values) {
        addAll(bucket);
        bucket.clear();
      }
      pass += 1;
    }
  }
}
