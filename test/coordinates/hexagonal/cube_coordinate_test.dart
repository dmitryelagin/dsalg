import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

void main() {
  final random = Random();

  group('CubeCoordinate', () {
    test('should shift by direction', () {
      const start = CubeCoordinate.zero;
      expect(
        start.shift(HexagonalDirection.flatToppedTop),
        const CubeCoordinate(0, 1, -1),
      );
      expect(
        start.shift(HexagonalDirection.flatToppedTopRight),
        const CubeCoordinate(1, 0, -1),
      );
      expect(
        start.shift(HexagonalDirection.flatToppedBottomRight),
        const CubeCoordinate(1, -1, 0),
      );
      expect(
        start.shift(HexagonalDirection.flatToppedBottom),
        const CubeCoordinate(0, -1, 1),
      );
      expect(
        start.shift(HexagonalDirection.flatToppedBottomLeft),
        const CubeCoordinate(-1, 0, 1),
      );
      expect(
        start.shift(HexagonalDirection.flatToppedTopLeft),
        const CubeCoordinate(-1, 1, 0),
      );
      expect(
        CubeCoordinate.zero
            .shift(HexagonalDirection.flatToppedTopLeft)
            .shift(HexagonalDirection.flatToppedBottom)
            .shift(HexagonalDirection.flatToppedBottomRight),
        const CubeCoordinate(0, -1, 1),
      );
    });

    test('should move by direction and distance', () {
      const start = CubeCoordinate.zero;
      expect(
        start.move(HexagonalDirection.flatToppedTop, 0),
        CubeCoordinate.zero,
      );
      expect(
        start.move(HexagonalDirection.flatToppedTop, 2),
        const CubeCoordinate(0, 2, -2),
      );
      expect(
        start.move(HexagonalDirection.flatToppedTopRight, 5),
        const CubeCoordinate(5, 0, -5),
      );
      expect(
        start.move(HexagonalDirection.flatToppedBottomRight, 3),
        const CubeCoordinate(3, -3, 0),
      );
      expect(
        start.move(HexagonalDirection.flatToppedBottom, 5),
        const CubeCoordinate(0, -5, 5),
      );
      expect(
        start.move(HexagonalDirection.flatToppedBottomLeft, 2),
        const CubeCoordinate(-2, 0, 2),
      );
      expect(
        start.move(HexagonalDirection.flatToppedTopLeft, 3),
        const CubeCoordinate(-3, 3, 0),
      );
      expect(
        start
            .move(HexagonalDirection.flatToppedTopLeft, 2)
            .move(HexagonalDirection.flatToppedBottom, 3)
            .move(HexagonalDirection.flatToppedBottomRight, 1),
        const CubeCoordinate(-1, -2, 3),
      );
    });

    test('should accept all directions', () {
      const start = CubeCoordinate.zero;
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
      const start = CubeCoordinate.zero;
      expect(start.distanceTo(CubeCoordinate.zero), 0);
      expect(start.distanceTo(const CubeCoordinate(1, -3, 2)), 3);
      expect(start.distanceTo(const CubeCoordinate(2, -4, 2)), 4);
      expect(start.distanceTo(const CubeCoordinate(5, -2, -3)), 5);
      expect(start.distanceTo(const CubeCoordinate(-2, -1, 3)), 3);
    });

    test('should be rotated around zero coordinate', () {
      const start = CubeCoordinate(-2, 1, 1);
      expect(CubeCoordinate.zero.rotate(100), CubeCoordinate.zero);
      expect(start.rotate(-6), start);
      expect(start.rotate(-5), start.rotate(1));
      expect(start.rotate(-4), start.rotate(2));
      expect(start.rotate(-3), start.rotate(3));
      expect(start.rotate(-2), start.rotate(4));
      expect(start.rotate(-1), start.rotate(5));
      expect(start.rotate(0), start);
      expect(start.rotate(1), const CubeCoordinate(-1, 2, -1));
      expect(start.rotate(2), const CubeCoordinate(1, 1, -2));
      expect(start.rotate(3), const CubeCoordinate(2, -1, -1));
      expect(start.rotate(4), const CubeCoordinate(1, -2, 1));
      expect(start.rotate(5), const CubeCoordinate(-1, -1, 2));
      expect(start.rotate(6), start);
      expect(start.rotate(7), start.rotate(1));
      expect(start.rotate(8), start.rotate(2));
      expect(start.rotate(9), start.rotate(3));
      expect(start.rotate(10), start.rotate(4));
      expect(start.rotate(11), start.rotate(5));
      expect(start.rotate(12), start);
    });

    test('should be rotated around anchor coordinate', () {
      const start = CubeCoordinate.zero;
      const anchor = CubeCoordinate(-2, 1, 1);
      expect(start.rotateAround(anchor, -6), start);
      expect(start.rotateAround(anchor, -5), start.rotateAround(anchor, 1));
      expect(start.rotateAround(anchor, -4), start.rotateAround(anchor, 2));
      expect(start.rotateAround(anchor, -3), start.rotateAround(anchor, 3));
      expect(start.rotateAround(anchor, -2), start.rotateAround(anchor, 4));
      expect(start.rotateAround(anchor, -1), start.rotateAround(anchor, 5));
      expect(start.rotateAround(anchor, 0), start);
      expect(start.rotateAround(anchor, 1), const CubeCoordinate(-1, -1, 2));
      expect(start.rotateAround(anchor, 2), const CubeCoordinate(-3, 0, 3));
      expect(start.rotateAround(anchor, 3), const CubeCoordinate(-4, 2, 2));
      expect(start.rotateAround(anchor, 4), const CubeCoordinate(-3, 3, 0));
      expect(start.rotateAround(anchor, 5), const CubeCoordinate(-1, 2, -1));
      expect(start.rotateAround(anchor, 6), start);
      expect(start.rotateAround(anchor, 7), start.rotateAround(anchor, 1));
      expect(start.rotateAround(anchor, 8), start.rotateAround(anchor, 2));
      expect(start.rotateAround(anchor, 9), start.rotateAround(anchor, 3));
      expect(start.rotateAround(anchor, 10), start.rotateAround(anchor, 4));
      expect(start.rotateAround(anchor, 11), start.rotateAround(anchor, 5));
      expect(start.rotateAround(anchor, 12), start);
    });

    test('should add other coordinate values', () {
      for (var i = 0; i < 10; i += 1) {
        final a = CubeCoordinate.fromXZ(random.nextInt(10), random.nextInt(10));
        final b = CubeCoordinate.fromXZ(random.nextInt(10), random.nextInt(10));
        expect(a + b, CubeCoordinate(a.x + b.x, a.y + b.y, a.z + b.z));
      }
    });

    test('should subtract other coordinate values', () {
      for (var i = 0; i < 10; i += 1) {
        final a = CubeCoordinate.fromXZ(random.nextInt(10), random.nextInt(10));
        final b = CubeCoordinate.fromXZ(random.nextInt(10), random.nextInt(10));
        expect(a - b, CubeCoordinate(a.x - b.x, a.y - b.y, a.z - b.z));
      }
    });

    test('should reflect coordinate around other coordinate', () {
      var start = CubeCoordinate.zero;
      var anchor = const CubeCoordinate(-1, 2, -1);
      expect(start.reflect(anchor), const CubeCoordinate(-2, 4, -2));
      expect(start.reflectX(anchor), const CubeCoordinate(0, 3, -3));
      expect(start.reflectY(anchor), CubeCoordinate.zero);
      expect(start.reflectZ(anchor), const CubeCoordinate(-3, 3, 0));
      anchor = const CubeCoordinate(-3, 2, 1);
      expect(start.reflect(anchor), const CubeCoordinate(-6, 4, 2));
      expect(start.reflectX(anchor), const CubeCoordinate(0, 1, -1));
      expect(start.reflectY(anchor), const CubeCoordinate(-4, 0, 4));
      expect(start.reflectZ(anchor), const CubeCoordinate(-5, 5, 0));
      start = anchor;
      expect(start.reflect(), const CubeCoordinate(3, -2, -1));
      expect(start.reflectX(), const CubeCoordinate(-3, 1, 2));
      expect(start.reflectY(), const CubeCoordinate(1, 2, -3));
      expect(start.reflectZ(), const CubeCoordinate(2, -3, 1));
    });

    test('should return all neighbor coordinates', () {
      for (var i = 0; i < 10; i += 1) {
        final start = CubeCoordinate.fromXZ(
          random.nextInt(10),
          random.nextInt(10),
        );
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
      }
    });

    test('should return all coordinates on specific distance', () {
      const start = CubeCoordinate.zero;
      final randomDistance = 2 + random.nextInt(5);
      expect(start.getAllOnDistance(0), isEmpty);
      expect(
        start.getAllOnDistance(-randomDistance),
        start.getAllOnDistance(randomDistance),
      );
      const a = CubeCoordinate(-3, 0, 3);
      const b = CubeCoordinate(-3, 1, 2);
      const c = CubeCoordinate(-3, 2, 1);
      expect(
        Stream.fromIterable(start.getAllOnDistance(3)),
        emitsInAnyOrder([
          for (var i = 0;
              i < FlatToppedHexagonalDirection.values.length;
              i += 1) ...[a.rotate(i), b.rotate(i), c.rotate(i)],
        ]),
      );
    });

    test('should return all coordinates in specific range', () {
      const start = CubeCoordinate.zero;
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
          CubeCoordinate.zero.getLineTo(const CubeCoordinate(2, -1, -1)),
        ),
        emitsInAnyOrder(const [
          CubeCoordinate.zero,
          CubeCoordinate(1, 0, -1),
          CubeCoordinate(2, -1, -1),
        ]),
      );
      expect(
        Stream.fromIterable(
          CubeCoordinate.zero.getLineTo(const CubeCoordinate(1, -3, 2)),
        ),
        emitsInAnyOrder(const [
          CubeCoordinate.zero,
          CubeCoordinate(0, -1, 1),
          CubeCoordinate(1, -2, 1),
          CubeCoordinate(1, -3, 2),
        ]),
      );
      expect(
        Stream.fromIterable(
          CubeCoordinate.zero.getLineTo(const CubeCoordinate(-4, 3, 1)),
        ),
        emitsInAnyOrder(const [
          CubeCoordinate.zero,
          CubeCoordinate(-1, 1, 0),
          CubeCoordinate(-2, 2, 0),
          CubeCoordinate(-3, 2, 1),
          CubeCoordinate(-4, 3, 1),
        ]),
      );
    });

    test('should return the same coordinates set on boundaries switch', () {
      for (var i = 0; i < 10; i += 1) {
        final start = CubeCoordinate.fromXZ(
          random.nextInt(10),
          random.nextInt(10),
        );
        final end = CubeCoordinate.fromXZ(
          random.nextInt(10),
          random.nextInt(10),
        );
        expect(
          Stream.fromIterable(start.getLineTo(end)),
          emitsInAnyOrder(end.getLineTo(start)),
        );
      }
    });

    test('should create coordinate from two integers', () {
      for (var i = 0; i < 10; i += 1) {
        final coord = CubeCoordinate.fromXZ(
          random.nextInt(10),
          random.nextInt(10),
        );
        expect(coord.x + coord.y + coord.z, 0);
      }
    });

    test('should create coordinate from two numbers', () {
      for (var i = 0; i < 10; i += 1) {
        final x = random.nextDouble() * random.nextInt(10);
        final z = random.nextDouble() * random.nextInt(10);
        final coord = CubeCoordinate.fromNumXZ(x, z);
        expect(coord.x, x.round());
        expect(coord.z, z.round());
        expect(coord.x + coord.y + coord.z, 0);
      }
    });

    test('should create coordinate from axial coordinate', () {
      for (var i = 0; i < 10; i += 1) {
        final axial = AxialCoordinate(random.nextInt(10), random.nextInt(10));
        final cube = CubeCoordinate.fromAxial(axial);
        expect(axial.q, cube.x);
        expect(axial.r, cube.z);
      }
    });
  });
}
