import 'dart:html';

import 'package:dsalg/dsalg.dart';

import 'elementary_cellular_automaton_state.dart';

class ElementaryCellularAutomationLegendHelper {
  const ElementaryCellularAutomationLegendHelper(this._bitMarkers)
      : assert(_bitMarkers.length == 8);

  static const commonClassName = 'demo-eca-legend-item-block';
  static const whiteClassName = 'demo-eca-legend-item-block-white';
  static const blackClassName = 'demo-eca-legend-item-block-black';

  final List<Element> _bitMarkers;

  void markAutomationRuleBits(ElementaryCellularAutomationState state) {
    final bits = state.ruleNumber.bits
        .followedBy(List.filled(_bitMarkers.length, false));
    for (var i = 0; i < _bitMarkers.length; i += 1) {
      final bitMarker = _bitMarkers[i], isSet = bits.elementAt(i);
      bitMarker.className =
          '$commonClassName ${isSet ? blackClassName : whiteClassName}';
    }
  }
}
