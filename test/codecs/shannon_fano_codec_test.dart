import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';
import '../utils/matchers.dart';
import '../utils/test_utils.dart';

void main() {
  final random = Random();

  Iterable<bool> getBinaryPath(String path) =>
      path.split('').map((rune) => rune == '1');

  group('ShannonFanoCodec', () {
    test('should encode and decode standard message', () {
      final message = ([
        ...List.filled(22, 'A'),
        ...List.filled(28, 'B'),
        ...List.filled(15, 'C'),
        ...List.filled(30, 'D'),
        ...List.filled(5, 'E'),
      ]..shuffle(random))
          .join();
      final targetDictionary = {
        'D': '00',
        'B': '01',
        'A': '10',
        'C': '110',
        'E': '111',
      }.map((key, value) => MapEntry(key.runes.first, getBinaryPath(value)));
      final dictionary = ShannonFanoCodec.createDictionary(message);
      final codec = ShannonFanoCodec.fromDictionary(dictionary);
      final result = codec.encode(message);
      expect(dictionary, targetDictionary);
      expect(codec.decode(result), message);
    });

    test('should produce correct dictionary for standard small case', () {
      const message = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
          'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
          'cccccccccccccccccccc'
          'ddddd';
      final referenceDictionary = {'a': '0', 'b': '10', 'c': '110', 'd': '111'}
          .map((key, value) => MapEntry(key.runes.first, getBinaryPath(value)));
      expect(ShannonFanoCodec.createDictionary(message), referenceDictionary);
    });

    test('should properly encode and decode messages', () {
      for (final message in random.nextStringList(50, 100, 500)) {
        final codec = ShannonFanoCodec.from(message);
        expect(codec.decode(codec.encode(message)), message);
      }
    });

    test('should throw on empty and single-symbol messages', () {
      final codec = ShannonFanoCodec.from(random.nextString(10, 20));
      expect(() => codec.encode(''), throwsAssertionError);
      expect(() => codec.decode(BitArray()), throwsAssertionError);
    });

    test('should handle message with one repeating symbol', () {
      var message = 'a';
      var codec = ShannonFanoCodec.from(message);
      expect(codec.decode(codec.encode(message)), message);
      message = 'aaaaa';
      codec = ShannonFanoCodec.from(message);
      expect(codec.decode(codec.encode(message)), message);
    });

    test('should work with external dictionary', () {
      const source = 'this is an example of a huffman tree';
      final dictionary = ShannonFanoCodec.createDictionary(source);
      final codec = ShannonFanoCodec.fromDictionary(dictionary);
      final message = random
          .nextItemsFrom(source.split(''), random.nextInt(10) + 20)
          .join();
      expect(message, isNot(source));
      expect(codec.decode(codec.encode(message)), message);
    });

    test('should throw on encoding when dictionary lacks message chars', () {
      const source = 'this is an example of a huffman tree';
      final dictionary = ShannonFanoCodec.createDictionary(source);
      final codec = ShannonFanoCodec.fromDictionary(dictionary);
      repeat(times: 100, () {
        final invalidMessage = '_${random.nextString(20, 30)}_';
        final invalidEncodedMessage = BitArray.fromDataString(invalidMessage);
        expect(() => codec.encode(invalidMessage), throwsStateError);
        expect(() => codec.decode(invalidEncodedMessage), anything);
      });
    });
  });
}
