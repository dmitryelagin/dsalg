import 'dart:math';

import '../utils/int_utils.dart';

extension RadixSort on List<int> {
  static List<int> execute(List<int> items) {
    final buckets = List.generate(10, (_) => <int>[]);
    var pass = 0, passesAmount = 1, result = items;
    while (pass < passesAmount) {
      for (final item in result) {
        if (pass == 0) passesAmount = max(passesAmount, item.length);
        buckets[item.getDigit(pass)].add(item);
      }
      if (result == items) result = [];
      result.clear();
      for (final bucket in buckets) {
        result.addAll(bucket);
        bucket.clear();
      }
      pass += 1;
    }
    return result;
  }

  void radixSort() {
    final result = execute(this);
    clear();
    addAll(result);
  }
}
