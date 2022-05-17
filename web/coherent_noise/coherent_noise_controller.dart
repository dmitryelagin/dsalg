import 'dart:async';
import 'dart:math';

import '../utils/renderer.dart';

abstract class CoherentNoiseController {
  CoherentNoiseController(this.renderer);

  final Renderer renderer;

  final _onDraw = StreamController<int>(sync: true);

  var _size = 0;

  late Random randomInput;
  late bool isCorrectedDynamicRangeInput;

  String get sizeInput => _size.toString();

  set sizeInput(String value) {
    final size = int.tryParse(value);
    if (size != _size && size != null && size > 0) {
      _size = size;
    }
  }

  Stream<int> get onDrawFinish => _onDraw.stream;

  int get width => (renderer.width / size).ceil() + 1;
  int get height => (renderer.height / size).ceil() + 1;

  int get size => _size;

  void draw() {
    final start = DateTime.now().millisecondsSinceEpoch;
    updateImage();
    _onDraw.add(DateTime.now().millisecondsSinceEpoch - start);
  }

  void updateImage();

  void destroy() {
    _onDraw.close();
  }
}
