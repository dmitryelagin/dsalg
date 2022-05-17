import 'dart:html';
import 'dart:math';

import 'package:dsalg/dsalg.dart';

import '../utils/element_utils.dart';
import '../utils/renderer.dart';
import 'coherent_1d_noise_controller.dart';
import 'coherent_2d_noise_controller.dart';
import 'limited_double_random.dart';

final _canvas1D = select<CanvasElement>('#target-1d');
final _canvas2D = select<CanvasElement>('#target-2d');
final _noiseSizeInput = select<InputElement>('#noise-size-input');
final _correctRangeInput = select<InputElement>('#correct-dynamic-range');
final _randomTypeText = select<SpanElement>('#random-type-value');
final _interp1DTypeText = select<SpanElement>('#interp-1d-type-value');
final _interp2DTypeText = select<SpanElement>('#interp-2d-type-value');
final _speed1DText = select<SpanElement>('#speed-1d-value');
final _speed2DText = select<SpanElement>('#speed-2d-value');

final _noise1DController = Coherent1DNoiseController(Renderer(_canvas1D));
final _noise2DController = Coherent2DNoiseController(Renderer(_canvas2D));

void main() {
  _initNoise();
  _noise1DController
    ..onDrawFinish.listen(_update1D)
    ..generate()
    ..draw();
  _noise2DController
    ..onDrawFinish.listen(_update2D)
    ..generate()
    ..draw();
  _noiseSizeInput.addEventListener('input', (_) {
    _updateNoiseSize(_noiseSizeInput.value!);
  });
  _correctRangeInput.addEventListener('input', (_) {
    _updateDynamicRange(_correctRangeInput.checked ?? false);
  });
  onButtonClick('#use-standard-random', () {
    _updateRandom(Random());
  });
  onButtonClick('#use-limited-random', () {
    _updateRandom(LimitedDoubleRandom());
  });
  onButtonClick('#apply-integer-interp', () {
    _updateInterp(Interpolator1D.integer, Interpolator2D.biInteger);
  });
  onButtonClick('#apply-linear-interp', () {
    _updateInterp(Interpolator1D.linear, Interpolator2D.biLinear);
  });
  onButtonClick('#apply-cubic-s-interp', () {
    _updateInterp(Interpolator1D.cubicS, Interpolator2D.biCubicS);
  });
  onButtonClick('#apply-cosine-s-interp', () {
    _updateInterp(Interpolator1D.cosineS, Interpolator2D.biCosineS);
  });
  onButtonClick('#apply-quintic-s-interp', () {
    _updateInterp(Interpolator1D.quinticS, Interpolator2D.biQuinticS);
  });
  onButtonClick('#apply-cubic-interp', () {
    _updateInterp(Interpolator1D.cubicCached(), Interpolator2D.biCubicCached());
  });
}

void _initNoise() {
  _updateRandom(Random(), true);
  _updateNoiseSize(_noiseSizeInput.value!);
  _updateDynamicRange(_correctRangeInput.checked ?? false, true);
  _updateInterp(Interpolator1D.integer, Interpolator2D.biInteger, true);
}

void _update1D(int speed) {
  _speed1DText.text = speed.toString();
}

void _update2D(int speed) {
  _speed2DText.text = speed.toString();
}

void _updateRandom(Random random, [bool isInit = false]) {
  _noise1DController.randomInput = random;
  _noise2DController.randomInput = random;
  _randomTypeText.text = _getRandomType(random);
  if (isInit) return;
  _noise1DController
    ..generate()
    ..draw();
  _noise2DController
    ..generate()
    ..draw();
}

void _updateNoiseSize(String noiseSize) {
  _noise1DController.sizeInput = noiseSize;
  _noise2DController.sizeInput = noiseSize;
}

void _updateDynamicRange(bool isCorrectedDynamicRange, [bool isInit = false]) {
  _noise1DController.isCorrectedDynamicRangeInput = isCorrectedDynamicRange;
  _noise2DController.isCorrectedDynamicRangeInput = isCorrectedDynamicRange;
  if (isInit) return;
  _noise1DController.draw();
  _noise2DController.draw();
}

void _updateInterp(
  Interpolator1D interpolator1d,
  Interpolator2D interpolator2d, [
  bool isInit = false,
]) {
  _noise1DController.interpolatorInput = interpolator1d;
  _noise2DController.interpolatorInput = interpolator2d;
  _interp1DTypeText.text =
      _getInterpolation1DType(_noise1DController.interpolatorInput);
  _interp2DTypeText.text =
      _getInterpolation2DType(_noise2DController.interpolatorInput);
  if (isInit) return;
  _noise1DController.draw();
  _noise2DController.draw();
}

String _getRandomType(Random random) {
  if (random is LimitedDoubleRandom) return 'limited-shade';
  return 'standard';
}

String _getInterpolation1DType(Interpolator1D interpolator) {
  if (interpolator == Interpolator1D.integer) return 'integer';
  if (interpolator == Interpolator1D.linear) return 'linear';
  if (interpolator == Interpolator1D.cubicS) return 'cubic-s';
  if (interpolator == Interpolator1D.cosineS) return 'cosine-s';
  if (interpolator == Interpolator1D.quinticS) return 'quintic-s';
  return 'cubic';
}

String _getInterpolation2DType(Interpolator2D interpolator) {
  if (interpolator == Interpolator2D.biInteger) return 'bi-integer';
  if (interpolator == Interpolator2D.biLinear) return 'bi-linear';
  if (interpolator == Interpolator2D.biCubicS) return 'bi-cubic-s';
  if (interpolator == Interpolator2D.biCosineS) return 'bi-cosine-s';
  if (interpolator == Interpolator2D.biQuinticS) return 'bi-quintic-s';
  return 'bi-cubic';
}
