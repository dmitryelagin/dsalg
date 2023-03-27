import 'dart:math';

import 'package:dsalg/dsalg.dart';
import 'package:dsalg/src/utils/iterable_utils.dart';
import 'package:test/test.dart';

import '../utils/data_utils.dart';
import '../utils/matchers.dart';

void main() {
  final random = Random();

  group('ElementaryCellularAutomaton', () {
    const ruleLength = 300, centralDotIndex = ruleLength;
    final centralDotInitialState = List.filled(ruleLength * 2 + 1, false);
    centralDotInitialState[centralDotIndex] = true;

    Iterable<BitArray> computeRuleFromCentralDot(int number) => computeRule(
          number,
          initialState: centralDotInitialState,
          length: ruleLength,
        );

    Iterable<int> computeRuleValuesFromCentralDot(int number) sync* {
      final rule = computeRuleFromCentralDot(number).toList();
      for (var i = 0; i < rule.length; i += 1) {
        final value = rule[i], bits = value.bits.toList();
        var result = 0;
        for (var j = 0; j < 48; j += 1) {
          result = result.assignBit(j, value: bits[centralDotIndex - i + j]);
        }
        yield result;
      }
    }

    test('should throw when rule is not in [0, 255] range', () {
      expect(() => computeRuleFromCentralDot(-1000), throwsAssertionError);
      expect(() => computeRuleFromCentralDot(-1), throwsAssertionError);
      expect(() => computeRuleFromCentralDot(256), throwsAssertionError);
      expect(() => computeRuleFromCentralDot(25600), throwsAssertionError);
      expect(() => computeRuleFromCentralDot(0), isNot(throwsAssertionError));
      expect(() => computeRuleFromCentralDot(255), isNot(throwsAssertionError));
    });

    test('should throw when length or size are too small', () {
      expect(
        () => computeRule(0, initialState: []),
        throwsAssertionError,
      );
      expect(
        () => computeRule(0, initialState: centralDotInitialState, size: 0),
        throwsAssertionError,
      );
      expect(
        () => computeRule(0, initialState: centralDotInitialState, size: -1),
        throwsAssertionError,
      );
      expect(
        () => computeRule(0, initialState: centralDotInitialState, length: 0),
        throwsAssertionError,
      );
      expect(
        () => computeRule(0, initialState: centralDotInitialState, length: -1),
        throwsAssertionError,
      );
    });

    test('should return rule with expected length', () {
      final length = random.nextInt(100) + 1;
      expect(
        computeRule(
          random.nextInt(256),
          initialState: centralDotInitialState,
          length: length,
        ),
        hasLength(length),
      );
    });

    test('should return rule with expected size', () {
      final length = random.nextInt(100) + 1;
      expect(
        computeRule(
          random.nextInt(256),
          initialState: random.nextBoolList(length),
        ).elementAt(random.nextInt(3) + 1),
        hasLength(length),
      );
    });

    test('should return rule with initial state as first element', () {
      expect(
        computeRule(
          random.nextInt(256),
          initialState: centralDotInitialState,
          length: 1001,
        ).first.startsWith(centralDotInitialState),
        isTrue,
      );
    });

    test('should return same result for some rules with central dot state', () {
      expect(computeRuleFromCentralDot(28), computeRuleFromCentralDot(156));
      final ruleFromCentralDot50 = computeRuleFromCentralDot(50);
      expect(ruleFromCentralDot50, computeRuleFromCentralDot(58));
      expect(ruleFromCentralDot50, computeRuleFromCentralDot(114));
      expect(ruleFromCentralDot50, computeRuleFromCentralDot(122));
      expect(ruleFromCentralDot50, computeRuleFromCentralDot(178));
      expect(ruleFromCentralDot50, computeRuleFromCentralDot(186));
      expect(ruleFromCentralDot50, computeRuleFromCentralDot(242));
      expect(ruleFromCentralDot50, computeRuleFromCentralDot(250));
      final ruleFromCentralDot90 = computeRuleFromCentralDot(90);
      expect(ruleFromCentralDot90, computeRuleFromCentralDot(18));
      expect(ruleFromCentralDot90, computeRuleFromCentralDot(26));
      expect(ruleFromCentralDot90, computeRuleFromCentralDot(82));
      expect(ruleFromCentralDot90, computeRuleFromCentralDot(146));
      expect(ruleFromCentralDot90, computeRuleFromCentralDot(154));
      expect(ruleFromCentralDot90, computeRuleFromCentralDot(210));
      expect(ruleFromCentralDot90, computeRuleFromCentralDot(218));
      expect(computeRuleFromCentralDot(220), computeRuleFromCentralDot(252));
      expect(computeRuleFromCentralDot(222), computeRuleFromCentralDot(254));
    });

    test('should return properly computed values', () {
      expect(
        computeRuleValuesFromCentralDot(28).take(8),
        [1, 3, 5, 11, 21, 43, 85, 171],
      );
      expect(
        computeRuleValuesFromCentralDot(50).take(8),
        [1, 5, 21, 85, 341, 1365, 5461, 21845],
      );
      expect(
        computeRuleValuesFromCentralDot(54).take(8),
        [1, 7, 17, 119, 273, 1911, 4369, 30583],
      );
      expect(
        computeRuleValuesFromCentralDot(60).take(8),
        [1, 3, 5, 15, 17, 51, 85, 255],
      );
      expect(
        computeRuleValuesFromCentralDot(90).take(8),
        [1, 5, 17, 85, 257, 1285, 4369, 21845],
      );
      expect(
        computeRuleValuesFromCentralDot(94).take(8),
        [1, 7, 27, 119, 427, 1879, 6827, 30039],
      );
      expect(
        computeRuleValuesFromCentralDot(102).take(8),
        [1, 6, 20, 120, 272, 1632, 5440, 32640],
      );
      expect(
        computeRuleValuesFromCentralDot(110).take(10),
        [1, 6, 28, 104, 496, 1568, 7360, 27520, 130304, 396800],
      );
      expect(
        computeRuleValuesFromCentralDot(150).take(8),
        [1, 7, 21, 107, 273, 1911, 5189, 28123],
      );
      expect(
        computeRuleValuesFromCentralDot(158).take(8),
        [1, 7, 29, 115, 477, 1843, 7645, 29491],
      );
      expect(
        computeRuleValuesFromCentralDot(188).take(8),
        [1, 3, 5, 15, 29, 55, 93, 247],
      );
      expect(
        computeRuleValuesFromCentralDot(190).take(8),
        [1, 7, 29, 119, 477, 1911, 7645, 30583],
      );
      expect(
        computeRuleValuesFromCentralDot(220).take(8),
        [1, 3, 7, 15, 31, 63, 127, 255],
      );
      expect(
        computeRuleValuesFromCentralDot(222).take(8),
        [1, 7, 31, 127, 511, 2047, 8191, 32767],
      );
    });
  });
}
