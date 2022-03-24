import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

void main() {
  group('DoubleHeightDoubledCoordinate', () {
    test('should shift by direction', () {
      final start = DoubleHeightDoubledCoordinate.zero;
      expect(
        start.shift(FlatToppedHexagonalDirection.top),
        DoubleHeightDoubledCoordinate(0, -2),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.topRight),
        DoubleHeightDoubledCoordinate(1, -1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.bottomRight),
        DoubleHeightDoubledCoordinate(1, 1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.bottom),
        DoubleHeightDoubledCoordinate(0, 2),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.bottomLeft),
        DoubleHeightDoubledCoordinate(-1, 1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.topLeft),
        DoubleHeightDoubledCoordinate(-1, -1),
      );
      expect(
        start
            .shift(FlatToppedHexagonalDirection.topLeft)
            .shift(FlatToppedHexagonalDirection.bottom)
            .shift(FlatToppedHexagonalDirection.bottomRight),
        DoubleHeightDoubledCoordinate(0, 2),
      );
    });

    test('should move by direction and distance', () {
      final start = DoubleHeightDoubledCoordinate.zero;
      expect(
        start.move(FlatToppedHexagonalDirection.top, 0),
        DoubleHeightDoubledCoordinate.zero,
      );
      expect(
        start.move(FlatToppedHexagonalDirection.top, 2),
        DoubleHeightDoubledCoordinate(0, -4),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.topRight, 5),
        DoubleHeightDoubledCoordinate(5, -5),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.bottomRight, 3),
        DoubleHeightDoubledCoordinate(3, 3),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.bottom, 5),
        DoubleHeightDoubledCoordinate(0, 10),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.bottomLeft, 2),
        DoubleHeightDoubledCoordinate(-2, 2),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.topLeft, 3),
        DoubleHeightDoubledCoordinate(-3, -3),
      );
      expect(
        start
            .move(FlatToppedHexagonalDirection.topLeft, 2)
            .move(FlatToppedHexagonalDirection.bottom, 3)
            .move(FlatToppedHexagonalDirection.bottomRight, 1),
        DoubleHeightDoubledCoordinate(-1, 5),
      );
    });

    test('should return distance between coordinates', () {
      final start = DoubleHeightDoubledCoordinate.zero;
      expect(start.distanceTo(DoubleHeightDoubledCoordinate.zero), 0);
      expect(start.distanceTo(DoubleHeightDoubledCoordinate(3, 1)), 3);
      expect(start.distanceTo(DoubleHeightDoubledCoordinate(2, 6)), 4);
      expect(start.distanceTo(DoubleHeightDoubledCoordinate(5, 5)), 5);
      expect(start.distanceTo(DoubleHeightDoubledCoordinate(-3, -3)), 3);
    });

    test('should create doubled coordinate from cube coordinate', () {
      expect(
        DoubleHeightDoubledCoordinate.fromCube(CubeCoordinate.zero),
        DoubleHeightDoubledCoordinate.zero,
      );
      expect(
        DoubleHeightDoubledCoordinate.fromCube(const CubeCoordinate(2, -2, 0)),
        DoubleHeightDoubledCoordinate(2, 2),
      );
      expect(
        DoubleHeightDoubledCoordinate.fromCube(const CubeCoordinate(1, 0, -1)),
        DoubleHeightDoubledCoordinate(1, -1),
      );
      expect(
        DoubleHeightDoubledCoordinate.fromCube(const CubeCoordinate(4, -2, -2)),
        DoubleHeightDoubledCoordinate(4, 0),
      );
    });

    test('should return corresponding cube coordinate', () {
      expect(
        DoubleHeightDoubledCoordinate.zero.toCube(),
        CubeCoordinate.zero,
      );
      expect(
        DoubleHeightDoubledCoordinate(2, 2).toCube(),
        const CubeCoordinate(2, -2, 0),
      );
      expect(
        DoubleHeightDoubledCoordinate(1, -1).toCube(),
        const CubeCoordinate(1, 0, -1),
      );
      expect(
        DoubleHeightDoubledCoordinate(4, 0).toCube(),
        const CubeCoordinate(4, -2, -2),
      );
    });
  });

  group('DoubleWidthDoubledCoordinate', () {
    test('should shift by direction', () {
      final start = DoubleWidthDoubledCoordinate.zero;
      expect(
        start.shift(PointyToppedHexagonalDirection.topLeft),
        DoubleWidthDoubledCoordinate(-1, -1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.topRight),
        DoubleWidthDoubledCoordinate(1, -1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.right),
        DoubleWidthDoubledCoordinate(2, 0),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.bottomRight),
        DoubleWidthDoubledCoordinate(1, 1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.bottomLeft),
        DoubleWidthDoubledCoordinate(-1, 1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.left),
        DoubleWidthDoubledCoordinate(-2, 0),
      );
      expect(
        start
            .shift(PointyToppedHexagonalDirection.topLeft)
            .shift(PointyToppedHexagonalDirection.right)
            .shift(PointyToppedHexagonalDirection.bottomRight),
        DoubleWidthDoubledCoordinate(2, 0),
      );
    });

    test('should move by direction and distance', () {
      final start = DoubleWidthDoubledCoordinate.zero;
      expect(
        start.move(PointyToppedHexagonalDirection.topLeft, 0),
        DoubleWidthDoubledCoordinate.zero,
      );
      expect(
        start.move(PointyToppedHexagonalDirection.topLeft, 2),
        DoubleWidthDoubledCoordinate(-2, -2),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.topRight, 5),
        DoubleWidthDoubledCoordinate(5, -5),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.right, 3),
        DoubleWidthDoubledCoordinate(6, 0),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.bottomRight, 5),
        DoubleWidthDoubledCoordinate(5, 5),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.bottomLeft, 2),
        DoubleWidthDoubledCoordinate(-2, 2),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.left, 3),
        DoubleWidthDoubledCoordinate(-6, 0),
      );
      expect(
        start
            .move(PointyToppedHexagonalDirection.topLeft, 2)
            .move(PointyToppedHexagonalDirection.right, 3)
            .move(PointyToppedHexagonalDirection.bottomRight, 1),
        DoubleWidthDoubledCoordinate(5, -1),
      );
    });

    test('should return distance between coordinates', () {
      final start = DoubleWidthDoubledCoordinate.zero;
      expect(start.distanceTo(DoubleWidthDoubledCoordinate.zero), 0);
      expect(start.distanceTo(DoubleWidthDoubledCoordinate(3, 1)), 2);
      expect(start.distanceTo(DoubleWidthDoubledCoordinate(2, 6)), 6);
      expect(start.distanceTo(DoubleWidthDoubledCoordinate(5, 5)), 5);
      expect(start.distanceTo(DoubleWidthDoubledCoordinate(-3, -3)), 3);
    });

    test('should create doubled coordinate from cube coordinate', () {
      expect(
        DoubleWidthDoubledCoordinate.fromCube(CubeCoordinate.zero),
        DoubleWidthDoubledCoordinate.zero,
      );
      expect(
        DoubleWidthDoubledCoordinate.fromCube(const CubeCoordinate(0, -2, 2)),
        DoubleWidthDoubledCoordinate(2, 2),
      );
      expect(
        DoubleWidthDoubledCoordinate.fromCube(const CubeCoordinate(1, 0, -1)),
        DoubleWidthDoubledCoordinate(1, -1),
      );
      expect(
        DoubleWidthDoubledCoordinate.fromCube(const CubeCoordinate(2, -2, 0)),
        DoubleWidthDoubledCoordinate(4, 0),
      );
    });

    test('should return corresponding cube coordinate', () {
      expect(
        DoubleWidthDoubledCoordinate.zero.toCube(),
        CubeCoordinate.zero,
      );
      expect(
        DoubleWidthDoubledCoordinate(2, 2).toCube(),
        const CubeCoordinate(0, -2, 2),
      );
      expect(
        DoubleWidthDoubledCoordinate(1, -1).toCube(),
        const CubeCoordinate(1, 0, -1),
      );
      expect(
        DoubleWidthDoubledCoordinate(4, 0).toCube(),
        const CubeCoordinate(2, -2, 0),
      );
    });
  });
}
