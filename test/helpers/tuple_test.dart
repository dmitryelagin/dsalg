import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';

void main() {
  final random = Random();

  group('Tuple', () {
    test('should stay with the provided values', () {
      for (var i = 0; i < 10; i += 1) {
        var values = random.nextStringList(2, 5, 10);
        final pair = Pair(values[0], values[1]);
        expect(pair.first, values[0]);
        expect(pair.second, values[1]);
        values = random.nextStringList(3, 5, 10);
        final result = Trio(values[0], values[1], values[2]);
        expect(result.first, values[0]);
        expect(result.second, values[1]);
        expect(result.third, values[2]);
      }
    });
  });
}
