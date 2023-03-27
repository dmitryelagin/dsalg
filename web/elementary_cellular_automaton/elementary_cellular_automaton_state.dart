import 'elementary_cellular_automaton_state_type.dart';

class ElementaryCellularAutomationState {
  const ElementaryCellularAutomationState({
    required this.width,
    required this.height,
    required this.dotSize,
    required this.initialStateType,
    required this.initialState,
    required this.ruleNumber,
    required this.rule,
  });

  factory ElementaryCellularAutomationState.from(
    ElementaryCellularAutomationState state, {
    int? width,
    int? height,
    int? dotSize,
    ElementaryCellularAutomationStateType? initialStateType,
    Iterable<bool>? initialState,
    int? ruleNumber,
    List<List<int>>? rule,
  }) =>
      ElementaryCellularAutomationState(
        width: width ?? state.width,
        height: height ?? state.height,
        dotSize: dotSize ?? state.dotSize,
        initialStateType: initialStateType ?? state.initialStateType,
        initialState: initialState ?? state.initialState,
        ruleNumber: ruleNumber ?? state.ruleNumber,
        rule: rule ?? state.rule,
      );

  factory ElementaryCellularAutomationState.initial(
    int width,
    int height,
    int dotSize,
  ) =>
      ElementaryCellularAutomationState(
        width: width,
        height: height,
        dotSize: dotSize,
        initialStateType: ElementaryCellularAutomationStateType.centralDot,
        initialState: [],
        ruleNumber: 0,
        rule: [],
      );

  final ElementaryCellularAutomationStateType initialStateType;

  final Iterable<bool> initialState;

  final int ruleNumber, width, height, dotSize;

  final List<List<int>> rule;

  int get ruleLength => height;

  int get ruleSize => ruleLength * 3;
}
