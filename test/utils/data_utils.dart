import 'dart:math';

extension RandomDataUtils on Random {
  List<bool> nextBoolList(int length) =>
      [for (var i = 0; i < length; i += 1) nextBool()];

  List<String> nextStringList(int length, int min, int max) =>
      List.generate(length, (_) => nextString(min, max));

  String nextString(int min, int max) {
    var length = nextInt(max - min) + min;
    final buffer = StringBuffer();
    while ((length -= 1) >= 0) {
      buffer.writeCharCode(nextInt(128));
    }
    return buffer.toString();
  }

  List<int> nextIntList(int length, int to, [int from = 0]) =>
      List.generate(length, (_) => nextInt(to - from) + from);

  Set<int> nextIntSet(int length, int to, [int from = 0]) {
    final result = <int>{};
    while (result.length <= length) {
      result.add(nextInt(to) + from);
    }
    return result;
  }

  Map<int, int> nextIntMap(int length, int to, [int? from]) =>
      Map.fromIterable(nextIntList(length, to, from ?? 0));

  List<Point<int>> nextIntPointList(int length, int to, [int from = 0]) =>
      List.generate(length, (_) => nextIntPoint(to, from));

  Point<int> nextIntPoint(int to, [int from = 0]) =>
      Point(nextInt(to - from) + from, nextInt(to - from) + from);

  Point<double> nextDoublePoint() => Point(nextDouble(), nextDouble());
}

extension IntListTestUtils on List<int> {
  List<int> copySort(Comparator<int> compare) => toList()..sort(compare);
}
