import 'dart:html';
import 'dart:math';

import 'package:dsalg/src/geometry/segment.dart';

class Renderer {
  Renderer(this._canvas) : _context = _canvas.context2D {
    _canvas
      ..style.width = '${width}px'
      ..style.height = '${height}px'
      ..width = width * ratio
      ..height = height * ratio;
  }

  final CanvasElement _canvas;
  final CanvasRenderingContext2D _context;

  int get ratio => window.devicePixelRatio.toInt();

  int get width => _canvas.width!;
  int get height => _canvas.height!;

  void drawPoint(Point point, [num radius = 1, String style = '#000']) {
    _context
      ..fillStyle = style
      ..beginPath()
      ..arc(point.x, point.y, radius * ratio, 0, 2 * pi, true)
      ..fill();
  }

  void drawSegment(Segment segment, [num width = 1, String style = '#000']) {
    final controlPoints = segment.getPointsByMagnitude(10);
    _context
      ..strokeStyle = style
      ..lineWidth = width
      ..beginPath()
      ..moveTo(controlPoints.first.x, controlPoints.first.y);
    for (final controlPoint in controlPoints.skip(1)) {
      _context.lineTo(controlPoint.x, controlPoint.y);
    }
    _context.stroke();
  }

  void drawAlpha(Iterable<Iterable<num>> data) {
    final image = _context.getImageData(0, 0, width, height);
    var x = 0, y = 0;
    for (final row in data) {
      for (final value in row) {
        image.setPixel(x, y, 0, 0, 0, (value * 256).toInt());
        y += 1;
      }
      x += 1;
      y = 0;
    }
    _context.putImageData(image, 0, 0);
  }

  void reset() {
    _context.clearRect(0, 0, width, height);
  }
}

extension _ImageDataUtils on ImageData {
  void setPixel(int x, int y, int r, int g, int b, [int a = 255]) {
    final index = (x + y * width) * 4;
    data[index + 0] = r;
    data[index + 1] = g;
    data[index + 2] = b;
    data[index + 3] = a;
  }
}
