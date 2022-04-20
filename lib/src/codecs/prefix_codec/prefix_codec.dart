import 'dart:convert';

import '../../bits/bit_array.dart';
import 'prefix_unit_node.dart';

typedef PrefixDictionary = Map<int, Iterable<bool>>;
typedef PrefixDictionaryEntry = MapEntry<int, Iterable<bool>>;

class PrefixCodec extends Codec<String, BitArray> {
  const PrefixCodec(this.encoder, this.decoder);

  PrefixCodec.fromDictionary(PrefixDictionary dictionary)
      : assert(dictionary.isNotEmpty),
        encoder = PrefixEncoder(dictionary),
        decoder = PrefixDecoder(dictionary);

  @override
  final PrefixEncoder encoder;

  @override
  final PrefixDecoder decoder;
}

class PrefixEncoder extends Converter<String, BitArray> {
  PrefixEncoder(this._dictionary) : assert(_dictionary.isNotEmpty);

  final PrefixDictionary _dictionary;

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

class PrefixDecoder extends Converter<BitArray, String> {
  PrefixDecoder(PrefixDictionary dictionary)
      : assert(dictionary.isNotEmpty),
        _root = PrefixUnitNode.fromDictionary(dictionary);

  final PrefixUnitNode<void> _root;

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
