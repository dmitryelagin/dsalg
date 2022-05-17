import 'dart:math';

import 'package:dsalg/dsalg.dart';

import 'coherent_noise_controller.dart';

class Coherent1DNoiseController extends CoherentNoiseController {
  Coherent1DNoiseController(super.renderer)
      : _upperRuler = Line(
          const Point(0, _padding),
          Point(renderer.width, _padding),
        ),
        _lowerRuler = Line(
          Point(0, renderer.height - _padding),
          Point(renderer.width, renderer.height - _padding),
        ),
        _amplitude = renderer.height - _padding * 2;

  static const _padding = 40;
  static const _noiseWidth = 2, _pointSize = 3, _rulerWidth = 1;
  static const _noiseColor = '#f00', _infoColor = '#ccc';

  final Line _upperRuler, _lowerRuler;
  final int _amplitude;

  late Interpolator1D interpolatorInput;

  late Iterable<double> _noise;

  void generate() {
    _noise = randomInput.nextCoherent1DValueNoise(width);
  }

  @override
  void updateImage() {
    renderer
      ..reset()
      ..drawSegment(_upperRuler, _rulerWidth, _infoColor)
      ..drawSegment(_lowerRuler, _rulerWidth, _infoColor);
    var coords = [
      for (var i = 0; i < renderer.width; i += 1)
        interpolatorInput.interpolate(_noise, i / size) * _amplitude + _padding,
    ];
    if (isCorrectedDynamicRangeInput) {
      coords = coords.mapDynamicRange(_padding, _padding + _amplitude).toList();
    }
    final controlPoints = [
      for (var i = 0; i < _noise.length; i += 1)
        Point(i * size, coords[min(i * size, coords.length - 1)]),
    ];
    for (final point in controlPoints) {
      renderer.drawPoint(point, _pointSize, _infoColor);
    }
    renderer.drawSegment(
      CombinedSegment.fromPoints([
        for (var i = 0; i < coords.length; i += 1) Point(i, coords[i]),
      ]),
      _noiseWidth,
      _noiseColor,
    );
  }
}
