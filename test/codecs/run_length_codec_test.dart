import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';

void main() {
  final random = Random();

  group('RunLengthCodec', () {
    test('should encode and decode standard message', () {
      const message = 'aaaabbccaddddb';
      final encodedMessage = [
        Pair('a'.runes.first, 4),
        Pair('b'.runes.first, 2),
        Pair('c'.runes.first, 2),
        Pair('a'.runes.first, 1),
        Pair('d'.runes.first, 4),
        Pair('b'.runes.first, 1),
      ];
      expect(runLengthCodec.encode(message), encodedMessage);
      expect(runLengthCodec.decode(encodedMessage), message);
    });

    test('should properly encode and decode messages', () {
      for (final message in random.nextStringList(10, 1000, 5000)) {
        expect(runLengthCodec.decode(runLengthCodec.encode(message)), message);
      }
    });

    test('should handle empty message and data', () {
      expect(runLengthCodec.encode(''), isEmpty);
      expect(runLengthCodec.decode([]), isEmpty);
    });
  });
}
