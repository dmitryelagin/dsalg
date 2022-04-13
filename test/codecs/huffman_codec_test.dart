import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';

void main() {
  final random = Random();

  Iterable<bool> getBinaryPath(String path) =>
      path.split('').map((rune) => rune == '1');

  group('HuffmanCodec', () {
    test('should encode standard message', () {
      const message = 'A_DEAD_DAD_CEDED_A_BAD_BABE_A_BEADED_ABACA_BED';
      final targetDictionary = {
        '_': '00',
        'D': '01',
        'A': '10',
        'E': '110',
        'C': '1110',
        'B': '1111',
      }.map((key, value) => MapEntry(key.runes.first, getBinaryPath(value)));
      final encodedMessage = [
        '0000000000000100',
        '0011101001000110',
        '0100111011001110',
        '0100100011111001',
        '0011111011111100',
        '0100011111101001',
        '1100100101111101',
        '1101000111111001',
      ].map((value) => int.parse(value, radix: 2));
      final dictionary = HuffmanCodec.createDictionary(message);
      final result = HuffmanCodec(dictionary).encode(message);
      expect(dictionary, targetDictionary);
      expect(result.toDataString(), String.fromCharCodes(encodedMessage));
    });

    test('should produce same path lengths as in reference dictionary', () {
      const message = 'this is an example of a huffman tree';
      final referenceDictionary = {
        ...{' ': '111', 'a': '010', 'e': '000', 'f': '1101'},
        ...{'h': '1010', 'i': '1000', 'm': '0111', 'n': '0010'},
        ...{'s': '1011', 't': '0110', 'l': '11001', 'o': '00110'},
        ...{'p': '10011', 'r': '11000', 'u': '00111', 'x': '10010'},
      }.map((key, value) => MapEntry(key.runes.first, getBinaryPath(value)));
      expect(
        HuffmanCodec.createDictionary(message)
            .map((key, value) => MapEntry(key, value.length)),
        referenceDictionary.map((key, value) => MapEntry(key, value.length)),
      );
    });

    test('should produce correct dictionary for standard small case', () {
      const message = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
          'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
          'cccccccccccccccccccc'
          'ddddd';
      final referenceDictionary = {'a': '0', 'b': '11', 'c': '101', 'd': '100'}
          .map((key, value) => MapEntry(key.runes.first, getBinaryPath(value)));
      expect(HuffmanCodec.createDictionary(message), referenceDictionary);
    });

    test('should decode standard message', () {
      const message = 'A_DEAD_DAD_CEDED_A_BAD_BABE_A_BEADED_ABACA_BED';
      final codec = HuffmanCodec.from(message);
      expect(codec.decode(codec.encode(message)), message);
    });

    test('should properly encode and decode messages', () {
      for (final message in random.nextStringList(50, 100, 500)) {
        final codec = HuffmanCodec.from(message);
        expect(codec.decode(codec.encode(message)), message);
      }
    });

    test('should throw on empty message', () {
      final codec = HuffmanCodec.from(random.nextString(10, 20));
      expect(
        () => codec.encode(''),
        throwsA(const TypeMatcher<AssertionError>()),
      );
      expect(
        () => codec.decode(BitArray()),
        throwsA(const TypeMatcher<AssertionError>()),
      );
    });

    test('should handle message with one symbol', () {
      var message = 'a';
      var codec = HuffmanCodec.from(message);
      expect(codec.decode(codec.encode(message)), message);
      message = 'aaaaa';
      codec = HuffmanCodec.from(message);
      expect(codec.decode(codec.encode(message)), message);
    });

    test('should work with external dictionary', () {
      const source = 'this is an example of a huffman tree';
      final dictionary = HuffmanCodec.createDictionary(source);
      final codec = HuffmanCodec(dictionary);
      final message = random
          .nextItemsFrom(source.split(''), random.nextInt(10) + 20)
          .join();
      expect(message, isNot(source));
      expect(codec.decode(codec.encode(message)), message);
    });

    test('should throw on encoding when dictionary lacks message chars', () {
      const source = 'this is an example of a huffman tree';
      final dictionary = HuffmanCodec.createDictionary(source);
      final codec = HuffmanCodec(dictionary);
      for (var i = 0; i < 100; i += 1) {
        final invalidMessage = '_${random.nextString(20, 30)}_';
        final invalidEncodedMessage = BitArray.fromDataString(invalidMessage);
        expect(() => codec.encode(invalidMessage), throwsStateError);
        expect(() => codec.decode(invalidEncodedMessage), anything);
      }
    });
  });
}
