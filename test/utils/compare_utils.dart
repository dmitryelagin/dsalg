import 'package:dsalg/dsalg.dart';

class IntComparator extends MemoizedComparator<int> {
  IntComparator() : super((a, b) => a - b);
}

extension RoundDoubleUtils on double {
  double roundTo(int precision) => double.parse(toStringAsFixed(precision));
}

extension RoundIterableDoubleUtils on Iterable<double> {
  Iterable<double> roundTo(int precision) =>
      map((item) => item.roundTo(precision));
}

extension RoundIterableIterableDoubleUtils on Iterable<Iterable<double>> {
  Iterable<Iterable<double>> roundTo(int precision) =>
      map((list) => list.roundTo(precision));
}
