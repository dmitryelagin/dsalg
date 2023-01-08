import 'dart:math';

import 'package:dsalg/dsalg.dart';

import 'coherent_noise_renderer.dart';
import 'coherent_noise_state.dart';

class CoherentHorizontalNoiseRenderer extends CoherentNoiseRenderer {
  CoherentHorizontalNoiseRenderer(super.renderer);

  static const _padding = 30;

  @override
  void updateImage(CoherentNoiseState state) {
    final amplitude =
        CoherentNoiseState.baseAmplitude / (renderer.height - _padding * 2);
    final coords = state.noiseHorizontal;
    final noise = state.shouldCorrectDynamicRange
        ? state.noiseRenderedHorizontal
        : state.noiseInterpolatedHorizontal;
    renderer.reset();
    _drawTopRuler();
    _drawBottomRuler();
    for (var i = 0; i < coords.length; i += 1) {
      _drawControlPoint(
        Point(i * state.noiseSize, coords[i] / amplitude + _padding),
      );
    }
    _drawLine(
      CombinedSegment.fromPoints([
        for (var i = 0; i < noise.length; i += 1)
          Point(i, noise[i] / amplitude + _padding),
      ]),
    );
  }

  void _drawControlPoint(Point point) {
    renderer.drawCircle(point, 3, '#ccc');
  }

  void _drawLine(Segment segment) {
    renderer.drawSegment(segment, '#f00');
  }

  void _drawTopRuler() {
    final topRuler = Line(
      const Point(0, _padding),
      Point(renderer.width, _padding),
    );
    renderer.drawSegment(topRuler, '#ccc');
  }

  void _drawBottomRuler() {
    final bottomRuler = Line(
      Point(0, renderer.height - _padding),
      Point(renderer.width, renderer.height - _padding),
    );
    renderer.drawSegment(bottomRuler, '#ccc');
  }
}
