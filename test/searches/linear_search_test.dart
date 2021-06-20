import 'dart:math';

import 'package:dsalg/searches.dart';
import 'package:test/test.dart';

void main() {
  group('LinearSearch', () {
    test('should find index in random list', () {
      final random = Random();
      final items = List.generate(1000, (_) => random.nextInt(1000));
      final target = items[random.nextInt(1000)];
      expect(
        items.linearSearch((item) => item == target),
        items.indexOf(target),
      );
    });

    test('should return negative when item is not found', () {
      final items = <int>[0];
      expect(items.linearSearch((item) => item == 1), -1);
    });

    test('should return negative when empty', () {
      final items = <int>[];
      expect(items.linearSearch((item) => item == 1), -1);
    });
  });
}
