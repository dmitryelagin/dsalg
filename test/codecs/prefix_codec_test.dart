import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';
import '../utils/matchers.dart';

void main() {
  final random = Random();

  Iterable<bool> getBinaryPath(String path) =>
      path.split('').map((rune) => rune == '1');

  group('PrefixCodec', () {
    final alphabet = List.generate(128, String.fromCharCode).join();
    final dictionaryFactories = [
      HuffmanDictionaryFactory().createFrom,
      shannonFanoDictionaryFactory.createFrom,
    ];

    late PrefixCodec codec;

    setUp(() {
      codec = PrefixCodec.fromDictionary(
        dictionaryFactories[random.nextInt(dictionaryFactories.length)](
          alphabet + random.nextString(250, 500),
        ),
      );
    });

    test('should encode and decode standard message', () {
      const message = 'A_DEAD_DAD_CEDED_A_BAD_BABE_A_BEADED_ABACA_BED';
      final dictionary = const {
        '_': '00',
        'D': '01',
        'A': '10',
        'E': '110',
        'C': '1110',
        'B': '1111',
      }.map((key, value) => MapEntry(key.runes.first, getBinaryPath(value)));
      final encodedMessage = const [
        '0000000000000100',
        '0011101001000110',
        '0100111011001110',
        '0100100011111001',
        '0011111011111100',
        '0100011111101001',
        '1100100101111101',
        '1101000111111001',
      ].map((value) => int.parse(value, radix: 2));
      codec = PrefixCodec.fromDictionary(dictionary);
      final result = codec.encode(message);
      expect(result.toDataString(), String.fromCharCodes(encodedMessage));
      expect(codec.decode(result), message);
    });

    test('should properly encode and decode messages', () {
      for (final message in random.nextStringList(50, 100, 500)) {
        expect(codec.decode(codec.encode(message)), message);
      }
    });

    test('should throw on empty message', () {
      expect(() => codec.encode(''), throwsAssertionError);
      expect(() => codec.decode(BitArray()), throwsAssertionError);
    });

    test('should handle message with one symbol', () {
      var message = 'a';
      expect(codec.decode(codec.encode(message)), message);
      message = 'aaaaa';
      expect(codec.decode(codec.encode(message)), message);
    });

    test('should throw on encoding when dictionary lacks message chars', () {
      final invalidMessage =
          '${String.fromCharCode(255)}${random.nextString(20, 30, 256)}';
      final invalidEncodedMessage = BitArray.fromDataString(invalidMessage);
      expect(() => codec.encode(invalidMessage), throwsStateError);
      expect(() => codec.decode(invalidEncodedMessage), anything);
    });
  });
}
