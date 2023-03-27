import 'elementary_cellular_automaton_state_type.dart';

abstract class ElementaryCellularAutomationBlocEvent {}

class UpdateRule implements ElementaryCellularAutomationBlocEvent {
  const UpdateRule(this.value);

  final String value;
}

class UpdateStateType implements ElementaryCellularAutomationBlocEvent {
  const UpdateStateType(this.type);

  static const blank =
      UpdateStateType(ElementaryCellularAutomationStateType.blank);
  static const centralDot =
      UpdateStateType(ElementaryCellularAutomationStateType.centralDot);
  static const random =
      UpdateStateType(ElementaryCellularAutomationStateType.random);

  final ElementaryCellularAutomationStateType type;
}
