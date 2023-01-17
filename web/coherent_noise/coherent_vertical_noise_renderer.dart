import 'dart:math';

import 'package:dsalg/dsalg.dart';

import '../utils/canvas_render_helper.dart';
import 'coherent_noise_render_helper.dart';
import 'coherent_noise_state.dart';

// TODO: refactor, it is nearly the same as horizontal one
class CoherentVerticalNoiseRenderer {
  CoherentVerticalNoiseRenderer(this._renderHelper);

  static const _padding = 30;

  final CanvasRenderHelper _renderHelper;

  void draw(CoherentNoiseState state) {
    final amplitude = _renderHelper.verticalAmplitude;
    final coords = state.noiseVertical;
    final noise = state.shouldCorrectDynamicRange
        ? state.noiseRenderedVertical
        : state.noiseInterpolatedVertical;
    _renderHelper
      ..reset()
      ..drawLeftRuler()
      ..drawRightRuler();
    for (var i = 0; i < coords.length; i += 1) {
      _renderHelper.drawControlPoint(
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
}
