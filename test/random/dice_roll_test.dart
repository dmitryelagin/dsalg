import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';
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
        expect(Die.tryParseNds('${n}d$s'), Pair(n, Die(s)));
        expect(Die.parseNds('${n}d$s'), Pair(n, Die(s)));
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
      repeat(times: 10, () {
        const rollsAmount = 100000, delta = 1000;
        final equalChanceDie = Die.d4;
        final counters = {for (var i = 0; i < 4; i += 1) i + 1: 0};
        for (var i = 0; i < rollsAmount; i += 1) {
          final value = equalChanceDie.roll(random);
          counters[value] = counters[value]! + 1;
        }
        expect((counters[1]! - counters[2]!).abs(), lessThan(delta));
        expect((counters[2]! - counters[3]!).abs(), lessThan(delta));
        expect((counters[3]! - counters[4]!).abs(), lessThan(delta));
        expect((counters[1]! - counters[3]!).abs(), lessThan(delta));
        expect((counters[1]! - counters[4]!).abs(), lessThan(delta));
        expect((counters[2]! - counters[4]!).abs(), lessThan(delta));
      });
    });

    test('should roll unfair die with correct chances', () {
      repeat(times: 100, () {
        const rollsAmount = 10000;
        final chances = Map.fromIterables(
          List.generate(4, (index) => index + 1),
          random.nextIntSet(4, 10).map((value) => value * 100),
        );
        final unequalChanceDie = Die.fromChances(chances.values);
        final counters = {for (var i = 0; i < 4; i += 1) i + 1: 0};
        for (var i = 0; i < rollsAmount; i += 1) {
          final value = unequalChanceDie.roll(random);
          counters[value] = counters[value]! + 1;
        }
        expect(counters[1]! > counters[2]!, chances[1]! > chances[2]!);
        expect(counters[2]! < counters[3]!, chances[2]! < chances[3]!);
        expect(counters[3]! < counters[4]!, chances[3]! < chances[4]!);
        expect(counters[1]! > counters[3]!, chances[1]! > chances[3]!);
        expect(counters[1]! < counters[4]!, chances[1]! < chances[4]!);
        expect(counters[2]! < counters[4]!, chances[2]! < chances[4]!);
      });
    });
  });
}
