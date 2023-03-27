import 'dart:html';

import '../utils/canvas_render_helper.dart';
import '../utils/element_utils.dart';
import 'elementary_cellular_automation_legend_helper.dart';
import 'elementary_cellular_automaton_bloc.dart';
import 'elementary_cellular_automaton_bloc_events.dart';
import 'elementary_cellular_automaton_render_helper.dart';

final _ruleInput = select<InputElement>('#rule-input');

final _stateTypeText = select('#state-type-value');
final _speedText = select('#speed-value');

final _renderHelper = CanvasRenderHelper(select('#target-eca'));

final _legendHelper = ElementaryCellularAutomationLegendHelper([
  select('#legend-eca-marker-0'),
  select('#legend-eca-marker-1'),
  select('#legend-eca-marker-2'),
  select('#legend-eca-marker-3'),
  select('#legend-eca-marker-4'),
  select('#legend-eca-marker-5'),
  select('#legend-eca-marker-6'),
  select('#legend-eca-marker-7'),
]);

void main() {
  const dotSize = 4;
  final bloc = ElementaryCellularAutomationBloc(
    _renderHelper.width ~/ dotSize,
    _renderHelper.height ~/ dotSize,
    dotSize,
  )
    ..onChange.listen((event) {
      _ruleInput.value = event.state.ruleNumber.toString();
      _stateTypeText.text = event.state.initialStateType.name;
      _speedText.text = event.processDuration.toString();
      _legendHelper.markAutomationRuleBits(event.state);
      _renderHelper.drawAutomationRule(event.state);
    })
    ..add(UpdateRule(_ruleInput.value!));

  _ruleInput.addEventListener('input', (_) {
    bloc.add(UpdateRule(_ruleInput.value!));
  });

  select('#use-blank-state').addEventListener('click', (_) {
    bloc.add(UpdateStateType.blank);
  });
  select('#use-central-dot-state').addEventListener('click', (_) {
    bloc.add(UpdateStateType.centralDot);
  });
  select('#use-random-state').addEventListener('click', (_) {
    bloc.add(UpdateStateType.random);
  });
}
