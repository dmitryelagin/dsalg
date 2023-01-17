import 'dart:math';

import 'package:dsalg/dsalg.dart';

import '../utils/renderer.dart';
import 'coherent_noise_state.dart';

class Coherent2DNoiseRenderer {
  Coherent2DNoiseRenderer(this._renderer);

  final Renderer _renderer;

  void draw(CoherentNoiseState state) {
    _renderer.drawShades(state.noiseRendered);
    _drawTargetCross(state.target);
  }

  void _drawTargetCross(Point<int> target) {
    final horizontalLine = Line(
      Point(target.x, 0),
      Point(target.x, _renderer.width),
    );
    final verticalLine = Line(
      Point(0, target.y),
      Point(_renderer.height, target.y),
    );
    _renderer
      ..drawRedSegment(horizontalLine)
      ..drawRedSegment(verticalLine);
  }
}
