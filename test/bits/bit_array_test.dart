import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

void main() {
  group('BitArray', () {
    final random = Random();
    var array = BitArray();
    var bits = <int>[];
    var bitsToChange = <int>[];

    setUp(() {
      array = BitArray();
      bits = List.generate(100, (_) => random.nextInt(2));
      for (var i = 0; i < bits.length; i += 1) {
        if (bits[i] == 1) array.setBit(i);
      }
      bitsToChange = List.generate(
        bits.length ~/ 2,
        (i) => random.nextInt(bits.length),
      );
    });

    test('should return proper state of a bits', () {
      for (var i = 0; i < bits.length; i += 1) {
        expect(array.isSetBit(i), bits[i] == 1);
        expect(array.isUnsetBit(i), bits[i] == 0);
        expect(array[i], bits[i]);
      }
    });

    test('should properly set bits', () {
      array.setBits(bitsToChange);
      for (var i = 0; i < bits.length; i += 1) {
        if (bitsToChange.contains(i)) bits[i] = 1;
        expect(array[i], bits[i]);
      }
    });

    test('should properly unset bits', () {
      array.unsetBits(bitsToChange);
      for (var i = 0; i < bits.length; i += 1) {
        if (bitsToChange.contains(i)) bits[i] = 0;
        expect(array[i], bits[i]);
      }
    });

    test('should return integer with inverted bits', () {
      bitsToChange = bitsToChange.toSet().toList();
      array.invertBits(bitsToChange);
      for (var i = 0; i < bits.length; i += 1) {
        if (bitsToChange.contains(i)) bits[i] = bits[i] == 0 ? 1 : 0;
        expect(array[i], bits[i]);
      }
    });
  });
}
