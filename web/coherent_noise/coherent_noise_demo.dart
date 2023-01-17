import 'dart:html';

import '../utils/canvas_render_helper.dart';
import '../utils/element_utils.dart';
import 'coherent_noise_bloc.dart';
import 'coherent_noise_bloc_events.dart';
import 'coherent_noise_render_helper.dart';

final _noiseSizeInput = select<InputElement>('#noise-size-input');
final _correctRangeInput = select<InputElement>('#correct-dynamic-range');

final _randomTypeText = select('#random-type-value');
final _interpTypeText = select('#interp-type-value');
final _speedText = select('#speed-value');

final _renderHelperHorizontal = CanvasRenderHelper(select('#target-h'));
final _renderHelperVertical = CanvasRenderHelper(select('#target-v'));
final _renderHelper2D = CanvasRenderHelper(select('#target-2d'));

void main() {
  final bloc = CoherentNoiseBloc(_renderHelper2D.width, _renderHelper2D.height)
    ..onChange.listen((event) {
      _noiseSizeInput.value = event.state.noiseSize.toString();
      _randomTypeText.text = event.state.randomType.name;
      _interpTypeText.text = event.state.interpolationType.name;
      _speedText.text = event.processDuration.toString();
      _correctRangeInput.checked = event.state.shouldCorrectDynamicRange;
      _renderHelperHorizontal.drawHorizontalNoise(event.state);
      _renderHelperVertical.drawVerticalNoise(event.state);
      _renderHelper2D.draw2DNoise(event.state);
    })
    ..add(UpdateSize(_noiseSizeInput.value!));

  _noiseSizeInput.addEventListener('input', (_) {
    bloc.add(UpdateSize(_noiseSizeInput.value!));
  });
  _correctRangeInput.addEventListener('input', (_) {
    bloc.add(
      UpdateDynamicRangeCorrection(
        shouldCorrectDynamicRange: _correctRangeInput.checked,
      ),
    );
  });

  _renderHelperHorizontal.onClick.listen((target) {
    bloc.add(UpdateTarget(Point(target.x, bloc.state.target.y)));
  });
  _renderHelperVertical.onClick.listen((target) {
    bloc.add(UpdateTarget(Point(bloc.state.target.x, target.y)));
  });
  _renderHelper2D.onClick.listen((target) {
    bloc.add(UpdateTarget(target));
  });

  select('#use-standard-random').addEventListener('click', (_) {
    bloc.add(UpdateRandomType.standard);
  });
  select('#use-limited-random').addEventListener('click', (_) {
    bloc.add(UpdateRandomType.limitedDouble);
  });
  select('#apply-integer-interp').addEventListener('click', (_) {
    bloc.add(UpdateInterpolationType.integer);
  });
  select('#apply-linear-interp').addEventListener('click', (_) {
    bloc.add(UpdateInterpolationType.linear);
  });
  select('#apply-cubic-interp').addEventListener('click', (_) {
    bloc.add(UpdateInterpolationType.cubic);
  });
  select('#apply-cubic-s-interp').addEventListener('click', (_) {
    bloc.add(UpdateInterpolationType.cubicS);
  });
  select('#apply-cosine-s-interp').addEventListener('click', (_) {
    bloc.add(UpdateInterpolationType.cosineS);
  });
  select('#apply-quintic-s-interp').addEventListener('click', (_) {
    bloc.add(UpdateInterpolationType.quinticS);
  });
}
