import '../../collections/stack.dart';
import '../../helpers/code_unit_frequencies.dart';
import '../../trees/binary_heap.dart';
import 'prefix_codec.dart';
import 'prefix_unit_node.dart';

class HuffmanDictionaryFactory {
  final _path = Stack<bool>();

  PrefixDictionary createFrom(String input) {
    assert(input.isNotEmpty);
    return _createDictionary(_createUnitTree(input));
  }

  PrefixUnitNode<int> _createUnitTree(String input) {
    final unitNodes = BinaryHeap<PrefixUnitNode<int>>(
      (a, b) => b.value.compareTo(a.value),
      input.codeUnitFrequencies.entries.map(PrefixUnitNode.fromEntry),
    );
    while (unitNodes.length > 1) {
      final first = unitNodes.extract(), second = unitNodes.extract();
      final node = PrefixUnitNode.utility(first.value + second.value)
        ..left = first
        ..right = second;
      unitNodes.insert(node);
    }
    return unitNodes.extract();
  }

  PrefixDictionary _createDictionary(PrefixUnitNode<int> root) {
    _path.clear();
    return Map.fromEntries(_createDictionaryEntries(root));
  }

  Iterable<PrefixDictionaryEntry> _createDictionaryEntries(
    PrefixUnitNode<int> node,
  ) sync* {
    if (node.hasNoChildren) {
      yield MapEntry(node.key, _path.items.toList().reversed);
    } else {
      if (node.hasLeft) {
        _path.insert(false);
        yield* _createDictionaryEntries(node.left!);
        _path.extract();
      }
      if (node.hasRight) {
        _path.insert(true);
        yield* _createDictionaryEntries(node.right!);
        _path.extract();
      }
    }
  }
}
