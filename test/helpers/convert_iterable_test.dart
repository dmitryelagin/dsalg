import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';

void main() {
  final random = Random();

  group('ConvertNumIterable', () {
    test('should convert small numbers without changes', () {
      final numbers = random.nextIntList(100, 256);
      expect(numbers.toUint8List(), numbers);
      expect(numbers.toUint8ClampedList(), numbers);
    });

    test('should convert big numbers with changes', () {
      final numbers = random.nextIntList(100, 258, -2);
      final expectedOverflowedNumbers = numbers.map((number) {
        if (number.isNegative) return number + 256;
        if (number > 255) return number - 256;
        return number;
      });
      expect(numbers.toUint8List(), expectedOverflowedNumbers);
      final expectedClampedNumbers =
          numbers.map((number) => number.clamp(0, 255));
      expect(numbers.toUint8ClampedList(), expectedClampedNumbers);
    });
  });

  group('Convert2DNumIterable', () {
    test('should convert small numbers into 1D list without changes', () {
      final numbers = List.generate(100, (_) => random.nextIntList(100, 256));
      final flatNumbers =
          numbers.fold(<int>[], (list, part) => list..addAll(part));
      expect(numbers.toUint8List(), flatNumbers);
      expect(numbers.toUint8ClampedList(), flatNumbers);
    });

    test('should convert big numbers into 1D list with changes', () {
      final numbers =
          List.generate(100, (_) => random.nextIntList(100, 258, -2));
      final flatNumbers =
          numbers.fold(<int>[], (list, part) => list..addAll(part));
      final expectedOverflowedNumbers = flatNumbers.map((number) {
        if (number.isNegative) return number + 256;
        if (number > 255) return number - 256;
        return number;
      });
      expect(numbers.toUint8List(), expectedOverflowedNumbers);
      final expectedClampedNumbers =
          flatNumbers.map((number) => number.clamp(0, 255));
      expect(numbers.toUint8ClampedList(), expectedClampedNumbers);
    });
  });
}
