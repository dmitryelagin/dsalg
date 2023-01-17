import 'dart:html';

import '../utils/element_utils.dart';
import '../utils/renderer.dart';
import 'coherent_2d_noise_renderer.dart';
import 'coherent_horizontal_noise_renderer.dart';
import 'coherent_noise_cubit.dart';
import 'coherent_noise_interpolation_type.dart';
import 'coherent_noise_random_type.dart';
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

void _draw(CoherentNoiseState state) {
  _noiseSizeInput.value = state.noiseSize.toString();
  _randomTypeText.text = state.randomType.name;
  _interpTypeText.text = state.interpolationType.name;
  _correctRangeInput.checked = state.shouldCorrectDynamicRange;
  _noiseHorizontalRenderer.draw(state);
  _noiseVerticalRenderer.draw(state);
  _noise2DRenderer.draw(state);
}

void main() {
  final cubit = CoherentNoiseCubit(
    outputWidth: _renderer2D.width,
    outputHeight: _renderer2D.height,
    noiseSize: _noiseSizeInput.value!,
  )..onChange.listen(_draw);
  _draw(cubit.state);

  _noiseSizeInput.addEventListener('input', (_) {
    cubit.updateSize(_noiseSizeInput.value!);
  });
  _correctRangeInput.addEventListener('input', (_) {
    cubit.updateDynamicRangeCorrection(
      shouldCorrectDynamicRange: _correctRangeInput.checked,
    );
  });

  _renderer2D.onClick.listen(cubit.updateTarget);

  select('#use-standard-random').addEventListener('click', (_) {
    cubit.updateRandomType(CoherentNoiseRandomType.standard);
  });
  select('#use-limited-random').addEventListener('click', (_) {
    cubit.updateRandomType(CoherentNoiseRandomType.limitedDouble);
  });
  select('#apply-integer-interp').addEventListener('click', (_) {
    cubit.updateInterpolationType(CoherentNoiseInterpolationType.integer);
  });
  select('#apply-linear-interp').addEventListener('click', (_) {
    cubit.updateInterpolationType(CoherentNoiseInterpolationType.linear);
  });
  select('#apply-cubic-interp').addEventListener('click', (_) {
    cubit.updateInterpolationType(CoherentNoiseInterpolationType.cubic);
  });
  select('#apply-cubic-s-interp').addEventListener('click', (_) {
    cubit.updateInterpolationType(CoherentNoiseInterpolationType.cubicS);
  });
  select('#apply-cosine-s-interp').addEventListener('click', (_) {
    cubit.updateInterpolationType(CoherentNoiseInterpolationType.cosineS);
  });
  select('#apply-quintic-s-interp').addEventListener('click', (_) {
    cubit.updateInterpolationType(CoherentNoiseInterpolationType.quinticS);
  });
}
