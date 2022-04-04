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
        if (bits[i] == 0) array.unsetBit(i);
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
        expect(array[i], bits[i] == 1);
      }
    });

    test('should properly set bit with correct state', () {
      final array = BitArray();
      for (var i = bits.length - 1; i >= 0; i -= 1) {
        array[i] = bits[i] == 1;
      }
      for (var i = 0; i < bits.length; i += 1) {
        expect(array[i], bits[i] == 1);
      }
    });

    test('should properly set bits', () {
      array.setBits(bitsToChange);
      for (var i = 0; i < bits.length; i += 1) {
        if (bitsToChange.contains(i)) bits[i] = 1;
        expect(array[i], bits[i] == 1);
      }
    });

    test('should properly unset bits', () {
      array.unsetBits(bitsToChange);
      for (var i = 0; i < bits.length; i += 1) {
        if (bitsToChange.contains(i)) bits[i] = 0;
        expect(array[i], bits[i] == 1);
      }
    });

    test('should return integer with inverted bits', () {
      bitsToChange = bitsToChange.toSet().toList();
      array.invertBits(bitsToChange);
      for (var i = 0; i < bits.length; i += 1) {
        if (bitsToChange.contains(i)) bits[i] = bits[i] == 0 ? 1 : 0;
        expect(array[i], bits[i] == 1);
      }
    });

    test('should properly handle length on all operations', () {
      expect(array.length, bits.length);
      array.setBit(array.length - 1);
      expect(array.length, bits.length);
      final addedLength = random.nextInt(10);
      array.setBit(bits.length + addedLength - 1);
      expect(array.length, bits.length + addedLength);
      array.unsetBit(bits.length + addedLength - 1);
      expect(array.length, bits.length + addedLength);
      array.unsetBit(bits.length + addedLength * 2 - 1);
      expect(array.length, bits.length + addedLength * 2);
      array.invertBit(bits.length + addedLength * 3 - 1);
      expect(array.length, bits.length + addedLength * 3);
      final outOfRangeValue = array[bits.length + addedLength * 4 - 1];
      expect(array.length, bits.length + addedLength * 3);
      expect(outOfRangeValue, isFalse);
      array.reset();
      expect(array.length, 0);
    });
  });
}
