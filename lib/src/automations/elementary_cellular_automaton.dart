import '../bits/bit_array.dart';
import '../bits/bit_mask.dart';
import '../utils/list_utils.dart';

Iterable<BitArray> computeRule(
  int number, {
  required Iterable<bool> initialState,
  RuleOverflowStrategy overflowStrategy = RuleOverflowStrategy.constantFalse,
  int length = 1000,
  int? size,
}) sync* {
  final actualSize = size ?? initialState.length;
  assert(number >= 0 && number < 256 && length > 0 && actualSize > 0);
  var previousState = BitArray.from(
    initialState.followedBy(
      Iterable.generate(actualSize - initialState.length, (_) => false),
    ),
  );
  yield previousState;
  for (var i = 1; i < length; i += 1) {
    yield previousState = BitArray.generate(actualSize, (x) {
      final targetBitIndex = 0
          .assignBit(0, value: overflowStrategy.getItem(previousState, x - 1))
          .assignBit(1, value: previousState[x])
          .assignBit(2, value: overflowStrategy.getItem(previousState, x + 1));
      return number[targetBitIndex];
    });
  }
}

enum RuleOverflowStrategy {
  constantFalse(_getConstFalse),
  constantTrue(_getConstTrue),
  terminal(_getTerminal),
  cyclic(_getCyclic);

  const RuleOverflowStrategy(this.getItem);

  final bool Function(BitArray, int) getItem;
}

bool _getConstFalse(BitArray state, int i) => state.getSafeConst(i, false);
bool _getConstTrue(BitArray state, int i) => state.getSafeConst(i, true);
bool _getTerminal(BitArray state, int i) => state.getSafeTerminal(i);
bool _getCyclic(BitArray state, int i) => state.getSafeCyclic(i);
