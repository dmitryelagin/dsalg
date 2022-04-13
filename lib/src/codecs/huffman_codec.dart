import '../bits/bit_array.dart';
import '../collections/stack.dart';
import '../trees/binary_heap.dart';
import '../trees/binary_tree/base_binary_node.dart';

class HuffmanCodec {
  HuffmanCodec(this._dictionary) : assert(_dictionary.isNotEmpty);

  factory HuffmanCodec.from(String message) =>
      HuffmanCodec(createDictionary(message));

  final Map<int, Iterable<bool>> _dictionary;

  _UnitNode? _unitTreeCache;

  _UnitNode get _unitTree =>
      _unitTreeCache ?? _UnitNode.fromDictionary(_dictionary);

  static Map<int, Iterable<bool>> createDictionary(String message) =>
      _UnitNode.fromString(message).toDictionary();

  BitArray encode(String message) {
    assert(message.isNotEmpty);
    return BitArray.from(
      message.codeUnits.expand(
        (unit) => _dictionary[unit] ?? getMissedDictionaryValue(unit),
      ),
    );
  }

  String decode(BitArray message) {
    assert(message.isNotEmpty);
    final buffer = StringBuffer();
    var node = _unitTree;
    for (var i = message.length - 1; i >= 0; i -= 1) {
      node = message[i] ? node.right! : node.left!;
      if (node.hasNoChildren) {
        buffer.writeCharCode(node.value);
        node = _unitTree;
      }
    }
    return buffer.toString();
  }

  Iterable<bool> getMissedDictionaryValue(int unit) {
    final char = String.fromCharCode(unit);
    throw StateError('Missing unit $unit ($char) in codec dictionary');
  }
}

class _UnitNode extends BaseBinaryNode<int, int, _UnitNode> {
  _UnitNode.fromEntry(MapEntry<int, int> entry) : super(entry.key, entry.value);

  _UnitNode.utility([int value = 0]) : super(-1, value);

  factory _UnitNode.fromString(String message) {
    assert(message.isNotEmpty);
    final unitCounters = <int, int>{};
    for (final unit in message.codeUnits) {
      unitCounters[unit] = (unitCounters[unit] ?? 0) + 1;
    }
    final unitNodes = BinaryHeap<_UnitNode>(
      (a, b) => b.value.compareTo(a.value),
      unitCounters.entries.map(_UnitNode.fromEntry),
    );
    while (unitNodes.length > 1) {
      final first = unitNodes.extract(), second = unitNodes.extract();
      final node = _UnitNode.utility(first.value + second.value)
        ..left = first
        ..right = second;
      unitNodes.insert(node);
    }
    return unitNodes.extract();
  }

  factory _UnitNode.fromDictionary(Map<int, Iterable<bool>> dictionary) {
    final root = _UnitNode.utility();
    var node = root;
    for (final unit in dictionary.keys) {
      for (final isRight in dictionary[unit]!) {
        node = isRight
            ? node.right ??= _UnitNode.utility()
            : node.left ??= _UnitNode.utility();
      }
      node.value = unit;
      node = root;
    }
    return root;
  }

  Map<int, Iterable<bool>> toDictionary() {
    final path = Stack<bool>(hasNoChildren ? const [false] : const []);
    Iterable<MapEntry<int, Iterable<bool>>> _createDictionaryEntries(
      _UnitNode node,
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
