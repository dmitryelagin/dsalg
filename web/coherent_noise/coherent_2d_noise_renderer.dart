import 'dart:math';

import 'package:dsalg/dsalg.dart';

import '../utils/canvas_render_helper.dart';
import 'coherent_noise_state.dart';

class Coherent2DNoiseRenderer {
  Coherent2DNoiseRenderer(this._renderHelper);

  final CanvasRenderHelper _renderHelper;

  void draw(CoherentNoiseState state) {
    _renderHelper.drawShades(state.noiseRendered);
    _drawTargetCross(state.target);
  }

  void _drawTargetCross(Point<int> target) {
    final horizontalLine = Line(
      Point(target.x, 0),
      Point(target.x, _renderHelper.width),
    );
    final verticalLine = Line(
      Point(0, target.y),
      Point(_renderHelper.height, target.y),
    );
    _renderHelper
      ..drawRedSegment(horizontalLine)
      ..drawRedSegment(verticalLine);
  }
}
