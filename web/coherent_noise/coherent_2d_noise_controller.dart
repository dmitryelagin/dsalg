import 'package:dsalg/dsalg.dart';

import 'coherent_noise_controller.dart';

class Coherent2DNoiseController extends CoherentNoiseController {
  Coherent2DNoiseController(super.renderer);

  late Interpolator2D interpolatorInput;

  late Iterable<Iterable<double>> _noise;

  void generate() {
    _noise = randomInput.nextCoherent2DValueNoise(width, height);
  }

  @override
  void updateImage() {
    var shades = Iterable.generate(renderer.width, (x) {
      return Iterable.generate(renderer.height, (y) {
        return interpolatorInput.interpolate(_noise, x / size, y / size);
      });
    });
    if (isCorrectedDynamicRangeInput) shades = shades.mapDynamicRange(0, 1);
    renderer.drawAlpha(shades);
  }
}
