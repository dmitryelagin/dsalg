import 'dart:math';

import '../utils/iterable_utils.dart';

extension DiceRoll on Random {
  List<int> nextRoll(Die die, {int amount = 1}) =>
      [for (var i = 0; i < amount; i += 1) die.roll(this)];

  List<int> nextNdsRoll(String nds) {
    final (amount, die) = Die.parseNds(nds);
    return nextRoll(die, amount: amount);
  }
}

class Die {
  factory Die(int sides) {
    assert(sides > 0);
    return standardDice.firstWhere(
      (die) => die._boundary == sides,
      orElse: () => Die._(List.filled(sides, 1), sides),
    );
  }

  factory Die.fromChances(Iterable<int> chances) {
    assert(chances.isNotEmpty);
    return Die._(chances.toList(), chances.sum.toInt());
  }

  Die._(this._chances, this._boundary)
      : hashCode = Object.hashAll([..._chances, _boundary]);

  static const min = 1;

  static final standardDice = [...platonicSolidDice, d10];
  static final platonicSolidDice = [d4, d6, d8, d12, d20];

  static final d4 = Die._(_fourChances, 4);
  static final d6 = Die._([..._fourChances, ..._twoChances], 6);
  static final d8 = Die._([..._fourChances, ..._fourChances], 8);
  static final d10 = Die._(_tenChances, 10);
  static final d12 = Die._([..._tenChances, ..._twoChances], 12);
  static final d20 = Die._([..._tenChances, ..._tenChances], 20);

  static const _baseChance = 1;
  static const _twoChances = [_baseChance, _baseChance];
  static const _fourChances = [..._twoChances, ..._twoChances];
  static const _tenChances = [..._fourChances, ..._fourChances, ..._twoChances];

  static final _ndsPattern = RegExp(r'^(\d+)d(\d+)$');

  @override
  final int hashCode;

  final List<int> _chances;
  final int _boundary;

  int get max => _chances.length;

  bool get isUniformFair => _chances.everyIsEqual();

  static (int amount, Die) parseNds(String nds) =>
      tryParseNds(nds) ?? (throw FormatException(nds));

  static (int amount, Die)? tryParseNds(String nds) {
    final match = _ndsPattern.matchAsPrefix(nds);
    return match != null
        ? (int.parse(match[1]!), Die(int.parse(match[2]!)))
        : null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Die &&
          _boundary == other._boundary &&
          _chances.isDeepEqualTo(other._chances);

  int roll(Random random) {
    final target = random.nextInt(_boundary);
    var sum = 0, index = -1;
    while (sum <= target) {
      index += 1;
      sum += _chances[index];
    }
    return index + 1;
  }
}
