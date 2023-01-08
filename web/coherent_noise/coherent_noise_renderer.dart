import 'dart:async';
import '../utils/renderer.dart';
import 'coherent_noise_state.dart';

abstract class CoherentNoiseRenderer {
  CoherentNoiseRenderer(this.renderer);

  final Renderer renderer;

  final _onDraw = StreamController<int>(sync: true);

  Stream<int> get onDrawFinish => _onDraw.stream;

  void draw(CoherentNoiseState noise) {
    final start = DateTime.now().millisecondsSinceEpoch;
    updateImage(noise);
    _onDraw.add(DateTime.now().millisecondsSinceEpoch - start);
  }

  void updateImage(CoherentNoiseState noise);

  void destroy() {
    _onDraw.close();
  }
}
