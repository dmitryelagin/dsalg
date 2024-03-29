import 'dart:math';

import '../../maths/interpolation/interpolate.dart';
import '../../utils/iterable_utils.dart';
import 'coordinate.dart';
import 'cube_coordinate.dart';
import 'direction.dart';

class AxialCoordinate
    extends HexagonalCoordinate<HexagonalDirection, AxialCoordinate>
    with HexagonalCoordinateOrigin<AxialCoordinate> {
  const AxialCoordinate(this.q, this.r);

  AxialCoordinate.fromNum(num q, num r)
      : q = q.round(),
        r = r.round();

  factory AxialCoordinate.fromCube(CubeCoordinate coord) =>
      AxialCoordinate(coord.x, coord.z);

  static const zero = AxialCoordinate(0, 0);

  final int q, r;

  @override
  int get hashCode => Object.hash(q, r);

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      other is AxialCoordinate && q == other.q && r == other.r;

  @override
  int distanceTo(AxialCoordinate other) => [
        (q - other.q).abs(),
        (r - other.r).abs(),
        (q - other.q + r - other.r).abs(),
      ].maxValue;

  @override
  AxialCoordinate shift(HexagonalDirection direction) => move(direction, 1);

  @override
  AxialCoordinate move(HexagonalDirection direction, int distance) =>
      switch (direction) {
        HexagonalDirection.flatToppedTop ||
        HexagonalDirection.pointyToppedTopLeft =>
          AxialCoordinate(q, r - distance),
        HexagonalDirection.flatToppedTopRight ||
        HexagonalDirection.pointyToppedTopRight =>
          AxialCoordinate(q + distance, r - distance),
        HexagonalDirection.flatToppedBottomRight ||
        HexagonalDirection.pointyToppedRight =>
          AxialCoordinate(q + distance, r),
        HexagonalDirection.flatToppedBottom ||
        HexagonalDirection.pointyToppedBottomRight =>
          AxialCoordinate(q, r + distance),
        HexagonalDirection.flatToppedBottomLeft ||
        HexagonalDirection.pointyToppedBottomLeft =>
          AxialCoordinate(q - distance, r + distance),
        HexagonalDirection.flatToppedTopLeft ||
        HexagonalDirection.pointyToppedLeft =>
          AxialCoordinate(q - distance, r),
      };

  @override
  Iterable<AxialCoordinate> getLineTo(AxialCoordinate other) sync* {
    const epsilonQ = 1e-6, epsilonR = -3e-6;
    final distance = distanceTo(other);
    yield this;
    for (var i = 1; i <= distance; i += 1) {
      final ratio = i / distance;
      yield AxialCoordinate.fromNum(
        interpLinear(q + epsilonQ, other.q + epsilonQ, ratio),
        interpLinear(r + epsilonR, other.r + epsilonR, ratio),
      );
    }
  }

  @override
  Iterable<AxialCoordinate> getAllInRange(int distance) sync* {
    final radius = distance.abs();
    for (var dq = -radius; dq <= radius; dq += 1) {
      for (var dr = max(-radius, -radius - dq);
          dr <= min(radius, radius - dq);
          dr += 1) {
        yield dq == 0 && dr == 0 ? this : AxialCoordinate(q + dq, r + dr);
      }
    }
  }
}
