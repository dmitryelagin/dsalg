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

  static const zero = OddQOffsetCoordinate(0, 0);

  @override
  OddQOffsetCoordinate shift(FlatToppedHexagonalDirection direction) =>
    switch (direction) {
      FlatToppedHexagonalDirection.top =>
        OddQOffsetCoordinate(q, r - 1),
      FlatToppedHexagonalDirection.topRight =>
        OddQOffsetCoordinate(q + 1, r - (q.isEven ? 1 : 0)),
      FlatToppedHexagonalDirection.bottomRight =>
        OddQOffsetCoordinate(q + 1, r + (q.isEven ? 0 : 1)),
      FlatToppedHexagonalDirection.bottom =>
        OddQOffsetCoordinate(q, r + 1),
      FlatToppedHexagonalDirection.bottomLeft =>
        OddQOffsetCoordinate(q - 1, r + (q.isEven ? 0 : 1)),
      FlatToppedHexagonalDirection.topLeft =>
        OddQOffsetCoordinate(q - 1, r - (q.isEven ? 1 : 0)),
    };

  @override
  CubeCoordinate toCube() =>
      CubeCoordinate.fromXZ(q, (r - (q - (q % 2)) / 2).round());
}

class EvenQOffsetCoordinate extends OffsetCoordinate<
    FlatToppedHexagonalDirection, EvenQOffsetCoordinate> {
  const EvenQOffsetCoordinate(super.q, super.r);

  EvenQOffsetCoordinate.fromCube(CubeCoordinate coord)
      : super(coord.x, (coord.z + (coord.x + (coord.x % 2)) / 2).round());

  static const zero = EvenQOffsetCoordinate(0, 0);

  @override
  EvenQOffsetCoordinate shift(FlatToppedHexagonalDirection direction) =>
    switch (direction) {
      FlatToppedHexagonalDirection.top =>
        EvenQOffsetCoordinate(q, r - 1),
      FlatToppedHexagonalDirection.topRight =>
        EvenQOffsetCoordinate(q + 1, r - (q.isOdd ? 1 : 0)),
      FlatToppedHexagonalDirection.bottomRight =>
        EvenQOffsetCoordinate(q + 1, r + (q.isOdd ? 0 : 1)),
      FlatToppedHexagonalDirection.bottom =>
        EvenQOffsetCoordinate(q, r + 1),
      FlatToppedHexagonalDirection.bottomLeft =>
        EvenQOffsetCoordinate(q - 1, r + (q.isOdd ? 0 : 1)),
      FlatToppedHexagonalDirection.topLeft =>
        EvenQOffsetCoordinate(q - 1, r - (q.isOdd ? 1 : 0)),
    };

  @override
  CubeCoordinate toCube() =>
      CubeCoordinate.fromXZ(q, (r - (q + (q % 2)) / 2).round());
}

class OddROffsetCoordinate extends OffsetCoordinate<
    PointyToppedHexagonalDirection, OddROffsetCoordinate> {
  const OddROffsetCoordinate(super.q, super.r);

  OddROffsetCoordinate.fromCube(CubeCoordinate coord)
      : super((coord.x + (coord.z - (coord.z % 2)) / 2).round(), coord.z);

  static const zero = OddROffsetCoordinate(0, 0);

  @override
  OddROffsetCoordinate shift(PointyToppedHexagonalDirection direction) =>
    switch (direction) {
      PointyToppedHexagonalDirection.topLeft =>
        OddROffsetCoordinate(q - (r.isEven ? 1 : 0), r - 1),
      PointyToppedHexagonalDirection.topRight =>
        OddROffsetCoordinate(q + (r.isEven ? 0 : 1), r - 1),
      PointyToppedHexagonalDirection.right =>
        OddROffsetCoordinate(q + 1, r),
      PointyToppedHexagonalDirection.bottomRight =>
        OddROffsetCoordinate(q + (r.isEven ? 0 : 1), r + 1),
      PointyToppedHexagonalDirection.bottomLeft =>
        OddROffsetCoordinate(q - (r.isEven ? 1 : 0), r + 1),
      PointyToppedHexagonalDirection.left =>
        OddROffsetCoordinate(q - 1, r),
    };

  @override
  CubeCoordinate toCube() =>
      CubeCoordinate.fromXZ((q - (r - (r % 2)) / 2).round(), r);
}

class EvenROffsetCoordinate extends OffsetCoordinate<
    PointyToppedHexagonalDirection, EvenROffsetCoordinate> {
  const EvenROffsetCoordinate(super.q, super.r);

  EvenROffsetCoordinate.fromCube(CubeCoordinate coord)
      : super((coord.x + (coord.z + (coord.z % 2)) / 2).round(), coord.z);

  static const zero = EvenROffsetCoordinate(0, 0);

  @override
  EvenROffsetCoordinate shift(PointyToppedHexagonalDirection direction) =>
    switch (direction) {
      PointyToppedHexagonalDirection.topLeft =>
        EvenROffsetCoordinate(q - (r.isOdd ? 1 : 0), r - 1),
      PointyToppedHexagonalDirection.topRight =>
        EvenROffsetCoordinate(q + (r.isOdd ? 0 : 1), r - 1),
      PointyToppedHexagonalDirection.right =>
        EvenROffsetCoordinate(q + 1, r),
      PointyToppedHexagonalDirection.bottomRight =>
        EvenROffsetCoordinate(q + (r.isOdd ? 0 : 1), r + 1),
      PointyToppedHexagonalDirection.bottomLeft =>
        EvenROffsetCoordinate(q - (r.isOdd ? 1 : 0), r + 1),
      PointyToppedHexagonalDirection.left =>
        EvenROffsetCoordinate(q - 1, r),
    };

  @override
  CubeCoordinate toCube() =>
      CubeCoordinate.fromXZ((q - (r + (r % 2)) / 2).round(), r);
}
