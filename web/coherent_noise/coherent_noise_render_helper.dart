import 'dart:math';

import 'package:dsalg/dsalg.dart';

import '../utils/canvas_render_helper.dart';
import 'coherent_noise_state.dart';

extension CoherentNoiseRenderHelper on CanvasRenderHelper {
  static const baseAmplitude = 256, padding = 30;

  void drawHorizontalNoise(CoherentNoiseState state) {
    final amplitude = baseAmplitude / (height - padding * 2);
    final coords = state.noiseHorizontal;
    final noise = state.shouldCorrectDynamicRange
        ? state.noiseRenderedHorizontal
        : state.noiseInterpolatedHorizontal;
    reset();
    drawTopRuler();
    drawBottomRuler();
    for (var i = 0; i < coords.length; i += 1) {
      drawControlPoint(
        Point(i * state.noiseSize, coords[i] / amplitude + padding),
      );
    }
    drawRedSegment(
      CombinedSegment.fromPoints([
        for (var i = 0; i < noise.length; i += 1)
          Point(i, noise[i] / amplitude + padding),
      ]),
    );
  }

  void drawTopRuler() {
    drawRuler(Line(const Point(0, padding), Point(width, padding)));
  }

  void drawBottomRuler() {
    drawRuler(Line(Point(0, height - padding), Point(width, height - padding)));
  }

  void drawVerticalNoise(CoherentNoiseState state) {
    final amplitude = baseAmplitude / (width - padding * 2);
    final coords = state.noiseVertical;
    final noise = state.shouldCorrectDynamicRange
        ? state.noiseRenderedVertical
        : state.noiseInterpolatedVertical;
    reset();
    drawLeftRuler();
    drawRightRuler();
    for (var i = 0; i < coords.length; i += 1) {
      drawControlPoint(
        Point(coords[i] / amplitude + padding, i * state.noiseSize),
      );
    }
    drawRedSegment(
      CombinedSegment.fromPoints([
        for (var i = 0; i < noise.length; i += 1)
          Point(noise[i] / amplitude + padding, i),
      ]),
    );
  }

  void drawLeftRuler() {
    drawRuler(Line(const Point(padding, 0), Point(padding, height)));
  }

  void drawRightRuler() {
    drawRuler(Line(Point(width - padding, 0), Point(width - padding, height)));
  }

  void draw2DNoise(CoherentNoiseState state) {
    drawShades(state.noiseRendered);
    drawTargetCross(state.target);
  }

  void drawTargetCross(Point<int> target) {
    drawRedSegment(Line(Point(target.x, 0), Point(target.x, width)));
    drawRedSegment(Line(Point(0, target.y), Point(height, target.y)));
  }

  void drawControlPoint(Point point) {
    drawCircle(point, 3, '#ccc');
  }

  void drawRedSegment(Segment segment) {
    drawSegment(segment, '#f00');
  }

  void drawRuler(Segment segment) {
    drawSegment(segment, '#ccc');
  }
}
