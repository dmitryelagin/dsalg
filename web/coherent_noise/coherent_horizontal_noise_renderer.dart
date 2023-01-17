import 'dart:math';

import 'package:dsalg/dsalg.dart';

import '../utils/renderer.dart';
import 'coherent_noise_state.dart';

// TODO: refactor, it is nearly the same as vertical one
class CoherentHorizontalNoiseRenderer {
  CoherentHorizontalNoiseRenderer(this._renderer);

  static const _padding = 30;

  final Renderer _renderer;

  void draw(CoherentNoiseState state) {
    final amplitude =
        CoherentNoiseState.baseAmplitude / (_renderer.height - _padding * 2);
    final coords = state.noiseHorizontal;
    final noise = state.shouldCorrectDynamicRange
        ? state.noiseRenderedHorizontal
        : state.noiseInterpolatedHorizontal;
    _renderer.reset();
    _drawTopRuler();
    _drawBottomRuler();
    for (var i = 0; i < coords.length; i += 1) {
      _renderer.drawLargeGrayPoint(
        Point(i * state.noiseSize, coords[i] / amplitude + _padding),
      );
    }
    _renderer.drawRedSegment(
      CombinedSegment.fromPoints([
        for (var i = 0; i < noise.length; i += 1)
          Point(i, noise[i] / amplitude + _padding),
      ]),
    );
  }

  void _drawTopRuler() {
    final topRuler = Line(
      const Point(0, _padding),
      Point(_renderer.width, _padding),
    );
    _renderer.drawGraySegment(topRuler);
  }

  void _drawBottomRuler() {
    final bottomRuler = Line(
      Point(0, _renderer.height - _padding),
      Point(_renderer.width, _renderer.height - _padding),
    );
    _renderer.drawGraySegment(bottomRuler);
  }
}
