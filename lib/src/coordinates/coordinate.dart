abstract class Coordinate<T extends Coordinate<T>> {
  const Coordinate();

  int distanceTo(T other);
}

mixin MoveableCoordinate<D extends Enum, T extends Coordinate<T>>
    on Coordinate<T> {
  T shift(D direction);
  T move(D direction, int distance);
}

mixin RotatableCoordinate<S extends num, T extends Coordinate<T>>
    on Coordinate<T> {
  T rotate(S steps);
  T rotateAround(T other, S steps);
}

mixin CoordinateOrigin<T extends Coordinate<T>> on Coordinate<T> {
  Iterable<T> get neighbors;
  Iterable<T> getLineTo(T other);
  Iterable<T> getAllInRange(int distance);
  Iterable<T> getAllOnDistance(int distance);
}
