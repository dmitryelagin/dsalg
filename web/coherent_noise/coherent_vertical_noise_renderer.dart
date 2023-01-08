import 'dart:math';

import 'package:dsalg/dsalg.dart';

import 'coherent_noise_renderer.dart';
import 'coherent_noise_state.dart';

class CoherentVerticalNoiseRenderer extends CoherentNoiseRenderer {
  CoherentVerticalNoiseRenderer(super.renderer);

  static const _padding = 30;

  @override
  void updateImage(CoherentNoiseState state) {
    final amplitude =
        CoherentNoiseState.baseAmplitude / (renderer.width - _padding * 2);
    final coords = state.noiseVertical;
    final noise = state.shouldCorrectDynamicRange
        ? state.noiseRenderedVertical
        : state.noiseInterpolatedVertical;
    renderer.reset();
    _drawLeftRuler();
    _drawRightRuler();
    for (var i = 0; i < coords.length; i += 1) {
      _drawControlPoint(
        Point(coords[i] / amplitude + _padding, i * state.noiseSize),
      );
    }
    _drawLine(
      CombinedSegment.fromPoints([
        for (var i = 0; i < noise.length; i += 1)
          Point(noise[i] / amplitude + _padding, i),
      ]),
    );
  }

  void _drawControlPoint(Point point) {
    renderer.drawCircle(point, 3, '#ccc');
  }

  void _drawLine(Segment segment) {
    renderer.drawSegment(segment, '#f00');
  }

  void _drawLeftRuler() {
    final leftRuler = Line(
      const Point(_padding, 0),
      Point(_padding, renderer.height),
    );
    renderer.drawSegment(leftRuler, '#ccc');
  }

  void _drawRightRuler() {
    final rightRuler = Line(
      Point(renderer.width - _padding, 0),
      Point(renderer.width - _padding, renderer.height),
    );
    renderer.drawSegment(rightRuler, '#ccc');
  }
}
