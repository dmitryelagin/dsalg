import '../utils/canvas_render_helper.dart';
import 'coherent_noise_render_helper.dart';
import 'coherent_noise_state.dart';

class Coherent2DNoiseRenderer {
  Coherent2DNoiseRenderer(this._renderHelper);

  final CanvasRenderHelper _renderHelper;

  void draw(CoherentNoiseState state) {
    _renderHelper
      ..drawShades(state.noiseRendered)
      ..drawTargetCross(state.target);
  }
}
