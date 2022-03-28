abstract class Tuple<A> {
  const Tuple(this.first);

  final A first;
}

class Pair<A, B> extends Tuple<A> {
  const Pair(super.first, this.second);

  final B second;

  @override
  int get hashCode => Object.hash(first, second);

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      other is Pair<A, B> && first == other.first && second == other.second;
}

class Trio<A, B, C> extends Pair<A, B> {
  const Trio(super.first, super.second, this.third);

  final C third;

  @override
  int get hashCode => Object.hash(first, second, third);

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      other is Trio<A, B, C> &&
          first == other.first &&
          second == other.second &&
          third == other.third;
}
