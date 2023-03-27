import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';

void main() {
  final random = Random();

  group('BitMask', () {
    const value = 850, valueNumericBits = [1, 1, 0, 1, 0, 1, 0, 0, 1, 0];
    final valueBits = valueNumericBits.map((bit) => bit == 1).toList();
    var valueBitsOrdered = <bool>[], bitsToChange = <int>[];

    setUp(() {
      valueBitsOrdered = valueBits.reversed.toList();
      bitsToChange =
          random.nextIntList(valueBits.length ~/ 2, valueBits.length);
    });

    test('should return proper state of a bits', () {
      expect(value.setBitsAmount, valueBits.where((bit) => bit).length);
      expect(value.unsetBitsAmount, valueBits.where((bit) => !bit).length);
      for (var i = 0; i < valueBits.length; i += 1) {
        expect(value.isSetBit(i), valueBitsOrdered[i]);
        expect(value.isUnsetBit(i), !valueBitsOrdered[i]);
        expect(value[i], valueBitsOrdered[i]);
      }
    });

    test('should return integer with assigned bits', () {
      var actual = value;
      for (final i in bitsToChange) {
        valueBitsOrdered[i] = i.isOdd;
        actual = actual.assignBit(i, value: i.isOdd);
      }
      expect(actual.bits.toList(), valueBitsOrdered);
    });

    test('should return integer with set bits', () {
      for (final i in bitsToChange) {
        valueBitsOrdered[i] = true;
      }
      expect(value.setBits(bitsToChange).bits, valueBitsOrdered);
    });

    test('should return integer with unset bits', () {
      for (final i in bitsToChange) {
        valueBitsOrdered[i] = false;
      }
      expect(
        value.unsetBits(bitsToChange).bits,
        valueBitsOrdered.take(valueBitsOrdered.lastIndexOf(true) + 1),
      );
    });

    test('should return integer with inverted bits', () {
      bitsToChange = bitsToChange.toSet().toList();
      for (final i in bitsToChange) {
        valueBitsOrdered[i] = !valueBitsOrdered[i];
      }
      expect(
        value.invertBits(bitsToChange).bits,
        valueBitsOrdered.take(valueBitsOrdered.lastIndexOf(true) + 1),
      );
    });

    test('should return bits collection in correct order', () {
      expect(value.bits, valueBitsOrdered);
      expect(value.bitsReversed, valueBits);
    });
  });
}
