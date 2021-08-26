import 'dart:math';

List<int> createIntList(int length, int to, [int from = 0, Random? random]) =>
    List.generate(length, (_) {
      return (random ?? Random()).nextInt(to - from) + from;
    });

Set<int> createIntSet(int length, int to, [int from = 0, Random? random]) {
  final result = <int>{};
  while (result.length <= length) {
    result.add((random ?? Random()).nextInt(to) + from);
  }
  return result;
}

Map<int, int> createIntMap(int length, int to, [int? from, Random? random]) =>
    Map.fromIterable(createIntList(length, to, from ?? 0, random));

extension IntListTestUtils on List<int> {
  List<int> copySort(Comparator<int> compare) => toList()..sort(compare);
}
