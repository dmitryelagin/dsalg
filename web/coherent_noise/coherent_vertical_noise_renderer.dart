import 'dart:math';

import 'package:dsalg/dsalg.dart';

import '../utils/canvas_render_helper.dart';
import 'coherent_noise_state.dart';

// TODO: refactor, it is nearly the same as horizontal one
class CoherentVerticalNoiseRenderer {
  CoherentVerticalNoiseRenderer(this._renderHelper);

  static const _padding = 30;

  final CanvasRenderHelper _renderHelper;

  void draw(CoherentNoiseState state) {
    final amplitude =
        CoherentNoiseState.baseAmplitude / (_renderHelper.width - _padding * 2);
    final coords = state.noiseVertical;
    final noise = state.shouldCorrectDynamicRange
        ? state.noiseRenderedVertical
        : state.noiseInterpolatedVertical;
    _renderHelper.reset();
    _drawLeftRuler();
    _drawRightRuler();
    for (var i = 0; i < coords.length; i += 1) {
      _renderHelper.drawLargeGrayPoint(
        Point(coords[i] / amplitude + _padding, i * state.noiseSize),
      );
    }
    _renderHelper.drawRedSegment(
      CombinedSegment.fromPoints([
        for (var i = 0; i < noise.length; i += 1)
          Point(noise[i] / amplitude + _padding, i),
      ]),
    );
  }

  void _drawLeftRuler() {
    final leftRuler = Line(
      const Point(_padding, 0),
      Point(_padding, _renderHelper.height),
    );
    _renderHelper.drawGraySegment(leftRuler);
  }

  void _drawRightRuler() {
    final rightRuler = Line(
      Point(_renderHelper.width - _padding, 0),
      Point(_renderHelper.width - _padding, _renderHelper.height),
    );
    _renderHelper.drawGraySegment(rightRuler);
  }
}
