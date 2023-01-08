import 'dart:math';

import 'package:dsalg/dsalg.dart';

import 'coherent_noise_renderer.dart';
import 'coherent_noise_state.dart';

class Coherent2DNoiseRenderer extends CoherentNoiseRenderer {
  Coherent2DNoiseRenderer(super.renderer);

  @override
  void updateImage(CoherentNoiseState state) {
    renderer.drawShades(state.noiseRendered);
    _drawTargetCross(state.target);
  }

  void _drawTargetCross(Point<int> target) {
    final horizontalBar = Line(
      Point(target.x, 0),
      Point(target.x, renderer.width),
    );
    final verticalBar = Line(
      Point(0, target.y),
      Point(renderer.height, target.y),
    );
    renderer
      ..drawSegment(horizontalBar, '#f00')
      ..drawSegment(verticalBar, '#f00');
  }
}
