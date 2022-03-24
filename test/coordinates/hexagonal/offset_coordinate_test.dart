import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

void main() {
  group('OddQOffsetCoordinate', () {
    test('should shift by direction', () {
      final start = OddQOffsetCoordinate.zero;
      expect(
        start.shift(FlatToppedHexagonalDirection.top),
        OddQOffsetCoordinate(0, -1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.topRight),
        OddQOffsetCoordinate(1, -1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.bottomRight),
        OddQOffsetCoordinate(1, 0),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.bottom),
        OddQOffsetCoordinate(0, 1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.bottomLeft),
        OddQOffsetCoordinate(-1, 0),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.topLeft),
        OddQOffsetCoordinate(-1, -1),
      );
      expect(
        start
            .shift(FlatToppedHexagonalDirection.topLeft)
            .shift(FlatToppedHexagonalDirection.bottom)
            .shift(FlatToppedHexagonalDirection.bottomRight),
        OddQOffsetCoordinate(0, 1),
      );
    });

    test('should move by direction and distance', () {
      final start = OddQOffsetCoordinate.zero;
      expect(
        start.move(FlatToppedHexagonalDirection.top, 0),
        OddQOffsetCoordinate.zero,
      );
      expect(
        start.move(FlatToppedHexagonalDirection.top, 2),
        OddQOffsetCoordinate(0, -2),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.topRight, 5),
        OddQOffsetCoordinate(5, -3),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.bottomRight, 3),
        OddQOffsetCoordinate(3, 1),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.bottom, 5),
        OddQOffsetCoordinate(0, 5),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.bottomLeft, 2),
        OddQOffsetCoordinate(-2, 1),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.topLeft, 3),
        OddQOffsetCoordinate(-3, -2),
      );
      expect(
        start
            .move(FlatToppedHexagonalDirection.topLeft, 2)
            .move(FlatToppedHexagonalDirection.bottom, 3)
            .move(FlatToppedHexagonalDirection.bottomRight, 1),
        OddQOffsetCoordinate(-1, 2),
      );
    });

    test('should return distance between coordinates', () {
      final start = OddQOffsetCoordinate.zero;
      expect(start.distanceTo(OddQOffsetCoordinate.zero), 0);
      expect(start.distanceTo(OddQOffsetCoordinate(3, 2)), 4);
      expect(start.distanceTo(OddQOffsetCoordinate(1, 6)), 7);
      expect(start.distanceTo(OddQOffsetCoordinate(5, 5)), 8);
      expect(start.distanceTo(OddQOffsetCoordinate(-3, -2)), 3);
    });

    test('should create offset coordinate from cube coordinate', () {
      expect(
        OddQOffsetCoordinate.fromCube(CubeCoordinate.zero),
        OddQOffsetCoordinate.zero,
      );
      expect(
        OddQOffsetCoordinate.fromCube(const CubeCoordinate(2, -3, 1)),
        OddQOffsetCoordinate(2, 2),
      );
      expect(
        OddQOffsetCoordinate.fromCube(const CubeCoordinate(2, 0, -2)),
        OddQOffsetCoordinate(2, -1),
      );
      expect(
        OddQOffsetCoordinate.fromCube(const CubeCoordinate(1, -1, 0)),
        OddQOffsetCoordinate(1, 0),
      );
    });

    test('should return corresponding cube coordinate', () {
      expect(
        OddQOffsetCoordinate.zero.toCube(),
        CubeCoordinate.zero,
      );
      expect(
        OddQOffsetCoordinate(2, 2).toCube(),
        const CubeCoordinate(2, -3, 1),
      );
      expect(
        OddQOffsetCoordinate(2, -1).toCube(),
        const CubeCoordinate(2, 0, -2),
      );
      expect(
        OddQOffsetCoordinate(1, 0).toCube(),
        const CubeCoordinate(1, -1, 0),
      );
    });
  });

  group('EvenQOffsetCoordinate', () {
    test('should shift by direction', () {
      final start = EvenQOffsetCoordinate.zero;
      expect(
        start.shift(FlatToppedHexagonalDirection.top),
        EvenQOffsetCoordinate(0, -1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.topRight),
        EvenQOffsetCoordinate(1, 0),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.bottomRight),
        EvenQOffsetCoordinate(1, 1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.bottom),
        EvenQOffsetCoordinate(0, 1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.bottomLeft),
        EvenQOffsetCoordinate(-1, 1),
      );
      expect(
        start.shift(FlatToppedHexagonalDirection.topLeft),
        EvenQOffsetCoordinate(-1, 0),
      );
      expect(
        start
            .shift(FlatToppedHexagonalDirection.topLeft)
            .shift(FlatToppedHexagonalDirection.bottom)
            .shift(FlatToppedHexagonalDirection.bottomRight),
        EvenQOffsetCoordinate(0, 1),
      );
    });

    test('should move by direction and distance', () {
      final start = EvenQOffsetCoordinate.zero;
      expect(
        start.move(FlatToppedHexagonalDirection.top, 0),
        EvenQOffsetCoordinate.zero,
      );
      expect(
        start.move(FlatToppedHexagonalDirection.top, 2),
        EvenQOffsetCoordinate(0, -2),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.topRight, 5),
        EvenQOffsetCoordinate(5, -2),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.bottomRight, 3),
        EvenQOffsetCoordinate(3, 2),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.bottom, 5),
        EvenQOffsetCoordinate(0, 5),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.bottomLeft, 2),
        EvenQOffsetCoordinate(-2, 1),
      );
      expect(
        start.move(FlatToppedHexagonalDirection.topLeft, 3),
        EvenQOffsetCoordinate(-3, -1),
      );
      expect(
        start
            .move(FlatToppedHexagonalDirection.topLeft, 2)
            .move(FlatToppedHexagonalDirection.bottom, 3)
            .move(FlatToppedHexagonalDirection.bottomRight, 1),
        EvenQOffsetCoordinate(-1, 3),
      );
    });

    test('should return distance between coordinates', () {
      final start = EvenQOffsetCoordinate.zero;
      expect(start.distanceTo(EvenQOffsetCoordinate.zero), 0);
      expect(start.distanceTo(EvenQOffsetCoordinate(3, 2)), 3);
      expect(start.distanceTo(EvenQOffsetCoordinate(1, 6)), 6);
      expect(start.distanceTo(EvenQOffsetCoordinate(5, 5)), 7);
      expect(start.distanceTo(EvenQOffsetCoordinate(-3, -2)), 4);
    });

    test('should create offset coordinate from cube coordinate', () {
      expect(
        EvenQOffsetCoordinate.fromCube(CubeCoordinate.zero),
        EvenQOffsetCoordinate.zero,
      );
      expect(
        EvenQOffsetCoordinate.fromCube(const CubeCoordinate(2, -3, 1)),
        EvenQOffsetCoordinate(2, 2),
      );
      expect(
        EvenQOffsetCoordinate.fromCube(const CubeCoordinate(2, 0, -2)),
        EvenQOffsetCoordinate(2, -1),
      );
      expect(
        EvenQOffsetCoordinate.fromCube(const CubeCoordinate(1, 0, -1)),
        EvenQOffsetCoordinate(1, 0),
      );
    });

    test('should return corresponding cube coordinate', () {
      expect(
        EvenQOffsetCoordinate.zero.toCube(),
        CubeCoordinate.zero,
      );
      expect(
        EvenQOffsetCoordinate(2, 2).toCube(),
        const CubeCoordinate(2, -3, 1),
      );
      expect(
        EvenQOffsetCoordinate(2, -1).toCube(),
        const CubeCoordinate(2, 0, -2),
      );
      expect(
        EvenQOffsetCoordinate(1, 0).toCube(),
        const CubeCoordinate(1, 0, -1),
      );
    });
  });

  group('OddROffsetCoordinate', () {
    test('should shift by direction', () {
      final start = OddROffsetCoordinate.zero;
      expect(
        start.shift(PointyToppedHexagonalDirection.topLeft),
        OddROffsetCoordinate(-1, -1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.topRight),
        OddROffsetCoordinate(0, -1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.right),
        OddROffsetCoordinate(1, 0),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.bottomRight),
        OddROffsetCoordinate(0, 1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.bottomLeft),
        OddROffsetCoordinate(-1, 1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.left),
        OddROffsetCoordinate(-1, 0),
      );
      expect(
        start
            .shift(PointyToppedHexagonalDirection.topLeft)
            .shift(PointyToppedHexagonalDirection.right)
            .shift(PointyToppedHexagonalDirection.bottomRight),
        OddROffsetCoordinate(1, 0),
      );
    });

    test('should move by direction and distance', () {
      final start = OddROffsetCoordinate.zero;
      expect(
        start.move(PointyToppedHexagonalDirection.topLeft, 0),
        OddROffsetCoordinate.zero,
      );
      expect(
        start.move(PointyToppedHexagonalDirection.topLeft, 2),
        OddROffsetCoordinate(-1, -2),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.topRight, 5),
        OddROffsetCoordinate(2, -5),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.right, 3),
        OddROffsetCoordinate(3, 0),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.bottomRight, 5),
        OddROffsetCoordinate(2, 5),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.bottomLeft, 2),
        OddROffsetCoordinate(-1, 2),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.left, 3),
        OddROffsetCoordinate(-3, 0),
      );
      expect(
        start
            .move(PointyToppedHexagonalDirection.topLeft, 2)
            .move(PointyToppedHexagonalDirection.right, 3)
            .move(PointyToppedHexagonalDirection.bottomRight, 1),
        OddROffsetCoordinate(2, -1),
      );
    });

    test('should return distance between coordinates', () {
      final start = OddROffsetCoordinate.zero;
      expect(start.distanceTo(OddROffsetCoordinate.zero), 0);
      expect(start.distanceTo(OddROffsetCoordinate(3, 2)), 4);
      expect(start.distanceTo(OddROffsetCoordinate(1, 6)), 6);
      expect(start.distanceTo(OddROffsetCoordinate(5, 5)), 8);
      expect(start.distanceTo(OddROffsetCoordinate(-3, -2)), 4);
    });

    test('should create offset coordinate from cube coordinate', () {
      expect(
        OddROffsetCoordinate.fromCube(CubeCoordinate.zero),
        OddROffsetCoordinate.zero,
      );
      expect(
        OddROffsetCoordinate.fromCube(const CubeCoordinate(1, -3, 2)),
        OddROffsetCoordinate(2, 2),
      );
      expect(
        OddROffsetCoordinate.fromCube(const CubeCoordinate(3, -2, -1)),
        OddROffsetCoordinate(2, -1),
      );
      expect(
        OddROffsetCoordinate.fromCube(const CubeCoordinate(1, -1, 0)),
        OddROffsetCoordinate(1, 0),
      );
    });

    test('should return corresponding cube coordinate', () {
      expect(
        OddROffsetCoordinate.zero.toCube(),
        CubeCoordinate.zero,
      );
      expect(
        OddROffsetCoordinate(2, 2).toCube(),
        const CubeCoordinate(1, -3, 2),
      );
      expect(
        OddROffsetCoordinate(2, -1).toCube(),
        const CubeCoordinate(3, -2, -1),
      );
      expect(
        OddROffsetCoordinate(1, 0).toCube(),
        const CubeCoordinate(1, -1, 0),
      );
    });
  });

  group('EvenROffsetCoordinate', () {
    test('should shift by direction', () {
      final start = EvenROffsetCoordinate.zero;
      expect(
        start.shift(PointyToppedHexagonalDirection.topLeft),
        EvenROffsetCoordinate(0, -1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.topRight),
        EvenROffsetCoordinate(1, -1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.right),
        EvenROffsetCoordinate(1, 0),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.bottomRight),
        EvenROffsetCoordinate(1, 1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.bottomLeft),
        EvenROffsetCoordinate(0, 1),
      );
      expect(
        start.shift(PointyToppedHexagonalDirection.left),
        EvenROffsetCoordinate(-1, 0),
      );
      expect(
        start
            .shift(PointyToppedHexagonalDirection.topLeft)
            .shift(PointyToppedHexagonalDirection.right)
            .shift(PointyToppedHexagonalDirection.bottomRight),
        EvenROffsetCoordinate(1, 0),
      );
    });

    test('should move by direction and distance', () {
      final start = EvenROffsetCoordinate.zero;
      expect(
        start.move(PointyToppedHexagonalDirection.topLeft, 0),
        EvenROffsetCoordinate.zero,
      );
      expect(
        start.move(PointyToppedHexagonalDirection.topLeft, 2),
        EvenROffsetCoordinate(-1, -2),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.topRight, 5),
        EvenROffsetCoordinate(3, -5),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.right, 3),
        EvenROffsetCoordinate(3, 0),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.bottomRight, 5),
        EvenROffsetCoordinate(3, 5),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.bottomLeft, 2),
        EvenROffsetCoordinate(-1, 2),
      );
      expect(
        start.move(PointyToppedHexagonalDirection.left, 3),
        EvenROffsetCoordinate(-3, 0),
      );
      expect(
        start
            .move(PointyToppedHexagonalDirection.topLeft, 2)
            .move(PointyToppedHexagonalDirection.right, 3)
            .move(PointyToppedHexagonalDirection.bottomRight, 1),
        EvenROffsetCoordinate(3, -1),
      );
    });

    test('should return distance between coordinates', () {
      final start = EvenROffsetCoordinate.zero;
      expect(start.distanceTo(EvenROffsetCoordinate.zero), 0);
      expect(start.distanceTo(EvenROffsetCoordinate(3, 2)), 4);
      expect(start.distanceTo(EvenROffsetCoordinate(1, 6)), 6);
      expect(start.distanceTo(EvenROffsetCoordinate(5, 5)), 7);
      expect(start.distanceTo(EvenROffsetCoordinate(-3, -2)), 4);
    });

    test('should create offset coordinate from cube coordinate', () {
      expect(
        EvenROffsetCoordinate.fromCube(CubeCoordinate.zero),
        EvenROffsetCoordinate.zero,
      );
      expect(
        EvenROffsetCoordinate.fromCube(const CubeCoordinate(1, -3, 2)),
        EvenROffsetCoordinate(2, 2),
      );
      expect(
        EvenROffsetCoordinate.fromCube(const CubeCoordinate(2, -1, -1)),
        EvenROffsetCoordinate(2, -1),
      );
      expect(
        EvenROffsetCoordinate.fromCube(const CubeCoordinate(1, -1, 0)),
        EvenROffsetCoordinate(1, 0),
      );
    });

    test('should return corresponding cube coordinate', () {
      expect(
        EvenROffsetCoordinate.zero.toCube(),
        CubeCoordinate.zero,
      );
      expect(
        EvenROffsetCoordinate(2, 2).toCube(),
        const CubeCoordinate(1, -3, 2),
      );
      expect(
        EvenROffsetCoordinate(2, -1).toCube(),
        const CubeCoordinate(2, -1, -1),
      );
      expect(
        EvenROffsetCoordinate(1, 0).toCube(),
        const CubeCoordinate(1, -1, 0),
      );
    });
  });
}
