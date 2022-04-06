import '../bits/bit_array.dart';
import '../collections/stack.dart';
import '../trees/binary_heap.dart';
import '../trees/binary_tree/binary_tree.dart';

const huffmanCodec = HuffmanCodec._();

class HuffmanCodec {
  factory HuffmanCodec() => huffmanCodec;

  const HuffmanCodec._();

  static const _noneKey = -1;

  HuffmanMessage encode(String message) {
    assert(message.isNotEmpty);
    final unitCounters = <int, int>{};
    for (final unit in message.codeUnits) {
      unitCounters[unit] = (unitCounters[unit] ?? 0) + 1;
    }
    final unitNodes = BinaryHeap(
      _compareUnitNode,
      unitCounters.entries.map(BinaryNode<int, int>.fromMapEntry),
    );
    while (unitNodes.length > 1) {
      final first = unitNodes.extract(), second = unitNodes.extract();
      final node = _createUtilityUnitNode(first.value + second.value)
        ..left = first
        ..right = second;
      unitNodes.insert(node);
    }
    final dictionary = _createDictionary(unitNodes.extract());
    return HuffmanMessage(
      dictionary,
      BitArray.from([
        for (final unit in message.codeUnits) ...?dictionary[unit],
      ]),
    );
  }

  String decode(HuffmanMessage message) {
    assert(message.dictionary.isNotEmpty && message.data.isNotEmpty);
    final unitNode = _createUnitTree(message.dictionary);
    final buffer = StringBuffer();
    var node = unitNode;
    for (var i = message.data.length - 1; i >= 0; i -= 1) {
      node = message.data[i] ? node.right! : node.left!;
      if (node.hasNoChildren) {
        buffer.writeCharCode(node.value);
        node = unitNode;
      }
    }
    return buffer.toString();
  }

  Map<int, Iterable<bool>> _createDictionary(BinaryNode<int, int> node) =>
      Map.fromEntries(
        _createDictionaryEntries(
          node,
          Stack(node.hasNoChildren ? const [false] : const []),
        ),
      );

  Iterable<MapEntry<int, Iterable<bool>>> _createDictionaryEntries(
    BinaryNode<int, int> node,
    Stack<bool> path,
  ) sync* {
    if (node.hasNoChildren) {
      yield MapEntry(node.key, path.items.toList().reversed);
    } else {
      if (node.hasLeft) {
        path.insert(false);
        yield* _createDictionaryEntries(node.left!, path);
        path.extract();
      }
      if (node.hasRight) {
        path.insert(true);
        yield* _createDictionaryEntries(node.right!, path);
        path.extract();
      }
    }
  }

  BinaryNode<int, int> _createUnitTree(Map<int, Iterable<bool>> dictionary) {
    final root = _createUtilityUnitNode();
    var node = root;
    for (final unit in dictionary.keys) {
      for (final isRight in dictionary[unit]!) {
        node = isRight
            ? node.right ??= _createUtilityUnitNode()
            : node.left ??= _createUtilityUnitNode();
      }
      node.value = unit;
      node = root;
    }
    return root;
  }

  BinaryNode<int, int> _createUtilityUnitNode([int value = 0]) =>
      BinaryNode(_noneKey, value);

  int _compareUnitNode(BinaryNode<int, int> a, BinaryNode<int, int> b) =>
      b.value.compareTo(a.value);
}

class HuffmanMessage {
  const HuffmanMessage(this.dictionary, this.data);

  final Map<int, Iterable<bool>> dictionary;
  final BitArray data;
}
