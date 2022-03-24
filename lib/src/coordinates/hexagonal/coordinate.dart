import '../coordinate.dart';
import 'direction.dart';

abstract class HexagonalCoordinate<D extends Enum,
        T extends HexagonalCoordinate<D, T>> = Coordinate<T>
    with MoveableCoordinate<D, T>;

mixin RotatableHexagonalCoordinate<D extends Enum,
        T extends HexagonalCoordinate<D, T>> on HexagonalCoordinate<D, T>
    implements RotatableCoordinate<int, T> {}

mixin HexagonalCoordinateOrigin<
        T extends HexagonalCoordinate<HexagonalDirection, T>>
    on HexagonalCoordinate<HexagonalDirection, T>
    implements CoordinateOrigin<T> {
  @override
  Iterable<T> get neighbors => getAllOnDistance(1);

  @override
  Iterable<T> getAllOnDistance(int distance) sync* {
    final radius = distance.abs();
    var coord = move(FlatToppedHexagonalDirection.bottomLeft.alias, radius);
    for (final direction in FlatToppedHexagonalDirection.values) {
      for (var i = 0; i < radius; i += 1) {
        yield coord;
        coord = coord.shift(direction.alias);
      }
    }
  }
}
