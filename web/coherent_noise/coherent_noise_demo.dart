import 'dart:html';

import '../utils/base_bloc.dart';
import '../utils/element_utils.dart';
import '../utils/renderer.dart';
import 'coherent_2d_noise_renderer.dart';
import 'coherent_horizontal_noise_renderer.dart';
import 'coherent_noise_bloc.dart';
import 'coherent_noise_bloc_events.dart';
import 'coherent_noise_state.dart';
import 'coherent_vertical_noise_renderer.dart';

final _noiseSizeInput = select<InputElement>('#noise-size-input');
final _correctRangeInput = select<InputElement>('#correct-dynamic-range');

final _randomTypeText = select('#random-type-value');
final _interpTypeText = select('#interp-type-value');
final _speedText = select('#speed-value');

final _renderer2D = Renderer(select('#target-2d'));

final _noiseHorizontalRenderer =
    CoherentHorizontalNoiseRenderer(Renderer(select('#target-horizontal')));
final _noiseVerticalRenderer =
    CoherentVerticalNoiseRenderer(Renderer(select('#target-vertical')));
final _noise2DRenderer = Coherent2DNoiseRenderer(_renderer2D);

void _draw(StateChanged<CoherentNoiseState> event) {
  _noiseSizeInput.value = event.state.noiseSize.toString();
  _randomTypeText.text = event.state.randomType.name;
  _interpTypeText.text = event.state.interpolationType.name;
  _speedText.text = event.processDuration.toString();
  _correctRangeInput.checked = event.state.shouldCorrectDynamicRange;
  _noiseHorizontalRenderer.draw(event.state);
  _noiseVerticalRenderer.draw(event.state);
  _noise2DRenderer.draw(event.state);
}

void main() {
  final bloc = CoherentNoiseBloc(_renderer2D.width, _renderer2D.height)
    ..onChange.listen(_draw)
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

  _renderer2D.onClick.listen((target) => bloc.add(UpdateTarget(target)));

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
