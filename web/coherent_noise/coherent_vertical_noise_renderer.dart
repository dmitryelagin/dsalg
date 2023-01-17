import 'dart:math';

import 'package:dsalg/dsalg.dart';

import '../utils/renderer.dart';
import 'coherent_noise_state.dart';

// TODO: refactor, it is nearly the same as horizontal one
class CoherentVerticalNoiseRenderer {
  CoherentVerticalNoiseRenderer(this._renderer);

  static const _padding = 30;

  final Renderer _renderer;

  void draw(CoherentNoiseState state) {
    final amplitude =
        CoherentNoiseState.baseAmplitude / (_renderer.width - _padding * 2);
    final coords = state.noiseVertical;
    final noise = state.shouldCorrectDynamicRange
        ? state.noiseRenderedVertical
        : state.noiseInterpolatedVertical;
    _renderer.reset();
    _drawLeftRuler();
    _drawRightRuler();
    for (var i = 0; i < coords.length; i += 1) {
      _renderer.drawLargeGrayPoint(
        Point(coords[i] / amplitude + _padding, i * state.noiseSize),
      );
    }
    _renderer.drawRedSegment(
      CombinedSegment.fromPoints([
        for (var i = 0; i < noise.length; i += 1)
          Point(noise[i] / amplitude + _padding, i),
      ]),
    );
  }

  void _drawLeftRuler() {
    final leftRuler = Line(
      const Point(_padding, 0),
      Point(_padding, _renderer.height),
    );
    _renderer.drawGraySegment(leftRuler);
  }

  void _drawRightRuler() {
    final rightRuler = Line(
      Point(_renderer.width - _padding, 0),
      Point(_renderer.width - _padding, _renderer.height),
    );
    _renderer.drawGraySegment(rightRuler);
  }
}
