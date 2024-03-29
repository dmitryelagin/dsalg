import '../../helpers/bisect.dart';
import '../../helpers/code_unit_frequencies.dart';
import '../../utils/list_utils.dart';
import '../../utils/map_utils.dart';
import 'prefix_codec.dart';
import 'prefix_unit_node.dart';

const shannonFanoDictionaryFactory = ShannonFanoDictionaryFactory();

class ShannonFanoDictionaryFactory {
  const ShannonFanoDictionaryFactory();

  PrefixDictionary createFrom(String input) {
    assert(input.isNotEmpty);
    return _createDictionary(_createUnitTree(input));
  }

  PrefixUnitNode<Iterable<bool>> _createUnitTree(String input) {
    final unitCounters = input.codeUnitFrequencies;
    if (unitCounters.length == 1) {
      return PrefixUnitNode(unitCounters.keys.first, const []);
    } else {
      final units = unitCounters.keys.toList()..sortDesc(unitCounters.get);
      return _createUnitNodes(const [], units, unitCounters.get);
    }
  }

  PrefixUnitNode<Iterable<bool>> _createUnitNodes(
    Iterable<bool> path,
    List<int> units,
    int Function(int) getMass,
  ) {
    final (left, right) = units.bisectByMass(getMass);
    final leftPath = path.followedBy(const [false]);
    final rightPath = path.followedBy(const [true]);
    return PrefixUnitNode.utility(path)
      ..left = left.length == 1
          ? PrefixUnitNode(left.first, leftPath)
          : _createUnitNodes(leftPath, left.toList(), getMass)
      ..right = right.length == 1
          ? PrefixUnitNode(right.first, rightPath)
          : _createUnitNodes(rightPath, right.toList(), getMass);
  }

  PrefixDictionary _createDictionary(PrefixUnitNode<Iterable<bool>> root) =>
      Map.fromEntries(_createDictionaryEntries(root));

  Iterable<PrefixDictionaryEntry> _createDictionaryEntries(
    PrefixUnitNode<Iterable<bool>> node,
  ) sync* {
    if (node.hasNoChildren) {
      yield node.toMapEntry();
    } else {
      yield* _createDictionaryEntries(node.left!);
      yield* _createDictionaryEntries(node.right!);
    }
  }
}
