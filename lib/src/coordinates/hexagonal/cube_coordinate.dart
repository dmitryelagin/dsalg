import 'dart:math';

import '../../maths/lerp.dart';
import '../../utils/iterable_utils.dart';
import 'axial_coordinate.dart';
import 'coordinate.dart';
import 'direction.dart';

class CubeCoordinate
    extends HexagonalCoordinate<HexagonalDirection, CubeCoordinate>
    with
        RotatableHexagonalCoordinate<HexagonalDirection, CubeCoordinate>,
        HexagonalCoordinateOrigin<CubeCoordinate> {
  const CubeCoordinate(this.x, this.y, this.z) : assert(x + y + z == 0);

  const CubeCoordinate.fromXZ(this.x, this.z) : y = -(x + z);

  factory CubeCoordinate.fromNumXZ(num x, num z) =>
      CubeCoordinate.fromXZ(x.round(), z.round());

  factory CubeCoordinate.fromAxial(AxialCoordinate coord) =>
      CubeCoordinate.fromXZ(coord.q, coord.r);

  static const zero = CubeCoordinate(0, 0, 0);

  final int x, y, z;

  @override
  int get hashCode => Object.hash(x, y, z);

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      other is CubeCoordinate && x == other.x && y == other.y && z == other.z;

  CubeCoordinate operator +(CubeCoordinate other) =>
      CubeCoordinate(x + other.x, y + other.y, z + other.z);

  CubeCoordinate operator -(CubeCoordinate other) =>
      CubeCoordinate(x - other.x, y - other.y, z - other.z);

  @override
  int distanceTo(CubeCoordinate other) =>
      [(x - other.x).abs(), (y - other.y).abs(), (z - other.z).abs()].maxValue;

  @override
  CubeCoordinate shift(HexagonalDirection direction) => move(direction, 1);

  @override
  CubeCoordinate move(HexagonalDirection direction, int distance) {
    switch (direction) {
      case HexagonalDirection.flatToppedTop:
      case HexagonalDirection.pointyToppedTopLeft:
        return CubeCoordinate(x, y + distance, z - distance);
      case HexagonalDirection.flatToppedTopRight:
      case HexagonalDirection.pointyToppedTopRight:
        return CubeCoordinate(x + distance, y, z - distance);
      case HexagonalDirection.flatToppedBottomRight:
      case HexagonalDirection.pointyToppedRight:
        return CubeCoordinate(x + distance, y - distance, z);
      case HexagonalDirection.flatToppedBottom:
      case HexagonalDirection.pointyToppedBottomRight:
        return CubeCoordinate(x, y - distance, z + distance);
      case HexagonalDirection.flatToppedBottomLeft:
      case HexagonalDirection.pointyToppedBottomLeft:
        return CubeCoordinate(x - distance, y, z + distance);
      case HexagonalDirection.flatToppedTopLeft:
      case HexagonalDirection.pointyToppedLeft:
        return CubeCoordinate(x - distance, y + distance, z);
    }
  }

  @override
  CubeCoordinate rotate(int steps) {
    final step = steps % FlatToppedHexagonalDirection.values.length;
    if (step == 1) return CubeCoordinate(-z, -x, -y);
    if (step == 2) return CubeCoordinate(y, z, x);
    if (step == 3) return CubeCoordinate(-x, -y, -z);
    if (step == 4) return CubeCoordinate(z, x, y);
    if (step == 5) return CubeCoordinate(-y, -z, -x);
    return this;
  }

  @override
  CubeCoordinate rotateAround(CubeCoordinate other, int steps) =>
      (this - other).rotate(steps) + other;

  CubeCoordinate reflect([CubeCoordinate other = zero]) =>
      CubeCoordinate(other.x * 2 - x, other.y * 2 - y, other.z * 2 - z);

  CubeCoordinate reflectX([CubeCoordinate other = zero]) =>
      CubeCoordinate(x, z - other.z + other.y, y - other.y + other.z);

  CubeCoordinate reflectY([CubeCoordinate other = zero]) =>
      CubeCoordinate(z - other.z + other.x, y, x - other.x + other.z);

  CubeCoordinate reflectZ([CubeCoordinate other = zero]) =>
      CubeCoordinate(y - other.y + other.x, x - other.x + other.y, z);

  @override
  Iterable<CubeCoordinate> getLineTo(CubeCoordinate other) sync* {
    const epsilonX = 1e-6, epsilonZ = -3e-6;
    final distance = distanceTo(other);
    yield this;
    for (var i = 1; i <= distance; i += 1) {
      yield CubeCoordinate.fromNumXZ(
        lerp(x + epsilonX, other.x + epsilonX, i / distance),
        lerp(z + epsilonZ, other.z + epsilonZ, i / distance),
      );
    }
  }

  @override
  Iterable<CubeCoordinate> getAllInRange(int distance) sync* {
    final radius = distance.abs();
    for (var dx = -radius; dx <= radius; dx += 1) {
      for (var dz = max(-radius, -(radius + dx));
          dz <= min(radius, radius - dx);
          dz += 1) {
        yield dx == 0 && dz == 0 ? this : CubeCoordinate.fromXZ(x + dx, z + dz);
      }
    }
  }
}
