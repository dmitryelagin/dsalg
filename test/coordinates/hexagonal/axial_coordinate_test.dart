import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../../utils/test_utils.dart';

void main() {
  final random = Random();

  group('AxialCoordinate', () {
    test('should shift by direction', () {
      const start = AxialCoordinate.zero;
      expect(
        start.shift(HexagonalDirection.flatToppedTop),
        const AxialCoordinate(0, -1),
      );
      expect(
        start.shift(HexagonalDirection.flatToppedTopRight),
        const AxialCoordinate(1, -1),
      );
      expect(
        start.shift(HexagonalDirection.flatToppedBottomRight),
        const AxialCoordinate(1, 0),
      );
      expect(
        start.shift(HexagonalDirection.flatToppedBottom),
        const AxialCoordinate(0, 1),
      );
      expect(
        start.shift(HexagonalDirection.flatToppedBottomLeft),
        const AxialCoordinate(-1, 1),
      );
      expect(
        start.shift(HexagonalDirection.flatToppedTopLeft),
        const AxialCoordinate(-1, 0),
      );
      expect(
        AxialCoordinate.zero
            .shift(HexagonalDirection.flatToppedTopLeft)
            .shift(HexagonalDirection.flatToppedBottom)
            .shift(HexagonalDirection.flatToppedBottomRight),
        const AxialCoordinate(0, 1),
      );
    });

    test('should move by direction and distance', () {
      const start = AxialCoordinate.zero;
      expect(
        start.move(HexagonalDirection.flatToppedTop, 0),
        AxialCoordinate.zero,
      );
      expect(
        start.move(HexagonalDirection.flatToppedTop, 2),
        const AxialCoordinate(0, -2),
      );
      expect(
        start.move(HexagonalDirection.flatToppedTopRight, 5),
        const AxialCoordinate(5, -5),
      );
      expect(
        start.move(HexagonalDirection.flatToppedBottomRight, 3),
        const AxialCoordinate(3, 0),
      );
      expect(
        start.move(HexagonalDirection.flatToppedBottom, 5),
        const AxialCoordinate(0, 5),
      );
      expect(
        start.move(HexagonalDirection.flatToppedBottomLeft, 2),
        const AxialCoordinate(-2, 2),
      );
      expect(
        start.move(HexagonalDirection.flatToppedTopLeft, 3),
        const AxialCoordinate(-3, 0),
      );
      expect(
        start
            .move(HexagonalDirection.flatToppedTopLeft, 2)
            .move(HexagonalDirection.flatToppedBottom, 3)
            .move(HexagonalDirection.flatToppedBottomRight, 1),
        const AxialCoordinate(-1, 3),
      );
    });

    test('should accept all directions', () {
      const start = AxialCoordinate.zero;
      expect(
        start.shift(HexagonalDirection.pointyToppedTopLeft),
        start.shift(HexagonalDirection.flatToppedTop),
      );
      expect(
        start.shift(HexagonalDirection.pointyToppedTopRight),
        start.shift(HexagonalDirection.flatToppedTopRight),
      );
      expect(
        start.shift(HexagonalDirection.pointyToppedRight),
        start.shift(HexagonalDirection.flatToppedBottomRight),
      );
      expect(
        start.shift(HexagonalDirection.pointyToppedBottomRight),
        start.shift(HexagonalDirection.flatToppedBottom),
      );
      expect(
        start.shift(HexagonalDirection.pointyToppedBottomLeft),
        start.shift(HexagonalDirection.flatToppedBottomLeft),
      );
      expect(
        start.shift(HexagonalDirection.pointyToppedLeft),
        start.shift(HexagonalDirection.flatToppedTopLeft),
      );
    });

    test('should return distance between coordinates', () {
      const start = AxialCoordinate.zero;
      expect(start.distanceTo(AxialCoordinate.zero), 0);
      expect(start.distanceTo(const AxialCoordinate(1, 2)), 3);
      expect(start.distanceTo(const AxialCoordinate(2, 2)), 4);
      expect(start.distanceTo(const AxialCoordinate(5, -3)), 5);
      expect(start.distanceTo(const AxialCoordinate(-2, 3)), 3);
    });

    test('should return all neighbor coordinates', () {
      repeat(times: 10, () {
        final start = AxialCoordinate(random.nextInt(10), random.nextInt(10));
        expect(
          Stream.fromIterable(start.neighbors),
          emitsInAnyOrder([
            start.shift(HexagonalDirection.flatToppedBottomLeft),
            start.shift(HexagonalDirection.flatToppedTopLeft),
            start.shift(HexagonalDirection.flatToppedTop),
            start.shift(HexagonalDirection.flatToppedTopRight),
            start.shift(HexagonalDirection.flatToppedBottomRight),
            start.shift(HexagonalDirection.flatToppedBottom),
          ]),
        );
      });
    });

    test('should return all coordinates on specific distance', () {
      const start = AxialCoordinate.zero;
      final randomDistance = 2 + random.nextInt(5);
      expect(start.getAllOnDistance(0), isEmpty);
      expect(
        start.getAllOnDistance(-randomDistance),
        start.getAllOnDistance(randomDistance),
      );
      expect(
        Stream.fromIterable(start.getAllOnDistance(3)),
        emitsInAnyOrder(const [
          AxialCoordinate(-3, 3),
          AxialCoordinate(-3, 2),
          AxialCoordinate(-3, 1),
          AxialCoordinate(-3, 0),
          AxialCoordinate(-2, -1),
          AxialCoordinate(-1, -2),
          AxialCoordinate(0, -3),
          AxialCoordinate(1, -3),
          AxialCoordinate(2, -3),
          AxialCoordinate(3, -3),
          AxialCoordinate(3, -2),
          AxialCoordinate(3, -1),
          AxialCoordinate(3, 0),
          AxialCoordinate(2, 1),
          AxialCoordinate(1, 2),
          AxialCoordinate(0, 3),
          AxialCoordinate(-1, 3),
          AxialCoordinate(-2, 3),
        ]),
      );
    });

    test('should return all coordinates in specific range', () {
      const start = AxialCoordinate.zero;
      final randomDistance = 2 + random.nextInt(5);
      expect(start.getAllInRange(0), const [start]);
      expect(
        start.getAllInRange(-randomDistance),
        start.getAllInRange(randomDistance),
      );
      expect(
        Stream.fromIterable(start.getAllInRange(randomDistance)),
        emitsInAnyOrder([
          start,
          for (var i = 0; i < randomDistance; i += 1)
            ...start.getAllOnDistance(i + 1),
        ]),
      );
    });

    test('should return the shortest coordinates set between boundaries', () {
      expect(
        Stream.fromIterable(
          AxialCoordinate.zero.getLineTo(const AxialCoordinate(2, -1)),
        ),
        emitsInAnyOrder(const [
          AxialCoordinate.zero,
          AxialCoordinate(1, -1),
          AxialCoordinate(2, -1),
        ]),
      );
      expect(
        Stream.fromIterable(
          AxialCoordinate.zero.getLineTo(const AxialCoordinate(1, 2)),
        ),
        emitsInAnyOrder(const [
          AxialCoordinate.zero,
          AxialCoordinate(0, 1),
          AxialCoordinate(1, 1),
          AxialCoordinate(1, 2),
        ]),
      );
      expect(
        Stream.fromIterable(
          AxialCoordinate.zero.getLineTo(const AxialCoordinate(-4, 1)),
        ),
        emitsInAnyOrder(const [
          AxialCoordinate.zero,
          AxialCoordinate(-1, 0),
          AxialCoordinate(-2, 0),
          AxialCoordinate(-3, 1),
          AxialCoordinate(-4, 1),
        ]),
      );
    });

    test('should return the same coordinates set on boundaries switch', () {
      repeat(times: 10, () {
        final start = AxialCoordinate(random.nextInt(10), random.nextInt(10));
        final end = AxialCoordinate(random.nextInt(10), random.nextInt(10));
        expect(
          Stream.fromIterable(start.getLineTo(end)),
          emitsInAnyOrder(end.getLineTo(start)),
        );
      });
    });

    test('should create coordinate from two numbers', () {
      repeat(times: 10, () {
        final q = random.nextDouble() * random.nextInt(10);
        final r = random.nextDouble() * random.nextInt(10);
        final coord = AxialCoordinate.fromNum(q, r);
        expect(coord.q, q.round());
        expect(coord.r, r.round());
      });
    });

    test('should create coordinate from cube coordinate', () {
      repeat(times: 10, () {
        final cube = CubeCoordinate.fromXZ(
          random.nextInt(10),
          random.nextInt(10),
        );
        final axial = AxialCoordinate.fromCube(cube);
        expect(cube.x, axial.q);
        expect(cube.z, axial.r);
      });
    });
  });
}
