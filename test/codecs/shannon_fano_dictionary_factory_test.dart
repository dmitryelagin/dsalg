import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';
import '../utils/matchers.dart';

void main() {
  final random = Random();

  Iterable<bool> getBinaryPath(String path) =>
      path.split('').map((rune) => rune == '1');

  group('ShannonFanoDictionaryFactory', () {
    const dictionaryFactory = shannonFanoDictionaryFactory;

    test('should produce valid dictionary for message', () {
      final message = ([
        ...List.filled(22, 'A'),
        ...List.filled(28, 'B'),
        ...List.filled(15, 'C'),
        ...List.filled(30, 'D'),
        ...List.filled(5, 'E'),
      ]..shuffle(random))
          .join();
      final targetDictionary = const {
        'D': '00',
        'B': '01',
        'A': '10',
        'C': '110',
        'E': '111',
      }.map((key, value) => MapEntry(key.runes.first, getBinaryPath(value)));
      final dictionary = dictionaryFactory.createFrom(message);
      expect(dictionary, targetDictionary);
    });

    test('should produce correct dictionary for standard small case', () {
      const message = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
          'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
          'cccccccccccccccccccc'
          'ddddd';
      final referenceDictionary = {'a': '0', 'b': '10', 'c': '110', 'd': '111'}
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
