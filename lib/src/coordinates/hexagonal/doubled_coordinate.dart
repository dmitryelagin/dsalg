import 'dart:math';

import 'coordinate.dart';
import 'cube_coordinate.dart';
import 'direction.dart';

abstract class DoubledCoordinate<D extends Enum,
    T extends DoubledCoordinate<D, T>> extends HexagonalCoordinate<D, T> {
  const DoubledCoordinate(this.q, this.r)
      : assert((q + r) % 2 == 0); // ignore: use_is_even_rather_than_modulo

  final int q, r;

  @override
  int get hashCode => Object.hash(q, r);

  @override
  bool operator ==(Object other) =>
      identical(other, this) || other is T && q == other.q && r == other.r;

  @override
  T shift(D direction) => move(direction, 1);

  CubeCoordinate toCube();
}

class DoubleHeightDoubledCoordinate extends DoubledCoordinate<
    FlatToppedHexagonalDirection, DoubleHeightDoubledCoordinate> {
  const DoubleHeightDoubledCoordinate(super.q, super.r);

  DoubleHeightDoubledCoordinate.fromCube(CubeCoordinate coord)
      : super(coord.x, coord.z * 2 + coord.x);

  static const zero = DoubleHeightDoubledCoordinate(0, 0);

  @override
  int distanceTo(DoubledCoordinate other) {
    final dq = (q - other.q).abs(), dr = (r - other.r).abs();
    return dq + max(0, (dr - dq) ~/ 2);
  }

  @override
  DoubleHeightDoubledCoordinate move(
    FlatToppedHexagonalDirection direction,
    int distance,
  ) =>
      switch (direction) {
        FlatToppedHexagonalDirection.top =>
          DoubleHeightDoubledCoordinate(q, r - distance * 2),
        FlatToppedHexagonalDirection.topRight =>
          DoubleHeightDoubledCoordinate(q + distance, r - distance),
        FlatToppedHexagonalDirection.bottomRight =>
          DoubleHeightDoubledCoordinate(q + distance, r + distance),
        FlatToppedHexagonalDirection.bottom =>
          DoubleHeightDoubledCoordinate(q, r + distance * 2),
        FlatToppedHexagonalDirection.bottomLeft =>
          DoubleHeightDoubledCoordinate(q - distance, r + distance),
        FlatToppedHexagonalDirection.topLeft =>
          DoubleHeightDoubledCoordinate(q - distance, r - distance),
      };

  @override
  CubeCoordinate toCube() => CubeCoordinate.fromXZ(q, ((r - q) / 2).round());
}

class DoubleWidthDoubledCoordinate extends DoubledCoordinate<
    PointyToppedHexagonalDirection, DoubleWidthDoubledCoordinate> {
  const DoubleWidthDoubledCoordinate(super.q, super.r);

  DoubleWidthDoubledCoordinate.fromCube(CubeCoordinate coord)
      : super(coord.x * 2 + coord.z, coord.z);

  static const zero = DoubleWidthDoubledCoordinate(0, 0);

  @override
  int distanceTo(DoubledCoordinate other) {
    final dq = (q - other.q).abs(), dr = (r - other.r).abs();
    return dr + max(0, (dq - dr) ~/ 2);
  }

  @override
  DoubleWidthDoubledCoordinate move(
    PointyToppedHexagonalDirection direction,
    int distance,
  ) =>
      switch (direction) {
        PointyToppedHexagonalDirection.topLeft =>
          DoubleWidthDoubledCoordinate(q - distance, r - distance),
        PointyToppedHexagonalDirection.topRight =>
          DoubleWidthDoubledCoordinate(q + distance, r - distance),
        PointyToppedHexagonalDirection.right =>
          DoubleWidthDoubledCoordinate(q + distance * 2, r),
        PointyToppedHexagonalDirection.bottomRight =>
          DoubleWidthDoubledCoordinate(q + distance, r + distance),
        PointyToppedHexagonalDirection.bottomLeft =>
          DoubleWidthDoubledCoordinate(q - distance, r + distance),
        PointyToppedHexagonalDirection.left =>
          DoubleWidthDoubledCoordinate(q - distance * 2, r),
      };

  @override
  CubeCoordinate toCube() => CubeCoordinate.fromXZ(((q - r) / 2).round(), r);
}
