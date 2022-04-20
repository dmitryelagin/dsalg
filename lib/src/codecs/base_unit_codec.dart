import 'dart:convert';

import '../bits/bit_array.dart';
import '../trees/binary_tree/base_binary_node.dart';

typedef UnitDictionary = Map<int, Iterable<bool>>;
typedef UnitDictionaryEntry = MapEntry<int, Iterable<bool>>;

class BaseUnitCodec extends Codec<String, BitArray> {
  const BaseUnitCodec(this.encoder, this.decoder);

  BaseUnitCodec.fromDictionary(UnitDictionary dictionary)
      : assert(dictionary.isNotEmpty),
        encoder = UnitEncoder(dictionary),
        decoder = UnitDecoder(dictionary);

  @override
  final UnitEncoder encoder;

  @override
  final UnitDecoder decoder;
}

class UnitEncoder extends Converter<String, BitArray> {
  UnitEncoder(this._dictionary) : assert(_dictionary.isNotEmpty);

  final UnitDictionary _dictionary;

  @override
  BitArray convert(String input) {
    assert(input.isNotEmpty);
    return BitArray.from(
      input.codeUnits.expand(
        (unit) => _dictionary[unit] ?? getMissedDictionaryValue(unit),
      ),
    );
  }

  Iterable<bool> getMissedDictionaryValue(int unit) {
    final char = String.fromCharCode(unit);
    throw StateError('Missing unit $unit ($char) in encoder dictionary');
  }
}

class UnitDecoder extends Converter<BitArray, String> {
  UnitDecoder(UnitDictionary dictionary)
      : assert(dictionary.isNotEmpty),
        _root = _UnitNode.fromDictionary(dictionary);

  final _UnitNode _root;

  @override
  String convert(BitArray input) {
    assert(input.isNotEmpty);
    final buffer = StringBuffer();
    var node = _root;
    for (var i = input.length - 1; i >= 0; i -= 1) {
      node = input[i] ? node.right! : node.left!;
      if (node.hasNoChildren) {
        buffer.writeCharCode(node.key);
        node = _root;
      }
    }
    return buffer.toString();
  }
}

class _UnitNode extends BaseBinaryNode<int, void, _UnitNode> {
  _UnitNode() : super(-1, null);

  factory _UnitNode.fromDictionary(UnitDictionary dictionary) {
    final root = _UnitNode();
    var node = root;
    for (final unit in dictionary.keys) {
      for (final isRight in dictionary[unit]!) {
        node = isRight ? node.right ??= _UnitNode() : node.left ??= _UnitNode();
      }
      node.key = unit;
      node = root;
    }
    return root;
  }
}
