import 'dart:math';

import 'package:dsalg/dsalg.dart';

import '../utils/canvas_render_helper.dart';
import 'elementary_cellular_automaton_state.dart';

extension ElementaryCellularAutomationRenderHelper on CanvasRenderHelper {
  void drawAutomationRule(ElementaryCellularAutomationState state) {
    drawShades(
      _multiplyValues(
        _cutValues(_reverseValues(state.rule), state.width, state.height),
        state.dotSize,
      ).toUint8ClampedList(),
    );
  }

  List<List<int>> _reverseValues(List<List<int>> values) =>
      values.map((items) => items.reversed.toList()).toList();

  Iterable<List<int>> _cutValues(
    List<List<int>> values,
    int width,
    int height,
  ) sync* {
    for (var j = 0; j < min(height, values.length); j += 1) {
      final items = values[j], result = <int>[];
      final start = width < items.length ? (items.length - width) ~/ 2 : 0;
      for (var i = start; i < start + min(width, items.length); i += 1) {
        result.add(items[i]);
      }
      yield result;
    }
  }

  Iterable<int> _multiplyValues(
    Iterable<Iterable<int>> values,
    int times,
  ) sync* {
    for (final items in values) {
      for (var i = 0; i < times; i += 1) {
        for (final item in items) {
          for (var j = 0; j < times; j += 1) {
            yield item;
          }
        }
      }
    }
  }
}
