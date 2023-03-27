import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';

void main() {
  group('BitArray', () {
    final random = Random();
    var array = BitArray();
    var bits = <int>[], bitsToChange = <int>[];

    setUp(() {
      array = BitArray();
      bits = random.nextIntList(100, 2);
      for (var i = 0; i < bits.length; i += 1) {
        if (bits[i] == 0) array.unsetBit(i);
        if (bits[i] == 1) array.setBit(i);
      }
      bitsToChange = random.nextIntList(bits.length ~/ 2, bits.length);
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
      final addedLength = random.nextInt(10) + 1;
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

    test('should save and read bits in string representation', () {
      final array = BitArray();
      var index = -1;
      final values = random.nextIntList(100, 1 << 32);
      for (final value in values) {
        for (final bit in value.bits) {
          array[index += 1] = bit;
        }
      }
      final data = array.toDataString();
      expect(data.length, lessThan(array.length));
      final actual = BitArray.fromDataString(data);
      for (var i = 0; i < actual.length; i += 1) {
        expect(actual[i], array[i]);
      }
      final text = random.nextString(10, 20);
      expect(BitArray.fromDataString(text).toDataString(), text);
    });

    test('should trim string representation if necessary', () {
      expect((BitArray()..setBit(40)).toDataString().length, 3);
      expect((BitArray()..setBit(47)).toDataString().length, 3);
      expect((BitArray()..setBit(48)).toDataString().length, 4);
      expect(BitArray.fromDataString('abc').toDataString(), 'abc');
      expect(BitArray.fromDataString('abcd').toDataString(), 'abcd');
    });

    test('should create instance from bools reversed collection', () {
      final items = random.nextBoolList(100);
      final itemsReversed = items.reversed.toList();
      final array = BitArray.from(items);
      expect(array, itemsReversed);
    });

    test('should create instance from bool factory function', () {
      final items = random.nextBoolList(100);
      final array = BitArray.generate(items.length, (i) => items[i]);
      expect(array, items);
    });

    test('should return bits collection in correct order', () {
      final bits = array.bits.toList();
      final bitsReversed = array.bitsReversed.toList();
      expect(bits.length, array.length);
      expect(bitsReversed.length, array.length);
      for (var i = 0; i < array.length; i += 1) {
        expect(bits[i], array[i]);
        expect(bitsReversed[array.length - i - 1], array[i]);
      }
    });
  });
}
