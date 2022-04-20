import 'dart:convert';

import '../bits/bit_array.dart';
import '../collections/stack.dart';
import '../helpers/code_unit_frequencies.dart';
import '../trees/binary_heap.dart';
import 'base_unit_codec.dart';

class HuffmanCodec extends Codec<String, BitArray> {
  const HuffmanCodec(this.encoder, this.decoder);

  HuffmanCodec.fromDictionary(UnitDictionary dictionary)
      : assert(dictionary.isNotEmpty),
        encoder = HuffmanEncoder(dictionary),
        decoder = HuffmanDecoder.fromDictionary(dictionary);

  factory HuffmanCodec.from(String message) =>
      HuffmanCodec.fromDictionary(createDictionary(message));

  static UnitDictionary createDictionary(String message) =>
      _HuffmanNode.fromString(message).toDictionary();

  @override
  final HuffmanEncoder encoder;

  @override
  final HuffmanDecoder decoder;
}

class HuffmanEncoder extends BaseUnitEncoder {
  HuffmanEncoder(super.dictionary);
}

class HuffmanDecoder extends BaseUnitDecoder<_HuffmanNode> {
  HuffmanDecoder.fromDictionary(UnitDictionary dictionary)
      : assert(dictionary.isNotEmpty),
        super(_HuffmanNode.fromDictionary(dictionary));
}

class _HuffmanNode extends BaseUnitNode<int, _HuffmanNode> {
  _HuffmanNode.fromEntry(MapEntry<int, int> entry)
      : super(entry.key, entry.value);

  _HuffmanNode.utility([int value = 0]) : super(-1, value);

  factory _HuffmanNode.fromString(String message) {
    assert(message.isNotEmpty);
    final unitCounters = message.codeUnitFrequencies;
    final unitNodes = BinaryHeap<_HuffmanNode>(
      (a, b) => b.value.compareTo(a.value),
      unitCounters.entries.map(_HuffmanNode.fromEntry),
    );
    while (unitNodes.length > 1) {
      final first = unitNodes.extract(), second = unitNodes.extract();
      final node = _HuffmanNode.utility(first.value + second.value)
        ..left = first
        ..right = second;
      unitNodes.insert(node);
    }
    return unitNodes.extract();
  }

  factory _HuffmanNode.fromDictionary(UnitDictionary dictionary) =>
      BaseUnitNode.fromDictionary(_HuffmanNode.utility, dictionary);

  UnitDictionary toDictionary() {
    final path = Stack<bool>(hasNoChildren ? const [false] : const []);
    Iterable<UnitDictionaryEntry> _createDictionaryEntries(
      _HuffmanNode node,
    ) sync* {
      if (node.hasNoChildren) {
        yield MapEntry(node.key, path.items.toList().reversed);
      } else {
        if (node.hasLeft) {
          path.insert(false);
          yield* _createDictionaryEntries(node.left!);
          path.extract();
        }
        if (node.hasRight) {
          path.insert(true);
          yield* _createDictionaryEntries(node.right!);
          path.extract();
        }
      }
    }

    return Map.fromEntries(_createDictionaryEntries(this));
  }
}
