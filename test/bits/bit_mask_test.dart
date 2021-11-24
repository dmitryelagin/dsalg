import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

void main() {
  group('BitMask', () {
    const number = 850;
    final random = Random();
    final bits = [1, 1, 0, 1, 0, 1, 0, 0, 1, 0];
    var bitsReversed = <int>[];
    var bitsToChange = <int>[];

    setUp(() {
      bitsReversed = bits.reversed.toList();
      bitsToChange =
          List.generate(bits.length ~/ 2, (i) => random.nextInt(bits.length));
    });

    test('should return proper state of a bits', () {
      expect(number.setBitsAmount, bits.where((i) => i == 1).length);
      expect(number.unsetBitsAmount, bits.where((i) => i == 0).length);
      for (var i = bits.length - 1; i >= 0; i -= 1) {
        expect(number.isSetBit(i), bitsReversed[i] == 1);
        expect(number.isUnsetBit(i), bitsReversed[i] == 0);
        expect(number[i], bitsReversed[i] == 1);
      }
    });

    test('should return integer with set bits', () {
      for (var i = 0; i < bits.length; i += 1) {
        if (bitsToChange.contains(i)) bitsReversed[i] = 1;
      }
      expect(number.setBits(bitsToChange).bits, bitsReversed);
    });

    test('should return integer with unset bits', () {
      for (var i = 0; i < bits.length; i += 1) {
        if (bitsToChange.contains(i)) bitsReversed[i] = 0;
      }
      expect(
        number.unsetBits(bitsToChange).bits,
        bitsReversed.take(bitsReversed.lastIndexOf(1) + 1),
      );
    });

    test('should return integer with inverted bits', () {
      bitsToChange = bitsToChange.toSet().toList();
      for (var i = 0; i < bits.length; i += 1) {
        if (!bitsToChange.contains(i)) continue;
        bitsReversed[i] = bitsReversed[i] == 0 ? 1 : 0;
      }
      expect(
        number.invertBits(bitsToChange).bits,
        bitsReversed.take(bitsReversed.lastIndexOf(1) + 1),
      );
    });
  });
}
