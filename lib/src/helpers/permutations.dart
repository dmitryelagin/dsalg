extension Permutations<T> on Iterable<T> {
  Iterable<List<T>> get permutations =>
      isNotEmpty ? _getPermutations(List.of(this)) : const [[]];

  Iterable<List<T>> _getPermutations(List<T> items) sync* {
    if (items.length == 1) {
      yield [items.first];
    } else {
      for (var i = 0; i < items.length; i += 1) {
        final item = items.removeLast();
        for (final permutation in _getPermutations(items)) {
          yield permutation..add(item);
        }
        items.insert(0, item);
      }
    }
  }
}
