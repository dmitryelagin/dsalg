import 'dart:math';

import 'package:dsalg/dsalg.dart';

import '../utils/canvas_render_helper.dart';
import 'coherent_noise_state.dart';

// TODO: refactor, it is nearly the same as vertical one
class CoherentHorizontalNoiseRenderer {
  CoherentHorizontalNoiseRenderer(this._renderHelper);

  static const _padding = 30;

  final CanvasRenderHelper _renderHelper;

  void draw(CoherentNoiseState state) {
    final amplitude = CoherentNoiseState.baseAmplitude /
        (_renderHelper.height - _padding * 2);
    final coords = state.noiseHorizontal;
    final noise = state.shouldCorrectDynamicRange
        ? state.noiseRenderedHorizontal
        : state.noiseInterpolatedHorizontal;
    _renderHelper.reset();
    _drawTopRuler();
    _drawBottomRuler();
    for (var i = 0; i < coords.length; i += 1) {
      _renderHelper.drawLargeGrayPoint(
        Point(i * state.noiseSize, coords[i] / amplitude + _padding),
      );
    }
    _renderHelper.drawRedSegment(
      CombinedSegment.fromPoints([
        for (var i = 0; i < noise.length; i += 1)
          Point(i, noise[i] / amplitude + _padding),
      ]),
    );
  }

  void _drawTopRuler() {
    final topRuler = Line(
      const Point(0, _padding),
      Point(_renderHelper.width, _padding),
    );
    _renderHelper.drawGraySegment(topRuler);
  }

  void _drawBottomRuler() {
    final bottomRuler = Line(
      Point(0, _renderHelper.height - _padding),
      Point(_renderHelper.width, _renderHelper.height - _padding),
    );
    _renderHelper.drawGraySegment(bottomRuler);
  }
}
