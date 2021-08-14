extension Permutations<T> on List<T> {
  Iterable<List<T>> get permutations =>
      isNotEmpty ? List.of(this)._permutations : const [[]];

  Iterable<List<T>> get _permutations sync* {
    if (length == 1) {
      yield [first];
    } else {
      for (var i = 0; i < length; i += 1) {
        final item = removeLast();
        for (final items in _permutations) {
          yield items..add(item);
        }
        insert(0, item);
      }
    }
  }
}
