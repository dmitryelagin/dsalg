import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

void main() {
  group('OddQOffsetCoordinate', () {
    test('should shift by direction', () {
      const start = OddQOffsetCoordinate.zero;
      expect(
        start.shift(FlatToppedHexagonalDirection.top),
        const OddQOffsetCoordinate(0, -1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.topRight),
        const OddQOffsetCoordinate(1, -1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.bottomRight),
        const OddQOffsetCoordinate(1, 0),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.bottom),
        const OddQOffsetCoordinate(0, 1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.bottomLeft),
        const OddQOffsetCoordinate(-1, 0),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.topLeft),
        const OddQOffsetCoordinate(-1, -1),
      );
      expect(
        start
            .shift(FlatToppedHexagonalDirection.topLeft)
            .shift(FlatToppedHexagonalDirection.bottom)
            .shift(FlatToppedHexagonalDirection.bottomRight),
        const OddQOffsetCoordinate(0, 1),
      );
    });

    test('should move by direction and distance', () {
      const start = OddQOffsetCoordinate.zero;
      expect(
        start.move(FlatToppedHexagonalDirection.top, 0),
        OddQOffsetCoordinate.zero,
      );
      expect(
        start.move(FlatToppedHexagonalDirection.top, 2),
        const OddQOffsetCoordinate(0, -2),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.topRight, 5),
        const OddQOffsetCoordinate(5, -3),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.bottomRight, 3),
        const OddQOffsetCoordinate(3, 1),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.bottom, 5),
        const OddQOffsetCoordinate(0, 5),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.bottomLeft, 2),
        const OddQOffsetCoordinate(-2, 1),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.topLeft, 3),
        const OddQOffsetCoordinate(-3, -2),
      );
      expect(
        start
            .move(FlatToppedHexagonalDirection.topLeft, 2)
            .move(FlatToppedHexagonalDirection.bottom, 3)
            .move(FlatToppedHexagonalDirection.bottomRight, 1),
        const OddQOffsetCoordinate(-1, 2),
      );
    });

    test('should return distance between coordinates', () {
      const start = OddQOffsetCoordinate.zero;
      expect(start.distanceTo(OddQOffsetCoordinate.zero), 0);
      expect(start.distanceTo(const OddQOffsetCoordinate(3, 2)), 4);
      expect(start.distanceTo(const OddQOffsetCoordinate(1, 6)), 7);
      expect(start.distanceTo(const OddQOffsetCoordinate(5, 5)), 8);
      expect(start.distanceTo(const OddQOffsetCoordinate(-3, -2)), 3);
    });

    test('should create offset coordinate from cube coordinate', () {
      expect(
        OddQOffsetCoordinate.fromCube(CubeCoordinate.zero),
        OddQOffsetCoordinate.zero,
      );
      expect(
        OddQOffsetCoordinate.fromCube(const CubeCoordinate(2, -3, 1)),
        const OddQOffsetCoordinate(2, 2),
      );
      expect(
        OddQOffsetCoordinate.fromCube(const CubeCoordinate(2, 0, -2)),
        const OddQOffsetCoordinate(2, -1),
      );
      expect(
        OddQOffsetCoordinate.fromCube(const CubeCoordinate(1, -1, 0)),
        const OddQOffsetCoordinate(1, 0),
      );
    });

    test('should return corresponding cube coordinate', () {
      expect(
        OddQOffsetCoordinate.zero.toCube(),
        CubeCoordinate.zero,
      );
      expect(
        const OddQOffsetCoordinate(2, 2).toCube(),
        const CubeCoordinate(2, -3, 1),
      );
      expect(
        const OddQOffsetCoordinate(2, -1).toCube(),
        const CubeCoordinate(2, 0, -2),
      );
      expect(
        const OddQOffsetCoordinate(1, 0).toCube(),
        const CubeCoordinate(1, -1, 0),
      );
    });
  });

  group('EvenQOffsetCoordinate', () {
    test('should shift by direction', () {
      const start = EvenQOffsetCoordinate.zero;
      expect(
        start.shift(FlatToppedHexagonalDirection.top),
        const EvenQOffsetCoordinate(0, -1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.topRight),
        const EvenQOffsetCoordinate(1, 0),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.bottomRight),
        const EvenQOffsetCoordinate(1, 1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.bottom),
        const EvenQOffsetCoordinate(0, 1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.bottomLeft),
        const EvenQOffsetCoordinate(-1, 1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.topLeft),
        const EvenQOffsetCoordinate(-1, 0),
      );
      expect(
        start
            .shift(FlatToppedHexagonalDirection.topLeft)
            .shift(FlatToppedHexagonalDirection.bottom)
            .shift(FlatToppedHexagonalDirection.bottomRight),
        const EvenQOffsetCoordinate(0, 1),
      );
    });

    test('should move by direction and distance', () {
      const start = EvenQOffsetCoordinate.zero;
      expect(
        start.move(FlatToppedHexagonalDirection.top, 0),
        EvenQOffsetCoordinate.zero,
      );
      expect(
        start.move(FlatToppedHexagonalDirection.top, 2),
        const EvenQOffsetCoordinate(0, -2),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.topRight, 5),
        const EvenQOffsetCoordinate(5, -2),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.bottomRight, 3),
        const EvenQOffsetCoordinate(3, 2),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.bottom, 5),
        const EvenQOffsetCoordinate(0, 5),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.bottomLeft, 2),
        const EvenQOffsetCoordinate(-2, 1),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.topLeft, 3),
        const EvenQOffsetCoordinate(-3, -1),
      );
      expect(
        start
            .move(FlatToppedHexagonalDirection.topLeft, 2)
            .move(FlatToppedHexagonalDirection.bottom, 3)
            .move(FlatToppedHexagonalDirection.bottomRight, 1),
        const EvenQOffsetCoordinate(-1, 3),
      );
    });

    test('should return distance between coordinates', () {
      const start = EvenQOffsetCoordinate.zero;
      expect(start.distanceTo(EvenQOffsetCoordinate.zero), 0);
      expect(start.distanceTo(const EvenQOffsetCoordinate(3, 2)), 3);
      expect(start.distanceTo(const EvenQOffsetCoordinate(1, 6)), 6);
      expect(start.distanceTo(const EvenQOffsetCoordinate(5, 5)), 7);
      expect(start.distanceTo(const EvenQOffsetCoordinate(-3, -2)), 4);
    });

    test('should create offset coordinate from cube coordinate', () {
      expect(
        EvenQOffsetCoordinate.fromCube(CubeCoordinate.zero),
        EvenQOffsetCoordinate.zero,
      );
      expect(
        EvenQOffsetCoordinate.fromCube(const CubeCoordinate(2, -3, 1)),
        const EvenQOffsetCoordinate(2, 2),
      );
      expect(
        EvenQOffsetCoordinate.fromCube(const CubeCoordinate(2, 0, -2)),
        const EvenQOffsetCoordinate(2, -1),
      );
      expect(
        EvenQOffsetCoordinate.fromCube(const CubeCoordinate(1, 0, -1)),
        const EvenQOffsetCoordinate(1, 0),
      );
    });

    test('should return corresponding cube coordinate', () {
      expect(
        EvenQOffsetCoordinate.zero.toCube(),
        CubeCoordinate.zero,
      );
      expect(
        const EvenQOffsetCoordinate(2, 2).toCube(),
        const CubeCoordinate(2, -3, 1),
      );
      expect(
        const EvenQOffsetCoordinate(2, -1).toCube(),
        const CubeCoordinate(2, 0, -2),
      );
      expect(
        const EvenQOffsetCoordinate(1, 0).toCube(),
        const CubeCoordinate(1, 0, -1),
      );
    });
  });

  group('OddROffsetCoordinate', () {
    test('should shift by direction', () {
      const start = OddROffsetCoordinate.zero;
      expect(
        start.shift(PointyToppedHexagonalDirection.topLeft),
        const OddROffsetCoordinate(-1, -1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.topRight),
        const OddROffsetCoordinate(0, -1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.right),
        const OddROffsetCoordinate(1, 0),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.bottomRight),
        const OddROffsetCoordinate(0, 1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.bottomLeft),
        const OddROffsetCoordinate(-1, 1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.left),
        const OddROffsetCoordinate(-1, 0),
      );
      expect(
        start
            .shift(PointyToppedHexagonalDirection.topLeft)
            .shift(PointyToppedHexagonalDirection.right)
            .shift(PointyToppedHexagonalDirection.bottomRight),
        const OddROffsetCoordinate(1, 0),
      );
    });

    test('should move by direction and distance', () {
      const start = OddROffsetCoordinate.zero;
      expect(
        start.move(PointyToppedHexagonalDirection.topLeft, 0),
        OddROffsetCoordinate.zero,
      );
      expect(
        start.move(PointyToppedHexagonalDirection.topLeft, 2),
        const OddROffsetCoordinate(-1, -2),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.topRight, 5),
        const OddROffsetCoordinate(2, -5),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.right, 3),
        const OddROffsetCoordinate(3, 0),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.bottomRight, 5),
        const OddROffsetCoordinate(2, 5),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.bottomLeft, 2),
        const OddROffsetCoordinate(-1, 2),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.left, 3),
        const OddROffsetCoordinate(-3, 0),
      );
      expect(
        start
            .move(PointyToppedHexagonalDirection.topLeft, 2)
            .move(PointyToppedHexagonalDirection.right, 3)
            .move(PointyToppedHexagonalDirection.bottomRight, 1),
        const OddROffsetCoordinate(2, -1),
      );
    });

    test('should return distance between coordinates', () {
      const start = OddROffsetCoordinate.zero;
      expect(start.distanceTo(OddROffsetCoordinate.zero), 0);
      expect(start.distanceTo(const OddROffsetCoordinate(3, 2)), 4);
      expect(start.distanceTo(const OddROffsetCoordinate(1, 6)), 6);
      expect(start.distanceTo(const OddROffsetCoordinate(5, 5)), 8);
      expect(start.distanceTo(const OddROffsetCoordinate(-3, -2)), 4);
    });

    test('should create offset coordinate from cube coordinate', () {
      expect(
        OddROffsetCoordinate.fromCube(CubeCoordinate.zero),
        OddROffsetCoordinate.zero,
      );
      expect(
        OddROffsetCoordinate.fromCube(const CubeCoordinate(1, -3, 2)),
        const OddROffsetCoordinate(2, 2),
      );
      expect(
        OddROffsetCoordinate.fromCube(const CubeCoordinate(3, -2, -1)),
        const OddROffsetCoordinate(2, -1),
      );
      expect(
        OddROffsetCoordinate.fromCube(const CubeCoordinate(1, -1, 0)),
        const OddROffsetCoordinate(1, 0),
      );
    });

    test('should return corresponding cube coordinate', () {
      expect(
        OddROffsetCoordinate.zero.toCube(),
        CubeCoordinate.zero,
      );
      expect(
        const OddROffsetCoordinate(2, 2).toCube(),
        const CubeCoordinate(1, -3, 2),
      );
      expect(
        const OddROffsetCoordinate(2, -1).toCube(),
        const CubeCoordinate(3, -2, -1),
      );
      expect(
        const OddROffsetCoordinate(1, 0).toCube(),
        const CubeCoordinate(1, -1, 0),
      );
    });
  });

  group('EvenROffsetCoordinate', () {
    test('should shift by direction', () {
      const start = EvenROffsetCoordinate.zero;
      expect(
        start.shift(PointyToppedHexagonalDirection.topLeft),
        const EvenROffsetCoordinate(0, -1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.topRight),
        const EvenROffsetCoordinate(1, -1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.right),
        const EvenROffsetCoordinate(1, 0),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.bottomRight),
        const EvenROffsetCoordinate(1, 1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.bottomLeft),
        const EvenROffsetCoordinate(0, 1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.left),
        const EvenROffsetCoordinate(-1, 0),
      );
      expect(
        start
            .shift(PointyToppedHexagonalDirection.topLeft)
            .shift(PointyToppedHexagonalDirection.right)
            .shift(PointyToppedHexagonalDirection.bottomRight),
        const EvenROffsetCoordinate(1, 0),
      );
    });

    test('should move by direction and distance', () {
      const start = EvenROffsetCoordinate.zero;
      expect(
        start.move(PointyToppedHexagonalDirection.topLeft, 0),
        EvenROffsetCoordinate.zero,
      );
      expect(
        start.move(PointyToppedHexagonalDirection.topLeft, 2),
        const EvenROffsetCoordinate(-1, -2),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.topRight, 5),
        const EvenROffsetCoordinate(3, -5),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.right, 3),
        const EvenROffsetCoordinate(3, 0),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.bottomRight, 5),
        const EvenROffsetCoordinate(3, 5),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.bottomLeft, 2),
        const EvenROffsetCoordinate(-1, 2),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.left, 3),
        const EvenROffsetCoordinate(-3, 0),
      );
      expect(
        start
            .move(PointyToppedHexagonalDirection.topLeft, 2)
            .move(PointyToppedHexagonalDirection.right, 3)
            .move(PointyToppedHexagonalDirection.bottomRight, 1),
        const EvenROffsetCoordinate(3, -1),
      );
    });

    test('should return distance between coordinates', () {
      const start = EvenROffsetCoordinate.zero;
      expect(start.distanceTo(EvenROffsetCoordinate.zero), 0);
      expect(start.distanceTo(const EvenROffsetCoordinate(3, 2)), 4);
      expect(start.distanceTo(const EvenROffsetCoordinate(1, 6)), 6);
      expect(start.distanceTo(const EvenROffsetCoordinate(5, 5)), 7);
      expect(start.distanceTo(const EvenROffsetCoordinate(-3, -2)), 4);
    });

    test('should create offset coordinate from cube coordinate', () {
      expect(
        EvenROffsetCoordinate.fromCube(CubeCoordinate.zero),
        EvenROffsetCoordinate.zero,
      );
      expect(
        EvenROffsetCoordinate.fromCube(const CubeCoordinate(1, -3, 2)),
        const EvenROffsetCoordinate(2, 2),
      );
      expect(
        EvenROffsetCoordinate.fromCube(const CubeCoordinate(2, -1, -1)),
        const EvenROffsetCoordinate(2, -1),
      );
      expect(
        EvenROffsetCoordinate.fromCube(const CubeCoordinate(1, -1, 0)),
        const EvenROffsetCoordinate(1, 0),
      );
    });

    test('should return corresponding cube coordinate', () {
      expect(
        EvenROffsetCoordinate.zero.toCube(),
        CubeCoordinate.zero,
      );
      expect(
        const EvenROffsetCoordinate(2, 2).toCube(),
        const CubeCoordinate(1, -3, 2),
      );
      expect(
        const EvenROffsetCoordinate(2, -1).toCube(),
        const CubeCoordinate(2, -1, -1),
      );
      expect(
        const EvenROffsetCoordinate(1, 0).toCube(),
        const CubeCoordinate(1, -1, 0),
      );
    });
  });
}
