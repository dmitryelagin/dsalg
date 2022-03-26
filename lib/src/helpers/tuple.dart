abstract class Tuple<A> {
  A get first;
}

class Pair<A, B> implements Tuple<A> {
  const Pair(this.first, this.second);

  @override
  final A first;

  final B second;
}

class Trio<A, B, C> implements Pair<A, B> {
  const Trio(this.first, this.second, this.third);

  @override
  final A first;

  @override
  final B second;

  final C third;
}
