import 'coordinate.dart';
import 'cube_coordinate.dart';
import 'direction.dart';

abstract class OffsetCoordinate<D extends Enum,
    T extends OffsetCoordinate<D, T>> extends HexagonalCoordinate<D, T> {
  const OffsetCoordinate(this.q, this.r);

  final int q, r;

  @override
  int get hashCode => Object.hash(q, r);

  @override
  bool operator ==(Object other) =>
      identical(other, this) || other is T && q == other.q && r == other.r;

  @override
  int distanceTo(T other) => toCube().distanceTo(other.toCube());

  @override
  T move(D direction, int distance) {
    if (distance == 0) return this as T;
    final distanceShift = distance.isNegative ? 1 : -1;
    return shift(direction).move(direction, distance + distanceShift);
  }

  CubeCoordinate toCube();
}

class OddQOffsetCoordinate extends OffsetCoordinate<
    FlatToppedHexagonalDirection, OddQOffsetCoordinate> {
  const OddQOffsetCoordinate(super.q, super.r);

  OddQOffsetCoordinate.fromCube(CubeCoordinate coord)
      : super(coord.x, (coord.z + (coord.x - (coord.x % 2)) / 2).round());

  static final zero = OddQOffsetCoordinate(0, 0);

  @override
  OddQOffsetCoordinate shift(FlatToppedHexagonalDirection direction) {
    switch (direction) {
      case FlatToppedHexagonalDirection.top:
        return OddQOffsetCoordinate(q, r - 1);
      case FlatToppedHexagonalDirection.topRight:
        return OddQOffsetCoordinate(q + 1, r - (q.isEven ? 1 : 0));
      case FlatToppedHexagonalDirection.bottomRight:
        return OddQOffsetCoordinate(q + 1, r + (q.isEven ? 0 : 1));
      case FlatToppedHexagonalDirection.bottom:
        return OddQOffsetCoordinate(q, r + 1);
      case FlatToppedHexagonalDirection.bottomLeft:
        return OddQOffsetCoordinate(q - 1, r + (q.isEven ? 0 : 1));
      case FlatToppedHexagonalDirection.topLeft:
        return OddQOffsetCoordinate(q - 1, r - (q.isEven ? 1 : 0));
    }
  }

  @override
  CubeCoordinate toCube() =>
      CubeCoordinate.fromXZ(q, (r - (q - (q % 2)) / 2).round());
}

class EvenQOffsetCoordinate extends OffsetCoordinate<
    FlatToppedHexagonalDirection, EvenQOffsetCoordinate> {
  const EvenQOffsetCoordinate(super.q, super.r);

  EvenQOffsetCoordinate.fromCube(CubeCoordinate coord)
      : super(coord.x, (coord.z + (coord.x + (coord.x % 2)) / 2).round());

  static final zero = EvenQOffsetCoordinate(0, 0);

  @override
  EvenQOffsetCoordinate shift(FlatToppedHexagonalDirection direction) {
    switch (direction) {
      case FlatToppedHexagonalDirection.top:
        return EvenQOffsetCoordinate(q, r - 1);
      case FlatToppedHexagonalDirection.topRight:
        return EvenQOffsetCoordinate(q + 1, r - (q.isOdd ? 1 : 0));
      case FlatToppedHexagonalDirection.bottomRight:
        return EvenQOffsetCoordinate(q + 1, r + (q.isOdd ? 0 : 1));
      case FlatToppedHexagonalDirection.bottom:
        return EvenQOffsetCoordinate(q, r + 1);
      case FlatToppedHexagonalDirection.bottomLeft:
        return EvenQOffsetCoordinate(q - 1, r + (q.isOdd ? 0 : 1));
      case FlatToppedHexagonalDirection.topLeft:
        return EvenQOffsetCoordinate(q - 1, r - (q.isOdd ? 1 : 0));
    }
  }

  @override
  CubeCoordinate toCube() =>
      CubeCoordinate.fromXZ(q, (r - (q + (q % 2)) / 2).round());
}

class OddROffsetCoordinate extends OffsetCoordinate<
    PointyToppedHexagonalDirection, OddROffsetCoordinate> {
  const OddROffsetCoordinate(super.q, super.r);

  OddROffsetCoordinate.fromCube(CubeCoordinate coord)
      : super((coord.x + (coord.z - (coord.z % 2)) / 2).round(), coord.z);

  static final zero = OddROffsetCoordinate(0, 0);

  @override
  OddROffsetCoordinate shift(PointyToppedHexagonalDirection direction) {
    switch (direction) {
      case PointyToppedHexagonalDirection.topLeft:
        return OddROffsetCoordinate(q - (r.isEven ? 1 : 0), r - 1);
      case PointyToppedHexagonalDirection.topRight:
        return OddROffsetCoordinate(q + (r.isEven ? 0 : 1), r - 1);
      case PointyToppedHexagonalDirection.right:
        return OddROffsetCoordinate(q + 1, r);
      case PointyToppedHexagonalDirection.bottomRight:
        return OddROffsetCoordinate(q + (r.isEven ? 0 : 1), r + 1);
      case PointyToppedHexagonalDirection.bottomLeft:
        return OddROffsetCoordinate(q - (r.isEven ? 1 : 0), r + 1);
      case PointyToppedHexagonalDirection.left:
        return OddROffsetCoordinate(q - 1, r);
    }
  }

  @override
  CubeCoordinate toCube() =>
      CubeCoordinate.fromXZ((q - (r - (r % 2)) / 2).round(), r);
}

class EvenROffsetCoordinate extends OffsetCoordinate<
    PointyToppedHexagonalDirection, EvenROffsetCoordinate> {
  const EvenROffsetCoordinate(super.q, super.r);

  EvenROffsetCoordinate.fromCube(CubeCoordinate coord)
      : super((coord.x + (coord.z + (coord.z % 2)) / 2).round(), coord.z);

  static final zero = EvenROffsetCoordinate(0, 0);

  @override
  EvenROffsetCoordinate shift(PointyToppedHexagonalDirection direction) {
    switch (direction) {
      case PointyToppedHexagonalDirection.topLeft:
        return EvenROffsetCoordinate(q - (r.isOdd ? 1 : 0), r - 1);
      case PointyToppedHexagonalDirection.topRight:
        return EvenROffsetCoordinate(q + (r.isOdd ? 0 : 1), r - 1);
      case PointyToppedHexagonalDirection.right:
        return EvenROffsetCoordinate(q + 1, r);
      case PointyToppedHexagonalDirection.bottomRight:
        return EvenROffsetCoordinate(q + (r.isOdd ? 0 : 1), r + 1);
      case PointyToppedHexagonalDirection.bottomLeft:
        return EvenROffsetCoordinate(q - (r.isOdd ? 1 : 0), r + 1);
      case PointyToppedHexagonalDirection.left:
        return EvenROffsetCoordinate(q - 1, r);
    }
  }

  @override
  CubeCoordinate toCube() =>
      CubeCoordinate.fromXZ((q - (r + (r % 2)) / 2).round(), r);
}
