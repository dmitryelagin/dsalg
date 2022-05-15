import 'dart:math';

import 'package:dsalg/dsalg.dart';

class IntComparator extends MemoizedComparator<int> {
  IntComparator() : super((a, b) => a - b);
}

extension RoundNumUtils on num {
  double roundTo(int precision) => double.parse(toStringAsFixed(precision));
}

extension RoundIterableNumUtils on Iterable<num> {
  Iterable<double> roundTo(int precision) =>
      map((item) => item.roundTo(precision));
}

extension RoundIterableIterableNumUtils on Iterable<Iterable<num>> {
  Iterable<Iterable<double>> roundTo(int precision) =>
      map((list) => list.roundTo(precision));
}

extension RoundPointNumUtils on Point<num> {
  Point<double> roundTo(int precision) =>
      Point(x.roundTo(precision), y.roundTo(precision));
}
