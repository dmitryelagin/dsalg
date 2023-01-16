import 'dart:html';

import '../utils/element_utils.dart';
import '../utils/renderer.dart';
import 'coherent_2d_noise_renderer.dart';
import 'coherent_horizontal_noise_renderer.dart';
import 'coherent_noise_cubit.dart';
import 'coherent_noise_interpolation_type.dart';
import 'coherent_noise_random_type.dart';
import 'coherent_vertical_noise_renderer.dart';

final _canvasHorizontal = select<CanvasElement>('#target-horizontal');
final _canvasVertical = select<CanvasElement>('#target-vertical');
final _canvas2D = select<CanvasElement>('#target-2d');
final _noiseSizeInput = select<InputElement>('#noise-size-input');
final _correctRangeInput = select<InputElement>('#correct-dynamic-range');
final _randomTypeText = select<SpanElement>('#random-type-value');
final _interpTypeText = select<SpanElement>('#interp-type-value');
final _speedText = select<SpanElement>('#speed-value');

final _renderer2D = Renderer(_canvas2D);

final _noiseHorizontalController =
    CoherentHorizontalNoiseRenderer(Renderer(_canvasHorizontal));
final _noiseVerticalController =
    CoherentVerticalNoiseRenderer(Renderer(_canvasVertical));
final _noise2DController = Coherent2DNoiseRenderer(_renderer2D);

void main() {
  final cubit = CoherentNoiseCubit(
    outputWidth: _renderer2D.width,
    outputHeight: _renderer2D.height,
    noiseSize: _noiseSizeInput.value!,
  )..onChange.listen((state) {
      _noiseSizeInput.value = state.noiseSize.toString();
      _randomTypeText.text = state.randomType.name;
      _interpTypeText.text = state.interpolationType.name;
      _correctRangeInput.checked = state.shouldCorrectDynamicRange;
      _noiseHorizontalController.draw(state);
      _noiseVerticalController.draw(state);
      _noise2DController.draw(state);
    });

  _noise2DController.onDrawFinish.listen((speed) {
    _speedText.text = speed.toString();
  });

  _noiseSizeInput.addEventListener('input', (_) {
    cubit.updateSize(_noiseSizeInput.value!);
  });
  _correctRangeInput.addEventListener('input', (_) {
    cubit.updateDynamicRangeCorrection(
      shouldCorrectDynamicRange: _correctRangeInput.checked,
    );
  });

  _renderer2D.onClick.listen(cubit.updateTarget);

  onButtonClick('#use-standard-random', () {
    cubit.updateRandomType(CoherentNoiseRandomType.standard);
  });
  onButtonClick('#use-limited-random', () {
    cubit.updateRandomType(CoherentNoiseRandomType.limitedDouble);
  });
  onButtonClick('#apply-integer-interp', () {
    cubit.updateInterpolationType(CoherentNoiseInterpolationType.integer);
  });
  onButtonClick('#apply-linear-interp', () {
    cubit.updateInterpolationType(CoherentNoiseInterpolationType.linear);
  });
  onButtonClick('#apply-cubic-interp', () {
    cubit.updateInterpolationType(CoherentNoiseInterpolationType.cubic);
  });
  onButtonClick('#apply-cubic-s-interp', () {
    cubit.updateInterpolationType(CoherentNoiseInterpolationType.cubicS);
  });
  onButtonClick('#apply-cosine-s-interp', () {
    cubit.updateInterpolationType(CoherentNoiseInterpolationType.cosineS);
  });
  onButtonClick('#apply-quintic-s-interp', () {
    cubit.updateInterpolationType(CoherentNoiseInterpolationType.quinticS);
  });
}
