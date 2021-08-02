import 'dart:math';

List<int> createIntList(int length, int to, [int from = 0, Random? random]) =>
    List.generate(length, (_) => (random ?? Random()).nextInt(to) + from);

Map<int, int> createIntMap(int length, int to, [int? from, Random? random]) =>
    Map.fromIterable(createIntList(length, to, from ?? 0, random));

extension IntListTestUtils on List<int> {
  List<int> copySort(Comparator<int> compare) => List.of(this)..sort(compare);
}
