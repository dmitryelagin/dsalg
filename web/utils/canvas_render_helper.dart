import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:dsalg/src/geometry/segment.dart';

class CanvasRenderHelper {
  CanvasRenderHelper(this._canvas) : _context = _canvas.context2D {
    _canvas
      ..style.width = '${width}px'
      ..style.height = '${height}px'
      ..width = width * ratio
      ..height = height * ratio
      ..addEventListener('click', (event) {
        if (event is! PointerEvent) return;
        final rect = _canvas.getBoundingClientRect();
        _onClick.add(
          Point(
            (event.client.x - rect.left) * ratio,
            (event.client.y - rect.top) * ratio,
          ),
        );
      });
  }

  static const defaultRadius = 1, defaultColor = '#000';

  final CanvasElement _canvas;
  final CanvasRenderingContext2D _context;

  final _onClick = StreamController<Point<num>>.broadcast();

  int get ratio => window.devicePixelRatio.toInt();

  int get width => _canvas.width!;
  int get height => _canvas.height!;

  Stream<Point<num>> get onClick => _onClick.stream;

  void drawCircle(
    Point center, [
    num radius = defaultRadius,
    String style = defaultColor,
  ]) {
    _context
      ..fillStyle = style
      ..beginPath()
      ..arc(center.x, center.y, radius * ratio, 0, 2 * pi)
      ..fill();
  }

  void drawSegment(
    Segment segment, [
    String style = defaultColor,
  ]) {
    final controlPoints = segment.getPointsByMagnitude(10);
    _context
      ..strokeStyle = style
      ..lineWidth = ratio
      ..beginPath()
      ..moveTo(controlPoints.first.x, controlPoints.first.y);
    for (final controlPoint in controlPoints.skip(1)) {
      _context.lineTo(controlPoint.x, controlPoint.y);
    }
    _context.stroke();
  }

  void drawShades(List<int> data) {
    final image = _context.getImageData(0, 0, width, height);
    var index = 0;
    for (var i = 0; i < data.length; i += 1) {
      image
        ..data[index + 0] = 0
        ..data[index + 1] = 0
        ..data[index + 2] = 0
        ..data[index + 3] = data[i];
      index += 4;
    }
    _context.putImageData(image, 0, 0);
  }

  void reset() {
    _context.clearRect(0, 0, width, height);
  }

  void destroy() {
    _onClick.close();
  }
}
