import 'dart:math';

import 'package:dsalg/dsalg.dart';

import '../utils/canvas_render_helper.dart';

extension CoherentNoiseRenderHelper on CanvasRenderHelper {
  static const baseAmplitude = 256;
  static const padding = 30, radiusLarge = 3;
  static const grayColor = '#ccc', redColor = '#f00';

  double get horizontalAmplitude => baseAmplitude / (height - padding * 2);
  double get verticalAmplitude => baseAmplitude / (width - padding * 2);

  void drawControlPoint(Point point) {
    drawCircle(point, radiusLarge, grayColor);
  }

  void drawTargetCross(Point<int> target) {
    drawRedSegment(Line(Point(target.x, 0), Point(target.x, width)));
    drawRedSegment(Line(Point(0, target.y), Point(height, target.y)));
  }

  void drawRedSegment(Segment segment) {
    drawSegment(segment, redColor);
  }

  void drawLeftRuler() {
    drawGraySegment(
      Line(const Point(padding, 0), Point(padding, height)),
    );
  }

  void drawRightRuler() {
    drawGraySegment(
      Line(Point(width - padding, 0), Point(width - padding, height)),
    );
  }

  void drawTopRuler() {
    drawGraySegment(
      Line(const Point(0, padding), Point(width, padding)),
    );
  }

  void drawBottomRuler() {
    drawGraySegment(
      Line(Point(0, height - padding), Point(width, height - padding)),
    );
  }

  void drawGraySegment(Segment segment) {
    drawSegment(segment, grayColor);
  }
}
