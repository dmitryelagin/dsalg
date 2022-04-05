import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

void main() {
  group('DoubleHeightDoubledCoordinate', () {
    test('should shift by direction', () {
      const start = DoubleHeightDoubledCoordinate.zero;
      expect(
        start.shift(FlatToppedHexagonalDirection.top),
        const DoubleHeightDoubledCoordinate(0, -2),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.topRight),
        const DoubleHeightDoubledCoordinate(1, -1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.bottomRight),
        const DoubleHeightDoubledCoordinate(1, 1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.bottom),
        const DoubleHeightDoubledCoordinate(0, 2),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.bottomLeft),
        const DoubleHeightDoubledCoordinate(-1, 1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.topLeft),
        const DoubleHeightDoubledCoordinate(-1, -1),
      );
      expect(
        start
            .shift(FlatToppedHexagonalDirection.topLeft)
            .shift(FlatToppedHexagonalDirection.bottom)
            .shift(FlatToppedHexagonalDirection.bottomRight),
        const DoubleHeightDoubledCoordinate(0, 2),
      );
    });

    test('should move by direction and distance', () {
      const start = DoubleHeightDoubledCoordinate.zero;
      expect(
        start.move(FlatToppedHexagonalDirection.top, 0),
        DoubleHeightDoubledCoordinate.zero,
      );
      expect(
        start.move(FlatToppedHexagonalDirection.top, 2),
        const DoubleHeightDoubledCoordinate(0, -4),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.topRight, 5),
        const DoubleHeightDoubledCoordinate(5, -5),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.bottomRight, 3),
        const DoubleHeightDoubledCoordinate(3, 3),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.bottom, 5),
        const DoubleHeightDoubledCoordinate(0, 10),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.bottomLeft, 2),
        const DoubleHeightDoubledCoordinate(-2, 2),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.topLeft, 3),
        const DoubleHeightDoubledCoordinate(-3, -3),
      );
      expect(
        start
            .move(FlatToppedHexagonalDirection.topLeft, 2)
            .move(FlatToppedHexagonalDirection.bottom, 3)
            .move(FlatToppedHexagonalDirection.bottomRight, 1),
        const DoubleHeightDoubledCoordinate(-1, 5),
      );
    });

    test('should return distance between coordinates', () {
      const start = DoubleHeightDoubledCoordinate.zero;
      expect(start.distanceTo(DoubleHeightDoubledCoordinate.zero), 0);
      expect(start.distanceTo(const DoubleHeightDoubledCoordinate(3, 1)), 3);
      expect(start.distanceTo(const DoubleHeightDoubledCoordinate(2, 6)), 4);
      expect(start.distanceTo(const DoubleHeightDoubledCoordinate(5, 5)), 5);
      expect(start.distanceTo(const DoubleHeightDoubledCoordinate(-3, -3)), 3);
    });

    test('should create doubled coordinate from cube coordinate', () {
      expect(
        DoubleHeightDoubledCoordinate.fromCube(CubeCoordinate.zero),
        DoubleHeightDoubledCoordinate.zero,
      );
      expect(
        DoubleHeightDoubledCoordinate.fromCube(const CubeCoordinate(2, -2, 0)),
        const DoubleHeightDoubledCoordinate(2, 2),
      );
      expect(
        DoubleHeightDoubledCoordinate.fromCube(const CubeCoordinate(1, 0, -1)),
        const DoubleHeightDoubledCoordinate(1, -1),
      );
      expect(
        DoubleHeightDoubledCoordinate.fromCube(const CubeCoordinate(4, -2, -2)),
        const DoubleHeightDoubledCoordinate(4, 0),
      );
    });

    test('should return corresponding cube coordinate', () {
      expect(
        DoubleHeightDoubledCoordinate.zero.toCube(),
        CubeCoordinate.zero,
      );
      expect(
        const DoubleHeightDoubledCoordinate(2, 2).toCube(),
        const CubeCoordinate(2, -2, 0),
      );
      expect(
        const DoubleHeightDoubledCoordinate(1, -1).toCube(),
        const CubeCoordinate(1, 0, -1),
      );
      expect(
        const DoubleHeightDoubledCoordinate(4, 0).toCube(),
        const CubeCoordinate(4, -2, -2),
      );
    });
  });

  group('DoubleWidthDoubledCoordinate', () {
    test('should shift by direction', () {
      const start = DoubleWidthDoubledCoordinate.zero;
      expect(
        start.shift(PointyToppedHexagonalDirection.topLeft),
        const DoubleWidthDoubledCoordinate(-1, -1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.topRight),
        const DoubleWidthDoubledCoordinate(1, -1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.right),
        const DoubleWidthDoubledCoordinate(2, 0),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.bottomRight),
        const DoubleWidthDoubledCoordinate(1, 1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.bottomLeft),
        const DoubleWidthDoubledCoordinate(-1, 1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.left),
        const DoubleWidthDoubledCoordinate(-2, 0),
      );
      expect(
        start
            .shift(PointyToppedHexagonalDirection.topLeft)
            .shift(PointyToppedHexagonalDirection.right)
            .shift(PointyToppedHexagonalDirection.bottomRight),
        const DoubleWidthDoubledCoordinate(2, 0),
      );
    });

    test('should move by direction and distance', () {
      const start = DoubleWidthDoubledCoordinate.zero;
      expect(
        start.move(PointyToppedHexagonalDirection.topLeft, 0),
        DoubleWidthDoubledCoordinate.zero,
      );
      expect(
        start.move(PointyToppedHexagonalDirection.topLeft, 2),
        const DoubleWidthDoubledCoordinate(-2, -2),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.topRight, 5),
        const DoubleWidthDoubledCoordinate(5, -5),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.right, 3),
        const DoubleWidthDoubledCoordinate(6, 0),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.bottomRight, 5),
        const DoubleWidthDoubledCoordinate(5, 5),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.bottomLeft, 2),
        const DoubleWidthDoubledCoordinate(-2, 2),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.left, 3),
        const DoubleWidthDoubledCoordinate(-6, 0),
      );
      expect(
        start
            .move(PointyToppedHexagonalDirection.topLeft, 2)
            .move(PointyToppedHexagonalDirection.right, 3)
            .move(PointyToppedHexagonalDirection.bottomRight, 1),
        const DoubleWidthDoubledCoordinate(5, -1),
      );
    });

    test('should return distance between coordinates', () {
      const start = DoubleWidthDoubledCoordinate.zero;
      expect(start.distanceTo(DoubleWidthDoubledCoordinate.zero), 0);
      expect(start.distanceTo(const DoubleWidthDoubledCoordinate(3, 1)), 2);
      expect(start.distanceTo(const DoubleWidthDoubledCoordinate(2, 6)), 6);
      expect(start.distanceTo(const DoubleWidthDoubledCoordinate(5, 5)), 5);
      expect(start.distanceTo(const DoubleWidthDoubledCoordinate(-3, -3)), 3);
    });

    test('should create doubled coordinate from cube coordinate', () {
      expect(
        DoubleWidthDoubledCoordinate.fromCube(CubeCoordinate.zero),
        DoubleWidthDoubledCoordinate.zero,
      );
      expect(
        DoubleWidthDoubledCoordinate.fromCube(const CubeCoordinate(0, -2, 2)),
        const DoubleWidthDoubledCoordinate(2, 2),
      );
      expect(
        DoubleWidthDoubledCoordinate.fromCube(const CubeCoordinate(1, 0, -1)),
        const DoubleWidthDoubledCoordinate(1, -1),
      );
      expect(
        DoubleWidthDoubledCoordinate.fromCube(const CubeCoordinate(2, -2, 0)),
        const DoubleWidthDoubledCoordinate(4, 0),
      );
    });

    test('should return corresponding cube coordinate', () {
      expect(
        DoubleWidthDoubledCoordinate.zero.toCube(),
        CubeCoordinate.zero,
      );
      expect(
        const DoubleWidthDoubledCoordinate(2, 2).toCube(),
        const CubeCoordinate(0, -2, 2),
      );
      expect(
        const DoubleWidthDoubledCoordinate(1, -1).toCube(),
        const CubeCoordinate(1, 0, -1),
      );
      expect(
        const DoubleWidthDoubledCoordinate(4, 0).toCube(),
        const CubeCoordinate(2, -2, 0),
      );
    });
  });
}
