import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';
import '../utils/iterable_utils.dart';
import '../utils/random_utils.dart';
import '../utils/test_utils.dart';

void main() {
  final random = Random();

  group('DiceRoll', () {
    test('should properly roll provided die many times', () {
      for (final die in Die.standardDice) {
        final amount = random.nextInt(10) + 1;
        expect(random.nextRoll(die, amount: amount).length, amount);
      }
      final amount = random.nextInt(10) + 1;
      expect(random.nextNdsRoll('${amount}d8').length, amount);
    });
  });

  group('Die', () {
    test('should properly parse NdS notation', () {
      repeat(times: 10, () {
        final n = random.nextInt(100) + 1, s = random.nextInt(100) + 1;
        expect(Die.tryParseNds('${n}d$s'), (n, Die(s)));
        expect(Die.parseNds('${n}d$s'), (n, Die(s)));
      });
    });

    test('should properly fail when NdS notation is not correct', () {
      const invalidValues = [
        ...['-1d2', '1d-2', '1.2d2', '1d2.1', '1v2', 'ad3', '1da', '1dd2'],
        ...['1 d2', '1d 2', ' 1d2', '1d2 '],
      ];
      for (final invalidValue in invalidValues) {
        expect(Die.tryParseNds(invalidValue), isNull);
        expect(() => Die.parseNds(invalidValue), throwsFormatException);
      }
    });

    test('should determine if die is uniform fair', () {
      final dice = random.nextIntList(10, 100, 1).map(Die.new);
      for (final die in [...Die.standardDice, ...dice]) {
        expect(die.isUniformFair, isTrue);
      }
      final unequalChances = [...random.nextIntList(10, 100, 1), 101];
      expect(Die.fromChances(unequalChances).isUniformFair, isFalse);
    });

    test('should roll fair die with correct chances', () {
      final die = Die.d6;
      final sideIndexes = List.generate(die.max, (i) => i);
      final customRandom = LoopRandomMock(sideIndexes.toList()..shuffle());
      final counters = {for (final index in sideIndexes) index + 1: 0};
      for (var i = 0; i < die.max * 100; i += 1) {
        final value = die.roll(customRandom);
        counters[value] = counters[value]! + 1;
      }
      expect(counters.values.everyIsEqual(), isTrue);
    });

    test('should roll unfair die with correct chances', () {
      final chances = random.nextIntSet(6, 100).toList();
      final die = Die.fromChances(chances);
      final sideIndexes = List.generate(die.max, (i) => i);
      var boundary = 0;
      final values = sideIndexes.map((i) => chances[i]).expand((chance) {
        final parts = List.generate(chance, (_) {
          return random.nextInt(chance) + boundary;
        });
        boundary += chance;
        return parts;
      });
      final customRandom = LoopRandomMock(values.toList()..shuffle());
      final counters = {for (final index in sideIndexes) index + 1: 0};
      for (var i = 0; i < values.length; i += 1) {
        final value = die.roll(customRandom);
        counters[value] = counters[value]! + 1;
      }
      expect(counters.values, chances);
    });
  });
}
