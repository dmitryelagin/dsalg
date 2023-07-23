import 'dart:math';

import 'package:dsalg/dsalg.dart';

import '../utils/base_bloc.dart';
import 'elementary_cellular_automaton_bloc_events.dart';
import 'elementary_cellular_automaton_state.dart';
import 'elementary_cellular_automaton_state_type.dart';

class ElementaryCellularAutomationBloc extends BaseBloc<
    ElementaryCellularAutomationState, ElementaryCellularAutomationBlocEvent> {
  ElementaryCellularAutomationBloc(int width, int height, int dotSize)
      : super(
          ElementaryCellularAutomationState.initial(width, height, dotSize),
        ) {
    on(_updateRule);
    on(_updateStateType);
  }

  void _updateRule(
    BlocStateChange<ElementaryCellularAutomationState> change,
    UpdateRule event,
  ) {
    final ruleNumber = int.tryParse(event.value);
    if (ruleNumber == null ||
        ruleNumber < 0 ||
        ruleNumber > 255 ||
        ruleNumber == state.ruleNumber) {
      change();
    } else {
      change(
        ElementaryCellularAutomationState.from(
          state,
          ruleNumber: ruleNumber,
          rule: _generateRule(
            ruleNumber: ruleNumber,
            initialState: state.initialState.isEmpty
                ? _getInitialState()
                : state.initialState,
          ),
        ),
      );
    }
  }

  void _updateStateType(
    BlocStateChange<ElementaryCellularAutomationState> change,
    UpdateStateType event,
  ) {
    final initialState = _getInitialState(event.type);
    final rule = _generateRule(initialState: initialState);
    change(
      ElementaryCellularAutomationState.from(
        state,
        initialStateType: event.type,
        initialState: initialState,
        rule: rule,
      ),
    );
  }

  List<List<int>> _generateRule({
    int? ruleNumber,
    Iterable<bool>? initialState,
  }) =>
      computeRule(
        ruleNumber ?? state.ruleNumber,
        size: state.ruleSize,
        initialState: initialState ?? state.initialState,
        overflowStrategy: RuleOverflowStrategy.cyclic,
      )
          .take(state.ruleLength)
          .map((list) => list.map((item) => item ? 255 : 0).toList())
          .toList();

  Iterable<bool> _getInitialState([
    ElementaryCellularAutomationStateType? type,
  ]) =>
      switch (type ?? state.initialStateType) {
        ElementaryCellularAutomationStateType.blank => [],
        ElementaryCellularAutomationStateType.centralDot => Iterable.generate(
            state.ruleSize,
            (i) => i == state.ruleSize ~/ 2,
          ),
        ElementaryCellularAutomationStateType.random => Iterable.generate(
            state.ruleSize,
            (_) => Random().nextBool(),
          ),
      };
}
