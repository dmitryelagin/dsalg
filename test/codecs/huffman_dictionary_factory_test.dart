import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';
import '../utils/matchers.dart';

void main() {
  final random = Random();

  Iterable<bool> getBinaryPath(String path) =>
      path.split('').map((rune) => rune == '1');

  group('HuffmanDictionaryFactory', () {
    final dictionaryFactory = HuffmanDictionaryFactory();

    test('should produce valid dictionary for message', () {
      const message = 'A_DEAD_DAD_CEDED_A_BAD_BABE_A_BEADED_ABACA_BED';
      final targetDictionary = const {
        '_': '00',
        'D': '01',
        'A': '10',
        'E': '110',
        'C': '1110',
        'B': '1111',
      }.map((key, value) => MapEntry(key.runes.first, getBinaryPath(value)));
      final dictionary = dictionaryFactory.createFrom(message);
      expect(dictionary, targetDictionary);
    });

    test('should produce same path lengths as in reference dictionary', () {
      const message = 'this is an example of a huffman tree';
      final referenceDictionary = const {
        ...{' ': '111', 'a': '010', 'e': '000', 'f': '1101'},
        ...{'h': '1010', 'i': '1000', 'm': '0111', 'n': '0010'},
        ...{'s': '1011', 't': '0110', 'l': '11001', 'o': '00110'},
        ...{'p': '10011', 'r': '11000', 'u': '00111', 'x': '10010'},
      }.map((key, value) => MapEntry(key.runes.first, getBinaryPath(value)));
      expect(
        dictionaryFactory
            .createFrom(message)
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
      expect(dictionaryFactory.createFrom(message), referenceDictionary);
    });

    test('should throw on empty message', () {
      expect(() => dictionaryFactory.createFrom(''), throwsAssertionError);
    });

    test('should handle message with one symbol', () {
      const symbol = 'a';
      final expected = {symbol.codeUnits.first: const <bool>[]};
      for (final item in [symbol, List.filled(5, symbol).join()]) {
        expect(dictionaryFactory.createFrom(item), expected);
      }
    });

    test('should produce dictionary with all symbols from message', () {
      final message = random.nextString(5000, 10000);
      final dictionary = dictionaryFactory.createFrom(message);
      expect(
        Stream.fromIterable(dictionary.keys),
        emitsInAnyOrder(message.codeUnitFrequencies.keys),
      );
    });
  });
}
