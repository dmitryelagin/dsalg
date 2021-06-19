import 'dart:math';

import '../utils/int_utils.dart';

extension RadixSort<T> on List<T> {
  static List<T> execute<T>(List<T> items, int Function(T) getKey) {
    final buckets = List.generate(10, (_) => <T>[]);
    var pass = 0, passesAmount = 1, result = items;
    while (pass < passesAmount) {
      for (final item in result) {
        final key = getKey(item);
        if (pass == 0) passesAmount = max(passesAmount, key.length);
        buckets[key.getDigit(pass)].add(item);
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

  void radixSort(int Function(T) getKey) {
    final result = execute(this, getKey);
    clear();
    addAll(result);
  }
}
