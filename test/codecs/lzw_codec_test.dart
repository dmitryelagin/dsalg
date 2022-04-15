import 'dart:async';
import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';

void main() {
  final random = Random();

  group('LzwCodec', () {
    test('should encode and decode standard message', () {
      const message = 'TOBEORNOTTOBEORTOBEORNOT';
      const expectedEncodedMessage = [
        ...[84, 79, 66, 69, 79, 82, 78, 79, 84],
        ...[256, 258, 260, 265, 259, 261, 263],
      ];
      final encodedMessage = lzwCodec.encode(message);
      expect(encodedMessage, expectedEncodedMessage);
      expect(lzwCodec.decode(encodedMessage), message);
    });

    test('should properly encode and decode messages', () {
      for (final message in random.nextStringList(10, 1000, 5000)) {
        expect(lzwCodec.decode(lzwCodec.encode(message)), message);
      }
    });

    test('should properly encode and decode message with UTF-16 symbols', () {
      final messages = random.nextStringList(10, 1000, 5000, 1 << 15);
      for (final message in messages) {
        expect(lzwCodec.decode(lzwCodec.encode(message)), message);
      }
    });

    test('should handle empty message and return empty value', () {
      expect(lzwCodec.encode(''), isEmpty);
      expect(lzwCodec.decode([]), isEmpty);
    });

    test('should handle message with one symbol', () {
      var message = 'a';
      expect(lzwCodec.decode(lzwCodec.encode(message)), message);
      message = 'aaaaa';
      expect(lzwCodec.decode(lzwCodec.encode(message)), message);
    });

    test('should throw async error on invalid data decoding', () {
      runZonedGuarded(() {
        expect(lzwCodec.decode(const [65, 257]), 'A');
      }, (error, _) {
        expect(error, isArgumentError);
      });
      runZonedGuarded(() {
        const message = 'TOBEORNOTTOBEORTOBEORNOT';
        expect(
          lzwCodec.decode(const [
            ...[84, 79, 66, 69, 79, 82, 78, 79, 84],
            ...[300],
            ...[256, 258, 260, 265, 259, 261, 263],
            ...[300],
          ]),
          message,
        );
      }, (error, _) {
        expect(error, isArgumentError);
      });
    });
  });
}
